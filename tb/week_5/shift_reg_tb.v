module shift_reg_tb ();
    reg clk, load, pause;
    reg [3:0] data_in;
    wire serial_out;

    shift_reg uut (
        .clk(clk),
        .load(load),
        .pause(pause),
        .data_in(data_in),
        .serial_out(serial_out)
    );

    always #10 clk = ~clk;

    initial begin
        $dumpvars();

        clk = 0;
        load = 1;
        data_in = 4'b1101;
        pause = 0;

        #5 load = 0;
        #10 load = 1;

        #150 $finish();
    end
endmodule
