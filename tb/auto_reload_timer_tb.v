`timescale 1ns / 1ps

module auto_reload_timer_tb ();
    localparam WIDTH = 8;
    reg clk, rst_n;
    reg [WIDTH-1:0] load_value;
    wire done;

    always #5 clk = ~clk;

    auto_reload_timer #(
        .WIDTH(WIDTH)
    ) timer (
        .clk(clk),
        .rst_n(rst_n),
        .load_value(load_value),
        .done(done)
    );

    initial begin
        $dumpvars(0, auto_reload_timer_tb);

        clk = 0;
        rst_n = 0;
        load_value = 3;

        #1 rst_n = 1;
        #60 load_value = 5;
        #100 $finish();
    end
endmodule
