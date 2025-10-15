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
    input wire sign_a,
    input wire sign_b,

    output reg valid_out,
    output wire ready_in,
    output reg [P+3:0] mant_a_aligned,
    output reg [P+3:0] mant_b_aligned,
    output reg [7:0] bigger_exp,
    output reg sign_a_aligned,
    output reg sign_b_aligned,

    input  wire round_mode_in,
    output reg  round_mode_out
);
  assign ready_in = ready_out;

  reg [P+3:0] mant_a_aligned_next, mant_b_aligned_next;
  reg [7:0] bigger_exp_next;

  reg sign_a_aligned_next, sign_b_aligned_next, round_mode_out_next;

  wire signed [8:0] exp_diff = exp_a - exp_b;
  wire [P:0] mant_a_full = exp_a == 0 ? {1'b0, mant_a} : {1'b1, mant_a};
  wire [P:0] mant_b_full = exp_b == 0 ? {1'b0, mant_b} : {1'b1, mant_b};

  always @(*) begin
    if (valid_in && ready_in) begin
      sign_a_aligned_next = sign_a;
      sign_b_aligned_next = sign_b;
      round_mode_out_next = round_mode_in;

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
    end else begin
      // Keep current outputs
      bigger_exp_next = bigger_exp;
      mant_a_aligned_next = mant_a_aligned;
      mant_b_aligned_next = mant_b_aligned;
      sign_a_aligned_next = sign_a_aligned;
      sign_b_aligned_next = sign_b_aligned;
      round_mode_out_next = round_mode_out;
    end
  end


  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      mant_a_aligned <= {(P + 4) {1'b0}};
      mant_b_aligned <= {(P + 4) {1'b0}};
      bigger_exp     <= 8'b0;
      sign_a_aligned <= 1'b0;
      sign_b_aligned <= 1'b0;

      valid_out      <= 1'b0;

      round_mode_out <= 1'b0;
    end else begin
      mant_a_aligned <= mant_a_aligned_next;
      mant_b_aligned <= mant_b_aligned_next;
      bigger_exp <= bigger_exp_next;
      sign_a_aligned <= sign_a_aligned_next;
      sign_b_aligned <= sign_b_aligned_next;

      valid_out <= !ready_out ? valid_out : valid_in;

      round_mode_out <= round_mode_out_next;
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
    input wire sign_a,
    input wire sign_b,

    output reg valid_out,
    output wire ready_in,
    output reg [P+3:0] sum,
    output reg carry_out,
    output reg sign_out,

    input wire [7:0] exp_in,
    output reg [7:0] exp_out,
    input wire round_mode_in,
    output reg round_mode_out
);
  assign ready_in = ready_out;

  reg [P+3:0] sum_next;
  reg carry_out_next, sign_out_next;

  reg [P+3:0] mant_big, mant_small;
  reg sign_big;

  reg [7:0] exp_out_next;
  reg round_mode_out_next;

  always @(*) begin
    if (valid_in && ready_in) begin
      exp_out_next = exp_in;
      round_mode_out_next = round_mode_in;

      if (mant_a_aligned >= mant_b_aligned) begin
        mant_big   = mant_a_aligned;
        mant_small = mant_b_aligned;
        sign_big   = sign_a;
      end else begin
        mant_big   = mant_b_aligned;
        mant_small = mant_a_aligned;
        sign_big   = sign_b;
      end

      if (sign_a == sign_b) begin
        {carry_out_next, sum_next} = mant_a_aligned + mant_b_aligned;
        sign_out_next = sign_a;
      end else begin
        sum_next = mant_big - mant_small;
        carry_out_next = 1'b0;
        sign_out_next = sign_big;
      end
    end else begin
      // Keep current outputs
      sum_next = sum;
      carry_out_next = carry_out;
      sign_out_next = sign_out;

      exp_out_next = exp_out;
      round_mode_out_next = round_mode_out;
    end
  end

  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      sum            <= {(P + 3) {1'b0}};
      carry_out      <= 1'b0;
      sign_out       <= 1'b0;

      valid_out      <= 1'b0;

      exp_out        <= 8'b0;
      round_mode_out <= 1'b0;
    end else begin
      sum            <= sum_next;
      carry_out      <= carry_out_next;
      sign_out       <= sign_out_next;

      valid_out      <= !ready_out ? valid_out : valid_in;

      exp_out        <= exp_out_next;
      round_mode_out <= round_mode_out_next;
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
    input wire carry,

    output reg valid_out,
    output wire ready_in,
    output reg [P+3:0] mant_out,
    output reg [7:0] exp_out,

    input  wire sign_in,
    output reg  sign_out,
    input  wire round_mode_in,
    output reg  round_mode_out
);
  reg busy;

  reg [P+3:0] mant_next;
  reg [7:0] exp_next;

  reg valid_out_next, busy_next;

  reg sign_out_next, round_mode_out_next;

  assign ready_in = !busy && ready_out;

  always @(*) begin
    if (valid_in && ready_in) begin
      // Use stage inputs
      sign_out_next = sign_in;
      round_mode_out_next = round_mode_in;

      if (carry) begin
        if (exp_in == 8'hFF) begin
          // Infinity
          mant_next = mant_in;
          exp_next  = exp_in;
        end else begin
          mant_next = {1'b1, mant_in[P+3:1]};
          exp_next  = exp_in + 1;
        end
      end else begin
        mant_next = mant_in;
        exp_next  = exp_in;
      end
    end else begin
      // Work with current data
      if (valid_out || exp_out == 0) begin
        mant_next = mant_out;
        exp_next  = exp_out;
      end else begin
        mant_next = mant_out << 1;
        exp_next  = exp_out - 1;
      end

      sign_out_next = sign_out;
      round_mode_out_next = round_mode_out;
    end

    valid_out_next = (busy || (valid_in && ready_in))
    && (mant_next == 0 || mant_next[P+3] || exp_out == 0 || exp_out == 8'hFF);
    busy_next = (busy || (valid_in && ready_in)) && !valid_out_next;
  end

  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      mant_out <= {(P + 4) {1'b0}};
      exp_out <= 8'b0;

      valid_out <= 1'b0;
      busy <= 1'b0;

      sign_out <= 1'b0;
      round_mode_out <= 1'b0;
    end else begin
      mant_out <= mant_next;
      exp_out <= exp_next;

      valid_out <= valid_out_next;
      busy <= busy_next;

      sign_out <= sign_out_next;
      round_mode_out <= round_mode_out_next;
    end
  end
endmodule

module fp_round #(
    parameter P = 23
) (
    input wire clk,
    input wire rst_n,

    input wire valid_in,
    input wire ready_out,
    input wire [P+3:0] mant_in,
    input wire round_mode,

    output reg valid_out,
    output wire ready_in,
    output reg [P+3:0] mant_rounded,
    output reg carry_out,

    input wire [7:0] exp_in,
    output reg [7:0] exp_out,
    input wire sign_in,
    output reg sign_out
);
  localparam ROUND_NEAREST_EVEN = 1'b0;
  localparam ROUND_ZERO = 1'b1;

  reg [P+3:0] mant_rounded_next;
  reg carry_out_next;

  reg [7:0] exp_out_next;
  reg sign_out_next;

  wire rr = mant_in[3];
  wire m0 = mant_in[2];
  wire ss = |mant_in[1:0];

  reg round;

  assign ready_in = ready_out;

  always @(*) begin
    if (valid_in && ready_in) begin
      // Use stage inputs
      exp_out_next  = exp_in;
      sign_out_next = sign_in;

      case (round_mode)
        ROUND_NEAREST_EVEN: round = rr & (m0 | ss);
        ROUND_ZERO: round = 1'b0;
      endcase

      if (round) begin
        {carry_out_next, mant_rounded_next} = mant_in + 'b1000;
      end else begin
        mant_rounded_next = mant_in;
        carry_out_next = 1'b0;
      end
    end else begin
      // Use existing data
      mant_rounded_next = mant_rounded;
      carry_out_next = carry_out;

      exp_out_next = exp_out;
      sign_out_next = sign_out;
    end
  end

  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      mant_rounded <= {(P + 4) {1'b0}};
      carry_out    <= 1'b0;

      valid_out    <= 1'b0;

      exp_out      <= 8'b0;
      sign_out     <= 1'b0;
    end else begin
      mant_rounded <= mant_rounded_next;
      carry_out <= carry_out_next;

      valid_out <= !ready_out ? valid_out : valid_in;

      exp_out <= exp_out_next;
      sign_out <= sign_out_next;
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

  wire round_mode_aligned;

  fp_align align (
      .clk  (clk),
      .rst_n(rst_n),

      .valid_in(start),
      .ready_out(addsub_ready),
      .mant_a(mant_a),
      .exp_a(exp_a),
      .mant_b(mant_b),
      .exp_b(exp_b),
      .sign_a(sign_a),
      .sign_b(sign_b),

      .valid_out(align_valid),
      .ready_in(align_ready),
      .mant_a_aligned(mant_a_aligned),
      .mant_b_aligned(mant_b_aligned),
      .bigger_exp(bigger_exp),
      .sign_a_aligned(sign_a_aligned),
      .sign_b_aligned(sign_b_aligned),

      .round_mode_in (round_mode),
      .round_mode_out(round_mode_aligned)
  );

  wire [P+3:0] sum;
  wire sum_carry, sum_sign;
  wire normalize_valid, normalize_ready;

  wire [7:0] exp_addsub;
  wire round_mode_addsub;

  fp_addsub addsub (
      .clk  (clk),
      .rst_n(rst_n),

      .valid_in(align_valid),
      .ready_out(normalize_ready),
      .mant_a_aligned(mant_a_aligned),
      .mant_b_aligned(mant_b_aligned),
      .sign_a(sign_a_aligned),
      .sign_b(sign_b_aligned),

      .valid_out(normalize_valid),
      .ready_in(addsub_ready),
      .sum(sum),
      .carry_out(sum_carry),
      .sign_out(sum_sign),

      .exp_in(bigger_exp),
      .exp_out(exp_addsub),
      .round_mode_in(round_mode_aligned),
      .round_mode_out(round_mode_addsub)
  );

  wire [P+3:0] mant_normalized;
  wire [7:0] exp_normalized;
  wire sign_normalized;
  wire round_mode_normalized;

  fp_normalize normalize (
      .clk  (clk),
      .rst_n(rst_n),

      .valid_in(normalize_valid),
      .ready_out(round_ready),
      .mant_in(sum),
      .exp_in(exp_addsub),
      .carry(sum_carry),

      .ready_in (normalize_ready),
      .valid_out(round_valid),
      .mant_out (mant_normalized),
      .exp_out  (exp_normalized),

      .sign_in (sum_sign),
      .sign_out(sign_normalized),

      .round_mode_in (round_mode_addsub),
      .round_mode_out(round_mode_normalized)
  );

  wire round_ready;
  wire sign_rounded;
  wire [P+3:0] mant_rounded;
  wire [7:0] exp_rounded;
  wire round_carry;

  wire renormalize_ready;

  fp_round round (
      .clk  (clk),
      .rst_n(rst_n),

      .valid_in(round_valid),
      .ready_out(renormalize_ready),
      .mant_in(mant_normalized),
      .round_mode(round_mode_normalized),

      .ready_in(round_ready),
      .valid_out(renormalize_valid),
      .mant_rounded(mant_rounded),
      .carry_out(round_carry),

      .exp_in  (exp_normalized),
      .exp_out (exp_rounded),
      .sign_in (sign_normalized),
      .sign_out(sign_rounded)
  );

  wire [P+3:0] mant_renormalized;
  wire [7:0] exp_renormalized;
  wire sign_renormalized;

  fp_normalize renormalize (
      .clk  (clk),
      .rst_n(rst_n),

      .valid_in(renormalize_valid),
      .ready_out(1'b1),
      .mant_in(mant_rounded),
      .exp_in(exp_rounded),
      .carry(round_carry),

      .ready_in (renormalize_ready),
      .valid_out(valid_out),
      .mant_out (mant_renormalized),
      .exp_out  (exp_renormalized),

      .sign_in (sign_rounded),
      .sign_out(sign_renormalized)
  );

  assign result = {sign_renormalized, exp_renormalized, mant_renormalized[P+2:3]};
endmodule
