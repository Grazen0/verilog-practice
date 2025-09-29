`timescale 1ns / 1ps

module mux41_tb ();
    reg a, b, c, d;
    reg [1:0] sel;
    wire f;

    mux41 m1 (
        .a  (a),
        .b  (b),
        .c  (c),
        .d  (d),
        .sel(sel),
        .f  (f)
    );

    always #1 a = ~a;
    always #2 b = ~b;
    always #2 c = ~c;
    always #1 d = ~d;

    initial begin
        $dumpvars();

        a   = 0;
        b   = 0;
        c   = 1;
        d   = 1;
        sel = 'b1;

        #2 sel = 'b0;
        #2 sel = 'b11;

        #4 $finish();
    end
endmodule
