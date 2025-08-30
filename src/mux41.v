module mux41 (
    input a,
    input b,
    input c,
    input d,
    input [1:0] sel,
    output f
);
  wire w1, w2;

  mux21 m1 (
      .f  (w1),
      .a  (a),
      .b  (b),
      .sel(sel[0])
  );
  mux21 m2 (
      .f  (w2),
      .a  (c),
      .b  (d),
      .sel(sel[0])
  );
  mux21 m3 (
      .f  (f),
      .a  (w1),
      .b  (w2),
      .sel(sel[1])
  );
endmodule
