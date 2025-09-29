`timescale 1ns / 1ps

module dff_tb ();
    reg clk, rst_n, d;
    wire q;

    dff dff (
        .clk(clk),
        .rst_n(rst_n),
        .d(d),
        .q(q)
    );

    always #5 clk = ~clk;

    initial begin
        $dumpvars();

        clk = 1;
        d = 0;
        rst_n = 1;

        #7 d = 1;
        #10 rst_n = 0;

        #10 $finish();
    end
endmodule
