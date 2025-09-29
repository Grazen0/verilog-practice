`timescale 1ns / 1ps

module tff_tb ();
    reg clk, t, rst;
    wire q;

    tff t1 (
        .clk(clk),
        .rst(rst),
        .t  (t),
        .q  (q)
    );

    always #5 clk = ~clk;

    initial begin
        $dumpvars();

        clk = 0;
        rst = 0;
        t   = 0;

        #2 rst = 1;
        #5 t = 1;

        #40 $finish();
    end

endmodule
