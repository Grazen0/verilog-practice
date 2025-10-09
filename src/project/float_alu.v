module fp_align #(
    parameter P = 23
) (
    input wire clk,
    input wire rst_n,
    input wire [P-1:0] mant_a,
    input wire [7:0] exp_a,
    input wire [P-1:0] mant_b,
    input wire [7:0] exp_b,
    input wire valid_in,
    output reg valid_out,
    output reg [P+3:0] mant_a_aligned,
    output reg [P+3:0] mant_b_aligned,
    output reg [7:0] bigger_exp
);
  reg [P+3:0] mant_a_aligned_next, mant_b_aligned_next;
  reg [7:0] bigger_exp_next;

  reg [7:0] shamt;
  reg shift_select;

  wire signed [8:0] exp_diff = exp_a - exp_b;
  wire [P:0] mant_a_full = (exp_a == 0) ? {1'b0, mant_a} : {1'b1, mant_a};
  wire [P:0] mant_b_full = (exp_b == 0) ? {1'b0, mant_b} : {1'b1, mant_b};

  always @(*) begin
    mant_a_aligned_next = {{(P + 4) {1'b0}}};
    mant_b_aligned_next = {{(P + 4) {1'b0}}};
    bigger_exp_next = 8'd0;
    shift_select = 1'b0;
    shamt = 8'd0;

    if (exp_diff >= 0) begin
      shift_select = 1'b1;  // a >= b
      shamt = exp_diff[7:0];
    end else begin
      shift_select = 1'b0;  // a < b
      shamt = -exp_diff[7:0];
    end

    if (shift_select) begin
      // Shift B
      bigger_exp_next = exp_a;
      mant_a_aligned_next = {mant_a_full, 3'b000};
      mant_b_aligned_next = {mant_b_full, 3'b000} >> shamt;
    end else begin
      // Shift A
      bigger_exp_next = exp_b;
      mant_a_aligned_next = {mant_a_full, 3'b000} >> shamt;
      mant_b_aligned_next = {mant_b_full, 3'b000};
    end
  end

  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      valid_out      <= 1'b0;
      mant_a_aligned <= {(P + 4) {1'b0}};
      mant_b_aligned <= {(P + 4) {1'b0}};
      bigger_exp     <= 8'b0;
    end else begin
      valid_out <= valid_in;

      if (valid_in) begin
        mant_a_aligned <= mant_a_aligned_next;
        mant_b_aligned <= mant_b_aligned_next;
        bigger_exp <= bigger_exp_next;
      end
    end
  end
endmodule

module fp_addsub #(
    parameter P = 23
) (
    input wire clk,
    input wire rst_n,
    input wire [P+3:0] mant_a_aligned,
    input wire [P+3:0] mant_b_aligned,
    input wire valid_in,
    input wire ready_out,
    output reg valid_out,
    output reg [P+3:0] sum,
    output reg carry
);
  reg [P+3:0] sum_next;
  reg carry_next;

  always @(*) begin
    {carry_next, sum_next} <= mant_a_aligned + mant_b_aligned;
  end

  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      sum       <= {(P + 3) {1'b0}};
      carry     <= 1'b0;
      valid_out <= 1'b0;
    end else begin
      if (ready_out) begin
        valid_out <= valid_in;
        if (valid_in) begin
          sum   <= sum_next;
          carry <= carry_next;
        end
      end
    end
  end
endmodule

module fp_normalize #(
    parameter P = 23
) (
    input wire clk,
    input wire rst_n,

    input wire valid_in,
    output wire ready_in,
    input wire [P+3:0] mant_in,
    input wire [7:0] exp_in,

    output reg valid_out,
    input wire ready_out,
    output reg [P+3:0] mant_out,
    output reg [7:0] exp_out
);
  reg busy;
  reg [P+3:0] mant_reg;
  reg [7:9] exp_reg;

  assign ready_in = !busy;

  reg [P+3:0] mant_next;
  reg [7:0] exp_next;
  reg mant_ready;

  always @(*) begin
    mant_next  = mant_reg << 1;
    exp_next   = exp_reg - 1;
    mant_ready = mant_next[P+3];
  end

  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      busy <= 1'b0;
      valid_out <= 1'b0;
      mant_reg <= {(P + 4) {1'b0}};
      exp_reg <= 8'b0;
      mant_out <= {(P + 4) {1'b0}};
      exp_out <= 8'b0;
    end else begin
      if (valid_in && ready_in) begin
        mant_reg <= mant_in;
        exp_reg <= exp_in;
        busy <= 1'b1;
      end

      mant_reg <= mant_next;
      exp_reg  <= exp_next;

      if (mant_ready) begin
        mant_out <= mant_next;
        exp_out <= exp_next;
        valid_out <= 1'b1;
        busy <= 1'b0;
      end


      if (valid_out && ready_out) begin
        valid_out <= 1'b0;
      end
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
  // reg [31:0] op_a_latch, op_b_latch;
  // reg round_mode_latch, mode_fp_latch;

  // always @(posedge clk or negedge rst_n) begin
  //   if (!rst_n) begin
  //     op_a_latch <= 0;
  //     op_b_latch <= 0;
  //     round_mode_latch <= 0;
  //   end else if (start) begin
  //     op_a_latch <= op_a;
  //     op_b_latch <= op_b;
  //     round_mode_latch <= round_mode;
  //     mode_fp_latch <= mode_fp;
  //   end
  // end

  // fp_adder_control control (
  //     .clk(clk),
  //     .rst_n(rst_n),
  //     .start(start),
  //     .align_start(align_start),
  //     .align_done(align_done)
  // );

  wire sign_a = op_a[31];
  wire sign_b = op_b[31];

  wire [7:0] exp_a = op_a[P+7:P];
  wire [7:0] exp_b = op_b[P+7:P];

  wire [P-1:0] mant_a = op_a[P-1:0];
  wire [P-1:0] mant_b = op_b[P-1:0];

  wire addsub_valid;
  wire [P+3:0] mant_a_aligned, mant_b_aligned;
  wire [7:0] bigger_exp;

  fp_align align (
      .clk(clk),
      .rst_n(rst_n),
      .valid_in(start),
      .mant_a(mant_a),
      .exp_a(exp_a),
      .mant_b(mant_b),
      .exp_b(exp_b),
      .mant_a_aligned(mant_a_aligned),
      .mant_b_aligned(mant_b_aligned),
      .bigger_exp(bigger_exp),
      .valid_out(addsub_valid)
  );

  wire [P+3:0] sum;
  wire carry;
  wire normalize_valid, normalize_ready;

  fp_addsub addsub (
      .clk(clk),
      .rst_n(rst_n),
      .mant_a_aligned(mant_a_aligned),
      .mant_b_aligned(mant_b_aligned),
      .valid_in(addsub_valid),
      .valid_out(normalize_valid),
      .ready_out(normalize_ready),
      .sum(sum),
      .carry(carry)
  );

  fp_normalize normalize (
      .clk  (clk),
      .rst_n(rst_n),

      .mant_in(sum),
      .exp_in (bigger_exp),

      .valid_in (normalize_valid),
      .ready_in (normalize_ready),
      .valid_out(round_valid),
      .ready_out(round_ready)
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
  //
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
