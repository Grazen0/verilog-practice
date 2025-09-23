module thunderbird (
    input  clk,
    input  rst,
    input  left,
    input  right,
    output l0,
    output l1,
    output l2,
    output r0,
    output r1,
    output r2
);
  reg [2:0] state, next_state;

  parameter S000_000 = 3'b000;
  parameter S000_100 = 3'b001;
  parameter S000_110 = 3'b010;
  parameter S000_111 = 3'b011;
  parameter S001_000 = 3'b100;
  parameter S011_000 = 3'b101;
  parameter S111_000 = 3'b110;

  always @(posedge clk, posedge rst)
    if (rst) state <= S000_000;
    else state <= next_state;

  always @(*)
    case (state)
      S000_000:
      if (left) next_state <= S001_000;
      else if (right) next_state <= S000_100;
      else next_state <= state;
      S001_000: next_state <= S011_000;
      S011_000: next_state <= S111_000;
      S111_000: next_state <= S000_000;
      S000_100: next_state <= S000_110;
      S000_110: next_state <= S000_111;
      S000_111: next_state <= S000_000;
      default: next_state <= S000_000;
    endcase

  assign l0 = (state == S001_000 | state == S011_000 | state == S111_000);
  assign l1 = (state == S011_000 | state == S111_000);
  assign l2 = (state == S111_000);
  assign r0 = (state == S000_100 | state == S000_110 | state == S000_111);
  assign r1 = (state == S000_110 | state == S000_111);
  assign r2 = (state == S000_111);

endmodule
