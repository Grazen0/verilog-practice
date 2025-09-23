module snail_tb ();
  reg clk, rst, d;
  wire q;

  always #5 clk = ~clk;

  snail s1 (
      .clk(clk),
      .rst(rst),
      .d  (d),
      .q  (q)
  );

  initial begin
    $dumpvars(0, snail_tb);

    clk = 0;
    rst = 1;
    #8;
    rst = 0;
    d   = 1;
    #10;
    d = 1;
    #10;
    d = 0;
    #10;
    d = 1;
    #20;
    $finish();
  end
endmodule
