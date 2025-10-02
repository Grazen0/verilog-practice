module control_unit #(
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
    output wire [15:0] speaker_divider
);
  localparam BEAT_PERIOD = (60 * CLK_FREQ) / (TEMPO * BEAT_SCALE);

  reg init;
  reg inc_nc;
  reg [$clog2(ROM_SIZE)-1:0] note_counter;
  reg [ROM_WIDTH-1:0] note_buf;

  wire [NOTE_DURATION_WIDTH-1:0] note_duration = rom_data[8+:NOTE_DURATION_WIDTH];
  wire [7:0] note_index = note_buf[7:0];

  wire beat_done, note_done;

  auto_reload_timer beat_timer (
      .clk(clk),
      .rst_n(rst_n),
      .load_value(BEAT_PERIOD),
      .enable(init),
      .done(beat_done)
  );

  auto_reload_timer #(
      .WIDTH(NOTE_DURATION_WIDTH)
  ) note_timer (
      .clk(clk),
      .rst_n(rst_n),
      .load_value(note_duration),
      .enable(init & beat_done),
      .done(note_done)
  );

  note_data #(
      .CLK_FREQ(CLK_FREQ)
  ) nd (
      .note_index(note_index),
      .divider(speaker_divider)
  );

  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      init <= 0;
      inc_nc <= 0;
      note_counter <= 0;
      note_buf <= 0;
    end else if (!init) begin
      // Waits for ROM data to arrive
      init <= 1;
    end else if (note_done) begin
      note_buf <= rom_data;
      inc_nc   <= 1;
    end else if (inc_nc) begin
      if (note_counter == ROM_SIZE - 1) begin
        note_counter <= 0;
      end else begin
        note_counter <= note_counter + 1;
      end
      inc_nc <= 0;
    end
  end

  assign rom_addr = note_counter;
endmodule
