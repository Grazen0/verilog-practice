module mux21 (
    input  wire a,
    input  wire b,
    input  wire sel,
    output wire f
);
  assign f = (a & ~sel) | (b & sel);
endmodule
