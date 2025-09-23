`timescale 1ns / 1ps

module jkff_tb ();
  reg clk, rst_n, j, k;
  wire q;

  jkff jk (
      .clk(clk),
      .rst_n(rst_n),
      .j(j),
      .k(k),
      .q(q)
  );

  always #5 clk = ~clk;

  initial begin
    $dumpvars();

    clk = 0;
    j   = 0;
    k   = 0;

    #2 j = 1;

    #10 j = 0;
    k = 1;

    #10 j = 0;
    k = 0;

    #20 j = 1;
    k = 1;

    #40 $finish();
  end
endmodule
