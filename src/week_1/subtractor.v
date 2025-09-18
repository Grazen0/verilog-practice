module subtractor (
    input  a,
    input  b,
    input  b_in,
    output d,
    output b_out
);
  assign d = (~a & ~b & b_in) | (~a & b & ~b_in) | (a & ~b & ~b_in) | (a & b & b_in);
  assign b_out = (~a & b_in) | (~a & b) | (b & b_in);
endmodule
