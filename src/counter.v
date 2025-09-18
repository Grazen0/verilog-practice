module counter (
    input wire clk,
    input wire reset,
    output reg [7:0] out
);
  always @(posedge clk) out <= out + 1;

  always @reset
    if (reset) assign out = 0;
    else deassign out;

endmodule
