`timescale 1ns / 1ps

`include "music_player/notes.vh"

module music_player_tb ();
    localparam CLK_FREQ = 100000;
    localparam ROM_WIDTH = 16;
    localparam ROM_SIZE = 128;

    reg clk, rst_n;
    reg [ROM_WIDTH-1:0] rom[ROM_SIZE];
    wire [ROM_WIDTH-1:0] rom_data;
    wire [$clog2(ROM_SIZE)-1:0] rom_addr;
    wire speaker;

    always #1 clk = ~clk;

    assign rom_data = rom[rom_addr];

    music_player #(
        .TEMPO(180),
        .CLK_FREQ(CLK_FREQ),
        .ROM_SIZE(ROM_SIZE),
        .ROM_WIDTH(ROM_WIDTH)
    ) player (
        .clk(clk),
        .rst_n(rst_n),
        .rom_addr(rom_addr),
        .rom_data(rom_data),
        .speaker(speaker)
    );

    localparam SIMULATION_SECONDS = 5;

    initial begin
        $dumpvars(0, music_player_tb);

        rom[0] = `NOTE(`B4, 2);
        rom[1] = `NOTE(`G5, 2);
        rom[2] = `NOTE(`FS5, 1);
        rom[3] = `NOTE(`G5, 1);
        rom[4] = `NOTE(`FS5, 1);
        rom[5] = `NOTE(`G5, 1);
        rom[6] = `NOTE(`A5, 2);
        rom[7] = `NOTE(`G5, 2);
        rom[8] = `NOTE(`FS5, 1);
        rom[9] = `NOTE(`G5, 1);
        rom[10] = `NOTE(`FS5, 1);
        rom[11] = `NOTE(`D5, 1);

        rom[12] = `NOTE(`E5, 2);
        rom[13] = `NOTE(`B5, 2);
        rom[14] = `NOTE(`A5, 1);
        rom[15] = `NOTE(`B5, 1);
        rom[16] = `NOTE(`A5, 1);
        rom[17] = `NOTE(`B5, 1);
        rom[18] = `NOTE(`D6, 2);
        rom[19] = `NOTE(`B5, 2);
        rom[20] = `NOTE(`A5, 2);
        rom[21] = `NOTE(`B5, 2);

        rom[22] = `NOTE(`B4, 2);
        rom[23] = `NOTE(`G5, 2);
        rom[24] = `NOTE(`F5, 1);
        rom[25] = `NOTE(`FS5, 1);
        rom[26] = `NOTE(`G5, 1);
        rom[27] = `NOTE(`AB5, 1);
        rom[28] = `NOTE(`A5, 2);
        rom[29] = `NOTE(`G5, 2);
        rom[30] = `NOTE(`FS5, 2);
        rom[31] = `NOTE(`D5, 2);

        rom[32] = `NOTE(`E5, 2);
        rom[33] = `NOTE(`B5, 2);
        rom[34] = `NOTE(`BB5, 1);
        rom[35] = `NOTE(`B5, 1);
        rom[36] = `NOTE(`BB5, 1);
        rom[37] = `NOTE(`B5, 1);
        rom[38] = `NOTE(`EB6, 2);
        rom[39] = `NOTE(`B5, 2);
        rom[40] = `NOTE(`A5, 2);
        rom[41] = `NOTE(`B5, 2);

        rom[42] = `NOTE(`B4, 2);
        rom[43] = `NOTE(`G5, 2);
        rom[44] = `NOTE(`FS5, 1);
        rom[45] = `NOTE(`G5, 1);
        rom[46] = `NOTE(`FS5, 1);
        rom[47] = `NOTE(`G5, 1);
        rom[48] = `NOTE(`A5, 2);
        rom[49] = `NOTE(`G5, 2);
        rom[50] = `NOTE(`FS5, 1);
        rom[51] = `NOTE(`G5, 1);
        rom[52] = `NOTE(`FS5, 1);
        rom[53] = `NOTE(`D5, 1);

        rom[54] = `NOTE(`E5, 2);
        rom[55] = `NOTE(`B5, 2);
        rom[56] = `NOTE(`A5, 1);
        rom[57] = `NOTE(`B5, 1);
        rom[58] = `NOTE(`A5, 1);
        rom[59] = `NOTE(`B5, 1);
        rom[60] = `NOTE(`D6, 2);
        rom[61] = `NOTE(`B5, 2);
        rom[62] = `NOTE(`A5, 2);
        rom[63] = `NOTE(`B5, 2);

        rom[64] = `NOTE(`A5, 3);
        rom[65] = `NOTE(`A5, 1);
        rom[66] = `NOTE(`A6, 2);
        rom[67] = `NOTE(`A5, 2);
        rom[68] = `NOTE(`B5, 3);
        rom[69] = `NOTE(`B5, 1);
        rom[70] = `NOTE(`B5, 2);
        rom[71] = `NOTE(`B5, 2);

        rom[72] = `NOTE(`C6, 3);
        rom[73] = `NOTE(`C6, 1);
        rom[74] = `NOTE(`C6, 2);
        rom[75] = `NOTE(`CS6, 1);
        rom[76] = `NOTE(`CS6, 2);
        rom[77] = `NOTE(`D6, 7);

        clk = 1;
        rst_n = 0;
        #1 rst_n = 1;

        #(2 * CLK_FREQ * SIMULATION_SECONDS) $finish();
    end
endmodule
