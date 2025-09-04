module d_latch (
    input  d,
    input  we,
    output q,
    output nq
);
  sr_latch sr1 (
      .set(d & we),
      .reset(~d & we),
      .q(q),
      .nq(nq)
  );
endmodule
