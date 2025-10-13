module fp_align #(
    parameter P = 23
) (
    input wire clk,
    input wire rst_n,

    input wire valid_in,
    input wire ready_out,
    input wire [P-1:0] mant_a,
    input wire [7:0] exp_a,
    input wire [P-1:0] mant_b,
    input wire [7:0] exp_b,

    output reg valid_out,
    output wire ready_in,
    output reg [P+3:0] mant_a_aligned,
    output reg [P+3:0] mant_b_aligned,
    output reg [7:0] bigger_exp
);
  assign ready_in = ready_out;

  reg [P+3:0] mant_a_aligned_next, mant_b_aligned_next;
  reg [7:0] bigger_exp_next;

  reg [7:0] shamt;

  wire signed [8:0] exp_diff = exp_a - exp_b;
  wire [P:0] mant_a_full = (exp_a == 0) ? {1'b0, mant_a} : {1'b1, mant_a};
  wire [P:0] mant_b_full = (exp_b == 0) ? {1'b0, mant_b} : {1'b1, mant_b};

  always @(*) begin
    if (!ready_out) begin
      bigger_exp_next = bigger_exp;
      mant_a_aligned_next = mant_a_aligned;
      mant_b_aligned_next = mant_b_aligned;
    end else begin
      if (exp_diff >= 0) begin
        // a >= b
        bigger_exp_next = exp_a;
        mant_a_aligned_next = {mant_a_full, 3'b000};
        mant_b_aligned_next = {mant_b_full, 3'b000} >> exp_diff[7:0];
      end else begin
        // a < b
        bigger_exp_next = exp_b;
        mant_a_aligned_next = {mant_a_full, 3'b000} >> -exp_diff[7:0];
        mant_b_aligned_next = {mant_b_full, 3'b000};
      end
    end
  end

  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      mant_a_aligned <= {(P + 4) {1'b0}};
      mant_b_aligned <= {(P + 4) {1'b0}};
      bigger_exp     <= 8'b0;

      valid_out      <= 1'b0;
    end else begin
      mant_a_aligned <= mant_a_aligned_next;
      mant_b_aligned <= mant_b_aligned_next;
      bigger_exp <= bigger_exp_next;

      valid_out <= !ready_out ? valid_out : valid_in;
    end
  end
endmodule

module fp_addsub #(
    parameter P = 23
) (
    input wire clk,
    input wire rst_n,

    input wire valid_in,
    input wire ready_out,
    input wire [P+3:0] mant_a_aligned,
    input wire [P+3:0] mant_b_aligned,

    output reg valid_out,
    output wire ready_in,
    output reg [P+3:0] sum,
    output reg carry
);
  assign ready_in = ready_out;

  reg [P+3:0] sum_next;
  reg carry_next;

  always @(*) begin
    if (valid_in && ready_in) begin
      {carry_next, sum_next} = mant_a_aligned + mant_b_aligned;
    end else begin
      {carry_next, sum_next} = {carry, sum};
    end
  end

  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      sum       <= {(P + 3) {1'b0}};
      carry     <= 1'b0;

      valid_out <= 1'b0;
    end else begin
      sum <= sum_next;
      carry <= carry_next;

      valid_out <= !ready_out ? valid_out : valid_in;
    end
  end
endmodule

module fp_normalize #(
    parameter P = 23
) (
    input wire clk,
    input wire rst_n,

    input wire valid_in,
    input wire ready_out,
    input wire [P+3:0] mant_in,
    input wire [7:0] exp_in,

    output reg valid_out,
    output wire ready_in,
    output reg [P+3:0] mant_out,
    output reg [7:0] exp_out
);
  reg busy;

  reg [P+3:0] mant_next;
  reg [7:0] exp_next;
  reg valid_out_next;

  // TODO: this stays at 0. Need to modify the condition.
  assign ready_in = (valid_out && ready_out);

  always @(*) begin
    mant_next = (valid_in && ready_in) ? mant_in : valid_out ? mant_out : (mant_out << 1);
    exp_next = (valid_in && ready_in) ? exp_in : valid_out ? exp_out : (exp_out - 1);
    valid_out_next = mant_next[P+3];
  end

  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      mant_out  <= {(P + 4) {1'b0}};
      exp_out   <= 8'b0;

      valid_out <= 1'b0;
    end else begin
      mant_out  <= mant_next;
      exp_out   <= exp_next;

      valid_out <= valid_out_next;
    end
  end
endmodule

module float_alu #(
    parameter P = 23
) (
    input wire clk,
    input wire rst_n,
    input wire [31:0] op_a,
    input wire [31:0] op_b,
    input wire [2:0] op_code,
    input wire mode_fp,
    input wire round_mode,
    input wire start,
    output wire [31:0] result,
    output wire valid_out,
    output wire [4:0] flags
);
  wire sign_a = op_a[31];
  wire sign_b = op_b[31];

  wire [7:0] exp_a = op_a[P+7:P];
  wire [7:0] exp_b = op_b[P+7:P];

  wire [P-1:0] mant_a = op_a[P-1:0];
  wire [P-1:0] mant_b = op_b[P-1:0];

  wire align_valid, align_ready;
  wire [P+3:0] mant_a_aligned, mant_b_aligned;
  wire [7:0] bigger_exp;

  fp_align align (
      .clk  (clk),
      .rst_n(rst_n),

      .valid_in(start),
      .ready_out(addsub_ready),
      .mant_a(mant_a),
      .exp_a(exp_a),
      .mant_b(mant_b),
      .exp_b(exp_b),

      .valid_out(align_valid),
      .ready_in(align_ready),
      .mant_a_aligned(mant_a_aligned),
      .mant_b_aligned(mant_b_aligned),
      .bigger_exp(bigger_exp)
  );

  wire [P+3:0] sum;
  wire carry;
  wire normalize_valid, normalize_ready;

  fp_addsub addsub (
      .clk  (clk),
      .rst_n(rst_n),

      .valid_in(align_valid),
      .ready_out(normalize_ready),
      .mant_a_aligned(mant_a_aligned),
      .mant_b_aligned(mant_b_aligned),

      .valid_out(normalize_valid),
      .ready_in(addsub_ready),
      .sum(sum),
      .carry(carry)
  );

  wire [P+3:0] mant_normalized;
  wire [  7:0] exp_normalized;

  fp_normalize normalize (
      .clk  (clk),
      .rst_n(rst_n),

      .valid_in(normalize_valid),
      .ready_out(1'b1),
      .mant_in(sum),
      .exp_in(bigger_exp),

      .ready_in (normalize_ready),
      .valid_out(round_valid),
      .mant_out (mant_normalized),
      .exp_out  (exp_normalized)
  );


  // // Normalization
  // reg [  7:0] norm_exp;
  // reg [P+3:0] norm_mant;
  //
  // always @(*) begin
  //   if (add) begin
  //     if (carry) begin
  //       norm_exp  = bigger_exp + 1;
  //       norm_mant = sum >> 1;
  //     end else begin
  //       norm_exp  = bigger_exp;
  //       norm_mant = sum;
  //     end
  //   end else begin
  //     // TODO: normalize subtraction
  //     norm_exp  = bigger_exp;
  //     norm_mant = sum;
  //   end
  // end

  // // Rounding
  // wire rr = norm_mant[3];
  // wire m0 = norm_mant[2];
  // wire ss = |norm_mant[1:0];
  //
  // reg  round;
  //
  // localparam ROUND_NEAREST_EVEN = 1'b0;
  // localparam ROUND_ZERO = 1'b1;
  //
  // always @(*) begin
  //   case (round_mode)
  //     ROUND_NEAREST_EVEN: round = rr & (m0 | ss);
  //     ROUND_ZERO: round = 1'b0;
  //   endcase
  // end
  //
  // reg [26:0] rounded_mant;
  // reg round_carry;
  //
  // always @(*) begin
  //   if (round) begin
  //     {round_carry, rounded_mant} = norm_mant + 'b1000;
  //   end else begin
  //     round_carry  = 1'b0;
  //     rounded_mant = norm_mant;
  //   end
  // end
  //
  // // Renormalization
  // reg [P+3:0] final_mant;
  // reg [  7:0] final_exp;
  //
  // always @(*) begin
  //   if (round_carry) begin
  //     final_exp  = norm_exp + 1;
  //     final_mant = rounded_mant >> 1;
  //   end else begin
  //     final_exp  = norm_exp;
  //     final_mant = rounded_mant;
  //   end
  // end
  //
  // reg final_sign;
  //
  // always @(*) begin
  //   if (add) begin
  //     final_sign = sign_a;
  //   end else begin
  //     if (mant_a_aligned >= mant_b_aligned) begin
  //       final_sign = sign_a;
  //     end else begin
  //       final_sign = sign_b;
  //     end
  //   end
  // end
  //
  // assign result = {final_sign, final_exp, final_mant[P+2:3]};
endmodule
