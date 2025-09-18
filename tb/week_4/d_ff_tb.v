`timescale 1ns / 1ps

module d_ff_tb ();
  reg clk, reset, enable, d;
  wire q, nq;

  d_ff dff (
      .clk(clk),
      .reset(reset),
      .enable(enable),
      .d(d),
      .q(q),
      .nq(nq)
  );

  always #5 clk = ~clk;

  initial begin
    $dumpvars(0, d_ff_tb);

    clk = 1;
    d = 0;
    enable = 1;
    reset = 1;

    #7 d = 1;
    #10 reset = 0;

    #10 $finish();
  end
endmodule
