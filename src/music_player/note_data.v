`include "music_player/notes.vh"

module note_data #(
    parameter CLK_FREQ = 100,
    parameter DIVIDER_WIDTH = 16,
    parameter DATA_SIZE = 108
) (
    input wire [$clog2(DATA_SIZE)-1:0] note_index,
    output wire [DIVIDER_WIDTH-1:0] divider
);
    reg [DIVIDER_WIDTH-1:0] data[DATA_SIZE];

    initial begin
        data[0]   = 0;  // Silence
        data[1]   = `TO_DIVIDER(CLK_FREQ, 16);
        data[2]   = `TO_DIVIDER(CLK_FREQ, 17);
        data[3]   = `TO_DIVIDER(CLK_FREQ, 18);
        data[4]   = `TO_DIVIDER(CLK_FREQ, 19);
        data[5]   = `TO_DIVIDER(CLK_FREQ, 20);
        data[6]   = `TO_DIVIDER(CLK_FREQ, 21);
        data[7]   = `TO_DIVIDER(CLK_FREQ, 23);
        data[8]   = `TO_DIVIDER(CLK_FREQ, 24);
        data[9]   = `TO_DIVIDER(CLK_FREQ, 25);
        data[10]  = `TO_DIVIDER(CLK_FREQ, 27);
        data[11]  = `TO_DIVIDER(CLK_FREQ, 29);
        data[12]  = `TO_DIVIDER(CLK_FREQ, 30);
        data[13]  = `TO_DIVIDER(CLK_FREQ, 32);
        data[14]  = `TO_DIVIDER(CLK_FREQ, 34);
        data[15]  = `TO_DIVIDER(CLK_FREQ, 36);
        data[16]  = `TO_DIVIDER(CLK_FREQ, 38);
        data[17]  = `TO_DIVIDER(CLK_FREQ, 41);
        data[18]  = `TO_DIVIDER(CLK_FREQ, 43);
        data[19]  = `TO_DIVIDER(CLK_FREQ, 46);
        data[20]  = `TO_DIVIDER(CLK_FREQ, 49);
        data[21]  = `TO_DIVIDER(CLK_FREQ, 51);
        data[22]  = `TO_DIVIDER(CLK_FREQ, 55);
        data[23]  = `TO_DIVIDER(CLK_FREQ, 58);
        data[24]  = `TO_DIVIDER(CLK_FREQ, 61);
        data[25]  = `TO_DIVIDER(CLK_FREQ, 65);
        data[26]  = `TO_DIVIDER(CLK_FREQ, 69);
        data[27]  = `TO_DIVIDER(CLK_FREQ, 73);
        data[28]  = `TO_DIVIDER(CLK_FREQ, 77);
        data[29]  = `TO_DIVIDER(CLK_FREQ, 82);
        data[30]  = `TO_DIVIDER(CLK_FREQ, 87);
        data[31]  = `TO_DIVIDER(CLK_FREQ, 92);
        data[32]  = `TO_DIVIDER(CLK_FREQ, 98);
        data[33]  = `TO_DIVIDER(CLK_FREQ, 103);
        data[34]  = `TO_DIVIDER(CLK_FREQ, 110);
        data[35]  = `TO_DIVIDER(CLK_FREQ, 116);
        data[36]  = `TO_DIVIDER(CLK_FREQ, 123);
        data[37]  = `TO_DIVIDER(CLK_FREQ, 130);
        data[38]  = `TO_DIVIDER(CLK_FREQ, 138);
        data[39]  = `TO_DIVIDER(CLK_FREQ, 146);
        data[40]  = `TO_DIVIDER(CLK_FREQ, 155);
        data[41]  = `TO_DIVIDER(CLK_FREQ, 164);
        data[42]  = `TO_DIVIDER(CLK_FREQ, 174);
        data[43]  = `TO_DIVIDER(CLK_FREQ, 185);
        data[44]  = `TO_DIVIDER(CLK_FREQ, 196);
        data[45]  = `TO_DIVIDER(CLK_FREQ, 207);
        data[46]  = `TO_DIVIDER(CLK_FREQ, 220);
        data[47]  = `TO_DIVIDER(CLK_FREQ, 233);
        data[48]  = `TO_DIVIDER(CLK_FREQ, 246);
        data[49]  = `TO_DIVIDER(CLK_FREQ, 261);
        data[50]  = `TO_DIVIDER(CLK_FREQ, 277);
        data[51]  = `TO_DIVIDER(CLK_FREQ, 293);
        data[52]  = `TO_DIVIDER(CLK_FREQ, 311);
        data[53]  = `TO_DIVIDER(CLK_FREQ, 329);
        data[54]  = `TO_DIVIDER(CLK_FREQ, 349);
        data[55]  = `TO_DIVIDER(CLK_FREQ, 369);
        data[56]  = `TO_DIVIDER(CLK_FREQ, 392);
        data[57]  = `TO_DIVIDER(CLK_FREQ, 415);
        data[58]  = `TO_DIVIDER(CLK_FREQ, 440);
        data[59]  = `TO_DIVIDER(CLK_FREQ, 466);
        data[60]  = `TO_DIVIDER(CLK_FREQ, 493);
        data[61]  = `TO_DIVIDER(CLK_FREQ, 523);
        data[62]  = `TO_DIVIDER(CLK_FREQ, 554);
        data[63]  = `TO_DIVIDER(CLK_FREQ, 587);
        data[64]  = `TO_DIVIDER(CLK_FREQ, 622);
        data[65]  = `TO_DIVIDER(CLK_FREQ, 659);
        data[66]  = `TO_DIVIDER(CLK_FREQ, 698);
        data[67]  = `TO_DIVIDER(CLK_FREQ, 739);
        data[68]  = `TO_DIVIDER(CLK_FREQ, 783);
        data[69]  = `TO_DIVIDER(CLK_FREQ, 830);
        data[70]  = `TO_DIVIDER(CLK_FREQ, 880);
        data[71]  = `TO_DIVIDER(CLK_FREQ, 932);
        data[72]  = `TO_DIVIDER(CLK_FREQ, 987);
        data[73]  = `TO_DIVIDER(CLK_FREQ, 1046);
        data[74]  = `TO_DIVIDER(CLK_FREQ, 1108);
        data[75]  = `TO_DIVIDER(CLK_FREQ, 1174);
        data[76]  = `TO_DIVIDER(CLK_FREQ, 1244);
        data[77]  = `TO_DIVIDER(CLK_FREQ, 1318);
        data[78]  = `TO_DIVIDER(CLK_FREQ, 1396);
        data[79]  = `TO_DIVIDER(CLK_FREQ, 1479);
        data[80]  = `TO_DIVIDER(CLK_FREQ, 1567);
        data[81]  = `TO_DIVIDER(CLK_FREQ, 1661);
        data[82]  = `TO_DIVIDER(CLK_FREQ, 1760);
        data[83]  = `TO_DIVIDER(CLK_FREQ, 1864);
        data[84]  = `TO_DIVIDER(CLK_FREQ, 1975);
        data[85]  = `TO_DIVIDER(CLK_FREQ, 2093);
        data[86]  = `TO_DIVIDER(CLK_FREQ, 2217);
        data[87]  = `TO_DIVIDER(CLK_FREQ, 2349);
        data[88]  = `TO_DIVIDER(CLK_FREQ, 2489);
        data[89]  = `TO_DIVIDER(CLK_FREQ, 2637);
        data[90]  = `TO_DIVIDER(CLK_FREQ, 2793);
        data[91]  = `TO_DIVIDER(CLK_FREQ, 2959);
        data[92]  = `TO_DIVIDER(CLK_FREQ, 3135);
        data[93]  = `TO_DIVIDER(CLK_FREQ, 3322);
        data[94]  = `TO_DIVIDER(CLK_FREQ, 3520);
        data[95]  = `TO_DIVIDER(CLK_FREQ, 3729);
        data[96]  = `TO_DIVIDER(CLK_FREQ, 3951);
        data[97]  = `TO_DIVIDER(CLK_FREQ, 4186);
        data[98]  = `TO_DIVIDER(CLK_FREQ, 4434);
        data[99]  = `TO_DIVIDER(CLK_FREQ, 4698);
        data[100] = `TO_DIVIDER(CLK_FREQ, 4978);
        data[101] = `TO_DIVIDER(CLK_FREQ, 5274);
        data[102] = `TO_DIVIDER(CLK_FREQ, 5587);
        data[103] = `TO_DIVIDER(CLK_FREQ, 5919);
        data[104] = `TO_DIVIDER(CLK_FREQ, 6271);
        data[105] = `TO_DIVIDER(CLK_FREQ, 6644);
        data[106] = `TO_DIVIDER(CLK_FREQ, 7040);
        data[107] = `TO_DIVIDER(CLK_FREQ, 7458);
        data[108] = `TO_DIVIDER(CLK_FREQ, 7902);
    end

    assign divider = data[note_index];
endmodule

