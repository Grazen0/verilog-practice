module snail (
    input  wire clk,
    input  wire rst,
    input  wire d,
    output wire q
);
  localparam S0 = 3'b000;
  localparam S1 = 3'b001;
  localparam S2 = 3'b010;
  localparam S3 = 3'b011;
  localparam S4 = 3'b100;

  reg [2:0] state, next_state;

  always @(posedge clk, posedge rst)
    if (rst) state <= S0;
    else state <= next_state;

  always @(*)
    case (state)
      S0:
      if (d) next_state <= S1;
      else next_state <= S0;
      S1:
      if (d) next_state <= S2;
      else next_state <= S0;
      S2:
      if (d) next_state <= S2;
      else next_state <= S3;
      S3:
      if (d) next_state <= S4;
      else next_state <= S0;
      S4:
      if (d) next_state <= S2;
      else next_state <= S0;
      default: next_state <= S0;
    endcase

  assign q = (state == S4);
endmodule
