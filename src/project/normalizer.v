module normalizer #(
    parameter MANT_WIDTH = 22,
    parameter EXP_WIDTH  = 8
) (
    input wire clk,
    input wire rst_n,
    input wire start,
    input wire [MANT_WIDTH-1:0] mant_in,
    input wire [EXP_WIDTH-1:0] exp_in,
    output reg [MANT_WIDTH-1:0] mant_out,
    output reg [EXP_WIDTH-1:0] exp_out,
    output wire done
);
  always @(posedge clk, negedge rst_n) begin
    if (!rst_n) begin
      mant_out <= 0;
      exp_out  <= 0;
    end else if (start) begin
      mant_out <= mant_in;
      exp_out  <= exp_in;
    end else if (!done) begin
      mant_out <= mant_out << 1;
      exp_out  <= exp_out - 1;
    end
  end

  assign done = (mant_out[MANT_WIDTH-1] == 1'b1);
endmodule
