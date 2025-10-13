module lcd_display (
    input wire clk,
    input wire rst_n,
    output reg [7:0] data,
    output reg enable,
    output reg rw,
    output reg rs
);
  localparam WRITE = 1'b0;
  localparam READ = 1'b1;

  localparam INSTRUCTION = 1'b0;
  localparam DATA = 1'b1;

  reg [7:0] timer, timer_next;

  reg [7:0] data_next;
  reg enable_next, rw_next, rs_next;

  always @(*) begin
    timer_next = timer + 1;
    data_next = data;
    enable_next = enable;
    rw_next = rw;
    rs_next = rs;

    case (timer)
      0: begin
        data_next <= 8'b0000_0001;
        rw_next   <= WRITE;
        rs_next   <= INSTRUCTION;
      end
      1: enable_next <= 1'b1;
      2: enable_next <= 1'b0;
      3: data_next <= 8'b0000_0010;
      4: enable_next <= 1'b1;
      5: enable_next <= 1'b0;
      6: data_next <= 8'b0000_1111;
      7: enable_next <= 1'b1;
      8: enable_next <= 1'b0;
      9: begin
        rs_next   <= DATA;
        data_next <= "H";
      end
      10: enable_next <= 1'b1;
      11: enable_next <= 1'b0;
      12: data_next <= "e";
      13: enable_next <= 1'b1;
      14: enable_next <= 1'b0;
      15: data_next <= "l";
      16: enable_next <= 1'b1;
      17: enable_next <= 1'b0;
      18: enable_next <= 1'b1;
      19: enable_next <= 1'b0;
      20: data_next <= "o";
      21: enable_next <= 1'b1;
      22: enable_next <= 1'b0;
      23: data_next <= ",";
      24: enable_next <= 1'b1;
      25: enable_next <= 1'b0;
      26: data_next <= " ";
      27: enable_next <= 1'b1;
      28: enable_next <= 1'b0;
      29: data_next <= "w";
      30: enable_next <= 1'b1;
      31: enable_next <= 1'b0;
      32: data_next <= "o";
      33: enable_next <= 1'b1;
      34: enable_next <= 1'b0;
      35: data_next <= "r";
      36: enable_next <= 1'b1;
      37: enable_next <= 1'b0;
      38: data_next <= "l";
      39: enable_next <= 1'b1;
      40: enable_next <= 1'b0;
      41: data_next <= "d";
      42: enable_next <= 1'b1;
      43: enable_next <= 1'b0;
      44: data_next <= "!";
      45: enable_next <= 1'b1;
      46: enable_next <= 1'b0;
      default: timer_next = timer;
    endcase
  end

  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      data <= 8'b0;
      rw <= 1'b0;
      rs <= 1'b0;
      enable <= 1'b0;
      timer <= 0;
    end else begin
      data <= data_next;
      enable <= enable_next;
      rw <= rw_next;
      rs <= rs_next;
      timer <= timer_next;
    end
  end
endmodule
