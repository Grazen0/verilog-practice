module music_player #(
    parameter CLK_FREQ = 100,
    parameter ROM_WIDTH = 16,
    parameter ROM_SIZE = 256,
    parameter TEMPO = 120,
    parameter BEAT_SCALE = 4,
    parameter NOTE_DURATION_WIDTH = 4
) (
    input wire clk,
    input wire rst_n,
    input wire [ROM_WIDTH-1:0] rom_data,
    output wire [$clog2(ROM_SIZE)-1:0] rom_addr,
    output wire speaker
);
  wire [15:0] speaker_divider;

  control_unit #(
      .CLK_FREQ(CLK_FREQ),
      .ROM_WIDTH(ROM_WIDTH),
      .ROM_SIZE(ROM_SIZE),
      .TEMPO(TEMPO),
      .BEAT_SCALE(BEAT_SCALE),
      .NOTE_DURATION_WIDTH(NOTE_DURATION_WIDTH)
  ) ctrl (
      .clk(clk),
      .rst_n(rst_n),
      .rom_data(rom_data),
      .rom_addr(rom_addr),
      .speaker_divider(speaker_divider)
  );

  square_wave_gen gen (
      .clk(clk),
      .rst_n(rst_n),
      .divider(speaker_divider),
      .speaker(speaker)
  );
endmodule
