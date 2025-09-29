`timescale 1ns / 1ps

module barrel_shifter_tb ();
    localparam WIDTH = 8;

    reg [WIDTH-1:0] in;
    reg [$clog2(WIDTH)-1:0] shift;
    wire [WIDTH-1:0] out;

    barrel_shifter shifter (
        .in(in),
        .shift(shift),
        .out(out)
    );

    initial begin
        $dumpvars(0, barrel_shifter_tb);

        in = 8'b0101_0110;
        shift = 0;

        repeat (10) begin
            #1 shift = shift + 1;
        end

        $finish();
    end
endmodule
