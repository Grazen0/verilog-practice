module mux41 (
    input wire a,
    input wire b,
    input wire c,
    input wire d,
    input wire [1:0] sel,
    output wire f
);
    wire w1, w2;

    mux21 m1 (
        .f  (w1),
        .a  (a),
        .b  (b),
        .sel(sel[0])
    );
    mux21 m2 (
        .f  (w2),
        .a  (c),
        .b  (d),
        .sel(sel[0])
    );
    mux21 m3 (
        .f  (f),
        .a  (w1),
        .b  (w2),
        .sel(sel[1])
    );
endmodule
