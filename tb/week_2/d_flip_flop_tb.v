module d_flip_flop_tb ();
  reg clk, d;
  wire q, nq;

  d_flip_flop ff1 (
      .d  (d),
      .clk(clk),
      .q  (q),
      .nq (nq)
  );

  always #10 clk = ~clk;

  initial begin
    $dumpvars(0, d_flip_flop_tb);

    clk = 0;
    d   = 0;

    #9 d = 1;
    #8 d = 0;
    #26 d = 1;
    #8 d = 0;

    #10 $finish();
  end
endmodule
