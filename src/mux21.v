module mux21 (
    input  a,
    input  b,
    input  sel,
    output f
);
  assign f = (a & ~sel) | (b & sel);
endmodule
