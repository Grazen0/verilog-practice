`timescale 1ns / 1ps

`include "music_player/notes.vh"

module control_unit_tb ();
    localparam CLK_FREQ = 100000;
    localparam ROM_WIDTH = 16;
    localparam ROM_SIZE = 4;

    reg clk, rst_n;
    reg [ROM_WIDTH-1:0] rom[ROM_SIZE];
    wire [ROM_WIDTH-1:0] rom_data;
    wire [$clog2(ROM_SIZE)-1:0] rom_addr;
    wire [15:0] speaker_divider;

    always #1 clk = ~clk;

    assign rom_data = rom[rom_addr];

    control_unit #(
        .CLK_FREQ (CLK_FREQ),
        .ROM_SIZE (ROM_SIZE),
        .ROM_WIDTH(ROM_WIDTH)
    ) ctrl (
        .clk(clk),
        .rst_n(rst_n),
        .rom_addr(rom_addr),
        .rom_data(rom_data),
        .speaker_divider(speaker_divider)
    );

    localparam SIMULATION_SECONDS = 5;

    initial begin
        $dumpvars(0, control_unit_tb);

        rom[0] = `NOTE(`C3, 8);
        rom[1] = `NOTE(`D3, 16);
        rom[2] = `NOTE(`SILENCE, 4);
        rom[3] = `NOTE(`F3, 4);

        clk = 1;
        rst_n = 0;
        #1 rst_n = 1;

        #(2 * CLK_FREQ * SIMULATION_SECONDS) $finish();
    end
endmodule
