module thunderbird_tb ();
  reg clk, rst, left, right;
  wire l0, l1, l2, r0, r1, r2;

  thunderbird t1 (
      .clk(clk),
      .rst(rst),
      .left(left),
      .right(right),
      .l0(l0),
      .l1(l1),
      .l2(l2),
      .r0(r0),
      .r1(r1),
      .r2(r2)
  );

  always #5 clk = ~clk;

  initial begin
    $dumpvars(0, thunderbird_tb);

    clk   = 0;
    rst   = 1;
    left  = 0;
    right = 0;
    #8;
    rst  = 0;
    left = 1;
    #60;
    left  = 0;
    right = 1;
    #50;
    right = 0;
    #40;
    $finish();
  end
endmodule
