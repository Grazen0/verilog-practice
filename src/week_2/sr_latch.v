module sr_latch (
    input  wire set,
    input  wire reset,
    output wire q,
    output wire nq
);
  nor n1 (q, reset, nq);
  nor n2 (nq, set, q);
endmodule
