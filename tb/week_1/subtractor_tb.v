module subtractor_tb ();
    reg a, b, b_in;
    wire d, b_out;

    subtractor s1 (
        .a(a),
        .b(b),
        .b_in(b_in),
        .d(d),
        .b_out(b_out)
    );

    always #1 a = ~a;
    always #2 b = ~b;
    always #4 b_in = ~b_in;

    initial begin
        $dumpvars();

        a = 0;
        b = 0;
        b_in = 0;

        #8 $finish();
    end
endmodule
