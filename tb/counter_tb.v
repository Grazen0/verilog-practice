module counter_tb ();
  reg clk, reset;
  wire [7:0] out;

  counter c1 (
      .clk  (clk),
      .reset(reset),
      .out  (out)
  );

  always #1 clk = ~clk;

  initial begin
    $dumpvars(0, counter_tb);

    clk = 0;
    #1 reset = 1;
    #4 reset = 0;

    #20 $finish();
  end
endmodule
