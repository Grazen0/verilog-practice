module d_latch (
    input  wire d,
    input  wire we,
    output wire q,
    output wire nq
);
    sr_latch sr1 (
        .set(d & we),
        .reset(~d & we),
        .q(q),
        .nq(nq)
    );
endmodule
