`timescale 1ns / 1ps

module dff_tb ();
  reg clk, rst, d;
  wire q;

  dff dff (
      .clk(clk),
      .rst(rst),
      .d  (d),
      .q  (q)
  );

  always #5 clk = ~clk;

  initial begin
    $dumpvars(0, dff_tb);

    clk = 1;
    d   = 0;
    rst = 1;

    #7 d = 1;
    #10 rst = 0;

    #10 $finish();
  end
endmodule
