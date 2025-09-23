`timescale 1ns / 1ps

module jkff_counter_tb ();
  reg clk, rst_n, j, k;
  wire [3:0] q;

  jkff_counter c1 (
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
    rst_n = 1;
    j = 1;
    k = 1;
    #10;
    rst_n = 0;
    #200;
    rst_n = 1;
    #10;
    rst_n = 0;
    #100;
    $finish();
  end

endmodule
