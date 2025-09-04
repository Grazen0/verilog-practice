module d_flip_flop (
    input  d,
    input  clk,
    output q,
    output nq
);
  wire w1;

  d_latch dl1 (
      .d (d),
      .we(~clk),
      .q (w1)
  );
  d_latch dl2 (
      .d (w1),
      .we(clk),
      .q (q),
      .nq(nq)
  );
endmodule
