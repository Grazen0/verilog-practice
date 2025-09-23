module shifter (
    input wire clk,
    input wire rst_n,
    input wire load,
    input wire [7:0] data,
    output reg [7:0] out
);

  always @(posedge clk, negedge load, negedge rst_n)
    if (~rst_n) out <= 8'b0;
    else if (~load) out <= data;
    else out <= out >> 1;
endmodule
