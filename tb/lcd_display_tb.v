`timescale 1ns / 1ps

module lcd_display_tb ();
  reg clk, rst_n;
  wire [7:0] data;
  wire enable, rw, rs;

  always #5 clk = ~clk;

  lcd_display display (
      .clk(clk),
      .rst_n(rst_n),
      .enable(enable),
      .data(data),
      .rw(rw),
      .rs(rs)
  );

  initial begin
    $dumpvars(0, lcd_display_tb);

    clk   = 1;
    rst_n = 0;

    #5;

    rst_n = 1;

    #500 $finish();
  end

endmodule
