`define HALF_PERIOD(clk, freq) ((clk) / (2 * (freq)))

module music (
    input  wire clk,
    input  wire rst_n,
    output reg  speaker
);
  localparam CLK_FREQ = 100_000_000;
  localparam TEMPO = 120;
  localparam BEAT_PERIOD = (60 * CLK_FREQ) / (TEMPO * 4);

  localparam DO = `HALF_PERIOD(CLK_FREQ, 261);
  localparam DO_SH = `HALF_PERIOD(CLK_FREQ, 277);
  localparam RE = `HALF_PERIOD(CLK_FREQ, 293);
  localparam RE_SH = `HALF_PERIOD(CLK_FREQ, 311);
  localparam MI = `HALF_PERIOD(CLK_FREQ, 329);
  localparam FA = `HALF_PERIOD(CLK_FREQ, 349);
  localparam FA_SH = `HALF_PERIOD(CLK_FREQ, 369);
  localparam SOL = `HALF_PERIOD(CLK_FREQ, 392);
  localparam SOL_SH = `HALF_PERIOD(CLK_FREQ, 415);
  localparam LA = `HALF_PERIOD(CLK_FREQ, 440);
  localparam LA_SH = `HALF_PERIOD(CLK_FREQ, 466);
  localparam SI = `HALF_PERIOD(CLK_FREQ, 493);
  localparam DO_H = `HALF_PERIOD(CLK_FREQ, 523);
  localparam DO_H_SH = `HALF_PERIOD(CLK_FREQ, 554);
  localparam RE_H = `HALF_PERIOD(CLK_FREQ, 587);

  reg [ 3:0] step;
  reg [31:0] beat_timer;
  reg [31:0] speaker_timer;
  reg [31:0] speaker_half_period, next_half_period;

  always @(*) begin
    case (step)
      default: next_half_period = RE;
      1: next_half_period = RE;
      2: next_half_period = RE_H;
      3: next_half_period = 0;
      4: next_half_period = LA;
      5: next_half_period = 0;
      6: next_half_period = 0;
      7: next_half_period = SOL_SH;
      8: next_half_period = 0;
      9: next_half_period = SOL;
      10: next_half_period = 0;
      11: next_half_period = FA;
      12: next_half_period = 0;
      13: next_half_period = RE;
      14: next_half_period = FA;
      15: next_half_period = SOL;
    endcase
  end

  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      step <= 0;
      beat_timer <= 0;
      speaker <= 0;
      speaker_timer <= 0;
      speaker_half_period <= RE;
    end else begin
      beat_timer <= beat_timer + 1;
      speaker_timer <= speaker_timer + 1;

      if (beat_timer == BEAT_PERIOD - 1) begin
        step <= step + 1;
        beat_timer <= 0;
        speaker_timer <= 0;

        if (next_half_period != 0) begin
          speaker_half_period <= next_half_period;
          speaker <= 0;
        end
      end else if (speaker_timer == speaker_half_period - 1) begin
        speaker <= ~speaker;
        speaker_timer <= 0;
      end
    end
  end
endmodule
