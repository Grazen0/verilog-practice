module shifter_tb ();
  reg clk, rst, load;
  reg  [7:0] data;
  wire [7:0] out;

  shifter s1 (
      .clk (clk),
      .rst (rst),
      .load(load),
      .data(data),
      .out (out)
  );

  always #5 clk = ~clk;

  initial begin
    $dumpvars(0, shifter_tb);

    clk  = 0;
    rst  = 1;
    data = 8'b1010_1100;
    load = 1;

    #8 load = 0;
    #10 load = 1;

    #30 data = 8'b1111_0000;

    #200 $finish();
  end
endmodule
