`timescale 1ns / 1ps

module jk_ff_tb ();
  reg clk, j, k;
  wire q, nq;

  jk_ff jk (
      .clk(clk),
      .j  (j),
      .k  (k),
      .q  (q),
      .nq (nq)
  );

  always #5 clk = ~clk;

  initial begin
    $dumpvars(0, jk_ff_tb);

    clk = 0;
    j   = 0;
    k   = 0;

    #2 j = 1;

    #10 j = 0;
    k = 1;

    #10 j = 1;

    #20 $finish();
  end
endmodule
