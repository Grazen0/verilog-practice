`timescale 1ns / 1ps

module square_wave_gen_tb ();
    localparam WIDTH = 8;

    reg clk, rst_n;
    reg [WIDTH-1:0] divider;
    wire speaker;

    square_wave_gen #(
        .TIMER_WIDTH(WIDTH)
    ) s (
        .clk(clk),
        .rst_n(rst_n),
        .divider(divider),
        .speaker(speaker)
    );

    always #5 clk = ~clk;

    initial begin
        $dumpvars(0, square_wave_gen_tb);
        clk   = 1;
        rst_n = 0;

        #1 rst_n = 1;

        divider = 3;
        #100 divider = 5;
        #125 divider = 7;
        #150 divider = 1;
        #150 divider = 0;
        #150 divider = 3;

        #100 $finish();
    end
endmodule
