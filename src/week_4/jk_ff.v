module jk_ff (
    input  clk,
    input  j,
    input  k,
    output q,
    output nq
);
  wire w1, w2;

  not n1 (w1, k);

  mux21 m1 (
      .a  (j),
      .b  (w1),
      .sel(q),
      .f  (w2)
  );

  d_ff d1 (
      .clk(clk),
      .reset(1),
      .enable(1),
      .d(w2),
      .q(q),
      .nq(nq)
  );
endmodule
