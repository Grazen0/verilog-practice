module tff (
    input  wire clk,
    input  wire rst,
    input  wire t,
    output reg  q
);
    always @(posedge clk, negedge rst)
        if (~rst) q <= 0;
        else if (t == 1) q <= ~q;
        else q <= q;
endmodule
