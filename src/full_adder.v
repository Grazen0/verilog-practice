module full_adder (
    output s,
    output c_out,
    input  a,
    input  b,
    input  c_in
);
  assign s = a ^ b ^ c_in;
  assign c_out = (a & b) | (a & c_in) | (b & c_in);
endmodule
