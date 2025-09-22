`timescale 1ns / 1ps

module jkff_counter_tb ();
  reg clk, rst, j, k;
  wire [3:0] q;

  jkff_counter c1 (
      .clk(clk),
      .rst(rst),
      .j  (j),
      .k  (k),
      .q  (q)
  );

  always #5 clk = ~clk;

  initial begin
    $dumpvars();

    clk = 0;
    rst = 1;
    j   = 1;
    k   = 1;
    #10;
    rst = 0;
    #200;
    rst = 1;
    #10;
    rst = 0;
    #100;
    $finish();
  end

endmodule
