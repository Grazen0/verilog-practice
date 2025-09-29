module jkff_counter (
    input wire clk,
    input wire rst_n,
    input wire j,
    input wire k,
    output wire [3:0] q
);
    jkff jk1 (
        .clk(clk),
        .rst_n(rst_n),
        .j(j),
        .k(k),
        .q(q[0])
    );
    jkff jk2 (
        .clk(clk),
        .rst_n(rst_n),
        .j(q[0]),
        .k(q[0]),
        .q(q[1])
    );
    jkff jk3 (
        .clk(clk),
        .rst_n(rst_n),
        .j(q[1]),
        .k(q[0]),
        .q(q[2])
    );
    jkff jk4 (
        .clk(clk),
        .rst_n(rst_n),
        .j(q[2]),
        .k(q[2]),
        .q(q[3])
    );
endmodule

