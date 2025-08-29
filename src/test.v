`timescale 1s / 1s

module test;

  /* Make a reset that pulses once. */
  reg reset = 0;
  initial begin
    $dumpfile("/dev/stdout");
    $dumpvars(0, test);

    #17 reset = 1;
    #11 reset = 0;
    #29 reset = 1;
    #5 reset = 0;
    #513 $finish;
  end

  /* Make a regular pulsing clock. */
  reg clk = 0;
  always #1 clk = !clk;

  wire [7:0] value;
  counter c1 (
      .out  (value),
      .clk  (clk),
      .reset(reset)
  );

  initial $monitor("At time %t, value = %h (%0d)", $time, value, value);
endmodule




