module d_ff (
    input clk,
    input reset,
    input d,
    input enable,
    output reg q,
    output nq
);
  always @(posedge clk, negedge reset)
    if (reset == 0) q <= 0;
    else if (enable == 1) q <= d;

  assign nq = ~q;
endmodule
