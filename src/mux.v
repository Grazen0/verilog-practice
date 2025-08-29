module mux (
    output f,
    input  a,
    input  b,
    input  sel
);
  assign f = (a & !sel) | (a & sel);
endmodule
