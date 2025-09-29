`timescale 1ns / 1ps

module music_tb ();
    reg clk, rst_n;
    wire speaker;

    always #5 clk = ~clk;

    music m (
        .clk(clk),
        .rst_n(rst_n),
        .speaker(speaker)
    );

    initial begin
        $dumpvars(0, music_tb);

        clk   = 0;
        rst_n = 0;

        #1 rst_n = 1;

        #1_000_000 $finish();
    end
endmodule
