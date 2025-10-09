`timescale 1ns / 1ps

module float_alu_tb ();
  reg clk, rst_n, start;
  reg [31:0] op_a, op_b;

  wire [31:0] result;
  wire valid_out;

  always #5 clk = ~clk;

  float_alu alu (
      .clk(clk),
      .rst_n(rst_n),
      .op_a(op_a),
      .op_b(op_b),
      .round_mode(1'b0),  // Nearest even
      .start(start),
      .result(result),
      .valid_out(valid_out)
  );

  initial begin
    $dumpvars(0, float_alu_tb);

    clk   = 1;
    rst_n = 0;

    #5;

    rst_n = 1;
    start = 1;
    op_a  = 32'b1_10000011_01001100000000000000000;  // 20.75
    op_b  = 32'b0_10000000_00100000000000000000000;  // 2.25

    #10;

    start = 0;

    #200 $finish();
  end
endmodule
