module falu_control (
    input wire signed [7:0] exp_diff,
    output reg shift_select,
    output reg [7:0] shamt
);
  always @(*) begin
    if (exp_diff >= 0) begin
      shift_select = 1;  // b
      shamt = exp_diff;
    end else begin
      shift_select = 0;  // a
      shamt = -exp_diff;
    end
  end
endmodule

module float_alu (
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
  localparam P = 23;

  wire sign_a = op_a[31];
  wire sign_b = op_b[31];

  wire [7:0] exp_a = op_a[P+7:P];
  wire [7:0] exp_b = op_b[P+7:P];

  wire [P-1:0] mant_a = op_a[P-1:0];
  wire [P-1:0] mant_b = op_b[P-1:0];

  wire [P:0] mant_a_full = (exp_a == 0) ? {1'b0, mant_a} : {1'b1, mant_a};
  wire [P:0] mant_b_full = (exp_b == 0) ? {1'b0, mant_b} : {1'b1, mant_b};

  wire [7:0] shamt;
  wire shift_select;

  falu_control ctrl (
      .exp_diff(exp_a - exp_b),
      .shamt(shamt),
      .shift_select(shift_select)
  );

  reg [  7:0] bigger_exp;

  reg [P+3:0] mant_a_aligned;
  reg [P+3:0] mant_b_aligned;

  always @(*) begin
    case (shift_select)
      1'b0: begin
        bigger_exp = exp_b;
        mant_a_aligned = {mant_a_full, 3'b000} >> shamt;
        mant_b_aligned = {mant_b_full, 3'b000};
      end
      1'b1: begin
        bigger_exp = exp_a;
        mant_a_aligned = {mant_a_full, 3'b000};
        mant_b_aligned = {mant_b_full, 3'b000} >> shamt;
      end
    endcase
  end

  // Add
  wire add = sign_a == sign_b;

  wire [P+3:0] sum;
  wire carry;
  assign {carry, sum} = add ? mant_a_aligned + mant_b_aligned : mant_a_aligned - mant_b_aligned;

  // Normalization
  reg [  7:0] norm_exp;
  reg [P+3:0] norm_mant;

  always @(*) begin
    if (add) begin
      if (carry) begin
        norm_exp  = bigger_exp + 1;
        norm_mant = sum >> 1;
      end else begin
        norm_exp  = bigger_exp;
        norm_mant = sum;
      end
    end else begin
      // TODO: normalize subtraction
      norm_exp  = bigger_exp;
      norm_mant = sum;
    end
  end

  // Rounding
  wire rr = norm_mant[3];
  wire m0 = norm_mant[2];
  wire ss = |norm_mant[1:0];

  reg  round;

  localparam ROUND_NEAREST_EVEN = 1'b0;
  localparam ROUND_ZERO = 1'b1;

  always @(*) begin
    case (round_mode)
      ROUND_NEAREST_EVEN: round = rr & (m0 | ss);
      ROUND_ZERO: round = 1'b0;
    endcase
  end

  reg [26:0] rounded_mant;
  reg round_carry;

  always @(*) begin
    if (round) begin
      {round_carry, rounded_mant} = norm_mant + 'b1000;
    end else begin
      round_carry  = 1'b0;
      rounded_mant = norm_mant;
    end
  end

  // Renormalization
  reg [P+3:0] final_mant;
  reg [  7:0] final_exp;

  always @(*) begin
    if (round_carry) begin
      final_exp  = norm_exp + 1;
      final_mant = rounded_mant >> 1;
    end else begin
      final_exp  = norm_exp;
      final_mant = rounded_mant;
    end
  end

  reg final_sign;

  always @(*) begin
    if (add) begin
      final_sign = sign_a;
    end else begin
      if (mant_a_aligned >= mant_b_aligned) begin
        final_sign = sign_a;
      end else begin
        final_sign = sign_b;
      end
    end
  end

  assign result = {final_sign, final_exp, final_mant[P+2:3]};
endmodule
