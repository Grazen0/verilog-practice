`timescale 1ns / 1ps

module serial_detector_tb ();
    reg clk, rst_n;
    reg [3:0] x;
    wire z;

    always #5 clk = ~clk;

    serial_detector detector (
        .clk(clk),
        .rst_n(rst_n),
        .x(x),
        .z(z)
    );

    initial begin
        $dumpvars(0, serial_detector_tb);
        clk   = 1;
        rst_n = 0;

        #5 rst_n = 1;

        x = 4'b0101;
        #10 x = 4'b1100;
        #10 x = 4'b0001;
        #10 x = 4'b0100;
        #10 x = 4'b1111;
        #10 x = 4'b1111;
        #10 x = 4'b1110;

        #40 $finish();
    end
endmodule
