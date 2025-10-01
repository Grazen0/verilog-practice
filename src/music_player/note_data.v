`define TO_DIVIDER(clk, freq) (clk) / (2 * (freq))

`define C0 0
`define CS0 1
`define D0 2
`define EB0 3
`define E0 4
`define F0 5
`define FS0 6
`define G0 7
`define AB0 8
`define A0 9
`define BB0 10
`define B0 11
`define C1 12
`define CS1 13
`define D1 14
`define EB1 15
`define E1 16
`define F1 17
`define FS1 18
`define G1 19
`define AB1 20
`define A1 21
`define BB1 22
`define B1 23
`define C2 24
`define CS2 25
`define D2 26
`define EB2 27
`define E2 28
`define F2 29
`define FS2 30
`define G2 31
`define AB2 32
`define A2 33
`define BB2 34
`define B2 35
`define C3 36
`define CS3 37
`define D3 38
`define EB3 39
`define E3 40
`define F3 41
`define FS3 42
`define G3 43
`define AB3 44
`define A3 45
`define BB3 46
`define B3 47
`define C4 48
`define CS4 49
`define D4 50
`define EB4 51
`define E4 52
`define F4 53
`define FS4 54
`define G4 55
`define AB4 56
`define A4 57
`define BB4 58
`define B4 59
`define C5 60
`define CS5 61
`define D5 62
`define EB5 63
`define E5 64
`define F5 65
`define FS5 66
`define G5 67
`define AB5 68
`define A5 69
`define BB5 70
`define B5 71
`define C6 72
`define CS6 73
`define D6 74
`define EB6 75
`define E6 76
`define F6 77
`define FS6 78
`define G6 79
`define AB6 80
`define A6 81
`define BB6 82
`define B6 83
`define C7 84
`define CS7 85
`define D7 86
`define EB7 87
`define E7 88
`define F7 89
`define FS7 90
`define G7 91
`define AB7 92
`define A7 93
`define BB7 94
`define B7 95
`define C8 96
`define CS8 97
`define D8 98
`define EB8 99
`define E8 100
`define F8 101
`define FS8 102
`define G8 103
`define AB8 104
`define A8 105
`define BB8 106
`define B8 107

module note_data #(
    parameter CLK_FREQ = 100,
    parameter DIVIDER_WIDTH = 16,
    parameter DATA_SIZE = 108
) (
    input wire [$clog2(DATA_SIZE)-1:0] note,
    output wire [DIVIDER_WIDTH-1:0] divider
);
    reg [DIVIDER_WIDTH-1:0] data[DATA_SIZE];

    initial begin
        data[0]   = `TO_DIVIDER(CLK_FREQ, 16'd16);
        data[1]   = `TO_DIVIDER(CLK_FREQ, 16'd17);
        data[2]   = `TO_DIVIDER(CLK_FREQ, 16'd18);
        data[3]   = `TO_DIVIDER(CLK_FREQ, 16'd19);
        data[4]   = `TO_DIVIDER(CLK_FREQ, 16'd20);
        data[5]   = `TO_DIVIDER(CLK_FREQ, 16'd21);
        data[6]   = `TO_DIVIDER(CLK_FREQ, 16'd23);
        data[7]   = `TO_DIVIDER(CLK_FREQ, 16'd24);
        data[8]   = `TO_DIVIDER(CLK_FREQ, 16'd25);
        data[9]   = `TO_DIVIDER(CLK_FREQ, 16'd27);
        data[10]  = `TO_DIVIDER(CLK_FREQ, 16'd29);
        data[11]  = `TO_DIVIDER(CLK_FREQ, 16'd30);
        data[12]  = `TO_DIVIDER(CLK_FREQ, 16'd32);
        data[13]  = `TO_DIVIDER(CLK_FREQ, 16'd34);
        data[14]  = `TO_DIVIDER(CLK_FREQ, 16'd36);
        data[15]  = `TO_DIVIDER(CLK_FREQ, 16'd38);
        data[16]  = `TO_DIVIDER(CLK_FREQ, 16'd41);
        data[17]  = `TO_DIVIDER(CLK_FREQ, 16'd43);
        data[18]  = `TO_DIVIDER(CLK_FREQ, 16'd46);
        data[19]  = `TO_DIVIDER(CLK_FREQ, 16'd49);
        data[20]  = `TO_DIVIDER(CLK_FREQ, 16'd51);
        data[21]  = `TO_DIVIDER(CLK_FREQ, 16'd55);
        data[22]  = `TO_DIVIDER(CLK_FREQ, 16'd58);
        data[23]  = `TO_DIVIDER(CLK_FREQ, 16'd61);
        data[24]  = `TO_DIVIDER(CLK_FREQ, 16'd65);
        data[25]  = `TO_DIVIDER(CLK_FREQ, 16'd69);
        data[26]  = `TO_DIVIDER(CLK_FREQ, 16'd73);
        data[27]  = `TO_DIVIDER(CLK_FREQ, 16'd77);
        data[28]  = `TO_DIVIDER(CLK_FREQ, 16'd82);
        data[29]  = `TO_DIVIDER(CLK_FREQ, 16'd87);
        data[30]  = `TO_DIVIDER(CLK_FREQ, 16'd92);
        data[31]  = `TO_DIVIDER(CLK_FREQ, 16'd98);
        data[32]  = `TO_DIVIDER(CLK_FREQ, 16'd103);
        data[33]  = `TO_DIVIDER(CLK_FREQ, 16'd110);
        data[34]  = `TO_DIVIDER(CLK_FREQ, 16'd116);
        data[35]  = `TO_DIVIDER(CLK_FREQ, 16'd123);
        data[36]  = `TO_DIVIDER(CLK_FREQ, 16'd130);
        data[37]  = `TO_DIVIDER(CLK_FREQ, 16'd138);
        data[38]  = `TO_DIVIDER(CLK_FREQ, 16'd146);
        data[39]  = `TO_DIVIDER(CLK_FREQ, 16'd155);
        data[40]  = `TO_DIVIDER(CLK_FREQ, 16'd164);
        data[41]  = `TO_DIVIDER(CLK_FREQ, 16'd174);
        data[42]  = `TO_DIVIDER(CLK_FREQ, 16'd185);
        data[43]  = `TO_DIVIDER(CLK_FREQ, 16'd196);
        data[44]  = `TO_DIVIDER(CLK_FREQ, 16'd207);
        data[45]  = `TO_DIVIDER(CLK_FREQ, 16'd220);
        data[46]  = `TO_DIVIDER(CLK_FREQ, 16'd233);
        data[47]  = `TO_DIVIDER(CLK_FREQ, 16'd246);
        data[48]  = `TO_DIVIDER(CLK_FREQ, 16'd261);
        data[49]  = `TO_DIVIDER(CLK_FREQ, 16'd277);
        data[50]  = `TO_DIVIDER(CLK_FREQ, 16'd293);
        data[51]  = `TO_DIVIDER(CLK_FREQ, 16'd311);
        data[52]  = `TO_DIVIDER(CLK_FREQ, 16'd329);
        data[53]  = `TO_DIVIDER(CLK_FREQ, 16'd349);
        data[54]  = `TO_DIVIDER(CLK_FREQ, 16'd369);
        data[55]  = `TO_DIVIDER(CLK_FREQ, 16'd392);
        data[56]  = `TO_DIVIDER(CLK_FREQ, 16'd415);
        data[57]  = `TO_DIVIDER(CLK_FREQ, 16'd440);
        data[58]  = `TO_DIVIDER(CLK_FREQ, 16'd466);
        data[59]  = `TO_DIVIDER(CLK_FREQ, 16'd493);
        data[60]  = `TO_DIVIDER(CLK_FREQ, 16'd523);
        data[61]  = `TO_DIVIDER(CLK_FREQ, 16'd554);
        data[62]  = `TO_DIVIDER(CLK_FREQ, 16'd587);
        data[63]  = `TO_DIVIDER(CLK_FREQ, 16'd622);
        data[64]  = `TO_DIVIDER(CLK_FREQ, 16'd659);
        data[65]  = `TO_DIVIDER(CLK_FREQ, 16'd698);
        data[66]  = `TO_DIVIDER(CLK_FREQ, 16'd739);
        data[67]  = `TO_DIVIDER(CLK_FREQ, 16'd783);
        data[68]  = `TO_DIVIDER(CLK_FREQ, 16'd830);
        data[69]  = `TO_DIVIDER(CLK_FREQ, 16'd880);
        data[70]  = `TO_DIVIDER(CLK_FREQ, 16'd932);
        data[71]  = `TO_DIVIDER(CLK_FREQ, 16'd987);
        data[72]  = `TO_DIVIDER(CLK_FREQ, 16'd1046);
        data[73]  = `TO_DIVIDER(CLK_FREQ, 16'd1108);
        data[74]  = `TO_DIVIDER(CLK_FREQ, 16'd1174);
        data[75]  = `TO_DIVIDER(CLK_FREQ, 16'd1244);
        data[76]  = `TO_DIVIDER(CLK_FREQ, 16'd1318);
        data[77]  = `TO_DIVIDER(CLK_FREQ, 16'd1396);
        data[78]  = `TO_DIVIDER(CLK_FREQ, 16'd1479);
        data[79]  = `TO_DIVIDER(CLK_FREQ, 16'd1567);
        data[80]  = `TO_DIVIDER(CLK_FREQ, 16'd1661);
        data[81]  = `TO_DIVIDER(CLK_FREQ, 16'd1760);
        data[82]  = `TO_DIVIDER(CLK_FREQ, 16'd1864);
        data[83]  = `TO_DIVIDER(CLK_FREQ, 16'd1975);
        data[84]  = `TO_DIVIDER(CLK_FREQ, 16'd2093);
        data[85]  = `TO_DIVIDER(CLK_FREQ, 16'd2217);
        data[86]  = `TO_DIVIDER(CLK_FREQ, 16'd2349);
        data[87]  = `TO_DIVIDER(CLK_FREQ, 16'd2489);
        data[88]  = `TO_DIVIDER(CLK_FREQ, 16'd2637);
        data[89]  = `TO_DIVIDER(CLK_FREQ, 16'd2793);
        data[90]  = `TO_DIVIDER(CLK_FREQ, 16'd2959);
        data[91]  = `TO_DIVIDER(CLK_FREQ, 16'd3135);
        data[92]  = `TO_DIVIDER(CLK_FREQ, 16'd3322);
        data[93]  = `TO_DIVIDER(CLK_FREQ, 16'd3520);
        data[94]  = `TO_DIVIDER(CLK_FREQ, 16'd3729);
        data[95]  = `TO_DIVIDER(CLK_FREQ, 16'd3951);
        data[96]  = `TO_DIVIDER(CLK_FREQ, 16'd4186);
        data[97]  = `TO_DIVIDER(CLK_FREQ, 16'd4434);
        data[98]  = `TO_DIVIDER(CLK_FREQ, 16'd4698);
        data[99]  = `TO_DIVIDER(CLK_FREQ, 16'd4978);
        data[100] = `TO_DIVIDER(CLK_FREQ, 16'd5274);
        data[101] = `TO_DIVIDER(CLK_FREQ, 16'd5587);
        data[102] = `TO_DIVIDER(CLK_FREQ, 16'd5919);
        data[103] = `TO_DIVIDER(CLK_FREQ, 16'd6271);
        data[104] = `TO_DIVIDER(CLK_FREQ, 16'd6644);
        data[105] = `TO_DIVIDER(CLK_FREQ, 16'd7040);
        data[106] = `TO_DIVIDER(CLK_FREQ, 16'd7458);
        data[107] = `TO_DIVIDER(CLK_FREQ, 16'd7902);
    end

    assign divider = data[note];
endmodule

