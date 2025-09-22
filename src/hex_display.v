module hex_to_7_segment (
    input  wire [3:0] digit,
    output reg  [7:0] seg
);
  always @(*)
    case (digit)
      4'h0: seg <= 8'b0000_0011;
      4'h1: seg <= 8'b1001_1111;
      4'h2: seg <= 8'b0010_0101;
      4'h3: seg <= 8'b0000_1101;
      4'h4: seg <= 8'b1001_1001;
      4'h5: seg <= 8'b0100_1001;
      4'h6: seg <= 8'b0100_0001;
      4'h7: seg <= 8'b0001_1111;
      4'h8: seg <= 8'b0000_0001;
      4'h9: seg <= 8'b0000_1001;
      4'hA: seg <= 8'b0001_0001;
      4'hB: seg <= 8'b1100_0001;
      4'hC: seg <= 8'b0110_0011;
      4'hD: seg <= 8'b1000_0101;
      4'hE: seg <= 8'b0110_0001;
      4'hF: seg <= 8'b0111_0001;
    endcase
endmodule

module h_fsm (
    input wire clk,
    input wire rst_n,
    input wire [15:0] data,
    output reg [3:0] digit,
    output reg [3:0] anode
);
  reg [1:0] state;

  always @(posedge clk, negedge rst_n)
    if (!rst_n) state <= 2'b00;
    else state <= state + 1;

  always @(state)
    case (state)
      2'b00: begin
        digit <= data[3:0];
        anode <= 4'b1110;
      end
      2'b01: begin
        digit <= data[7:4];
        anode <= 4'b1101;
      end
      2'b10: begin
        digit <= data[11:8];
        anode <= 4'b1011;
      end
      2'b11: begin
        digit <= data[15:12];
        anode <= 4'b0111;
      end
    endcase
endmodule

module hex_display (
    input wire clk,
    input wire rst_n,
    input wire [15:0] data,
    output wire [3:0] anode,
    output wire [7:0] seg
);
  wire [3:0] digit;

  h_fsm h (
      .clk  (clk),
      .rst_n(rst_n),
      .data (data),
      .digit(digit),
      .anode(anode)
  );

  hex_to_7_segment h27 (
      .digit(digit),
      .seg  (seg)
  );
endmodule
