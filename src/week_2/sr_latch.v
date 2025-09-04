module sr_latch (
    input  set,
    input  reset,
    output q,
    output nq
);
  nor n1 (q, reset, nq);
  nor n2 (nq, set, q);
endmodule
