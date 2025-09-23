module shifter (
    input clk,
    input rst,
    input load,
    input [7:0] data,
    output reg [7:0] out
);

  always @(posedge clk, negedge load, negedge rst)
    if (~rst) out <= 8'b0;
    else if (~load) out <= data;
    else out <= out >> 1;
endmodule
