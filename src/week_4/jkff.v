module jkff (
    input  wire clk,
    input  wire rst_n,
    input  wire j,
    input  wire k,
    output reg  q
);
    always @(posedge clk, negedge rst_n)
        if (~rst_n) q <= 0;
        else
            case ({
                j, k
            })
                2'b00: q <= q;
                2'b01: q <= 0;
                2'b10: q <= 1;
                2'b11: q <= ~q;
            endcase
endmodule
