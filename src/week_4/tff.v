module tff (
    input clk,
    input t,
    output reg q
);
  always @(posedge clk) if (t == 1) q = ~q;
endmodule
