module mux21 (
    output f,
    input  a,
    input  b,
    input  sel
);
  assign f = (a & ~sel) | (b & sel);
endmodule
