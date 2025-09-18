`timescale 1ns / 1ps

module tff_tb ();
  reg  clk;
  wire q;

  tff t1 (
      .clk(clk),
      .q  (q)
  );

  always #1 clk = ~clk;

  initial begin
    $dumpvars(0, tff_tb);

    clk = 0;

    #10 $finish();
  end

endmodule
