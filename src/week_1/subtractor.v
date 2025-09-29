module subtractor (
    input  wire a,
    input  wire b,
    input  wire b_in,
    output wire d,
    output wire b_out
);
    assign d = (~a & ~b & b_in) | (~a & b & ~b_in) | (a & ~b & ~b_in) | (a & b & b_in);
    assign b_out = (~a & b_in) | (~a & b) | (b & b_in);
endmodule
