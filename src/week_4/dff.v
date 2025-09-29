module dff (
    input  wire clk,
    input  wire rst_n,
    input  wire d,
    output reg  q
);
    always @(posedge clk, negedge rst_n)
        if (~rst_n) q <= 0;
        else q <= d;
endmodule
