module clk_divider_tb ();
  reg clk_in, rst_n;
  wire clk_out_1, clk_out_2, clk_out_3;

  clk_divider d1 (
      .clk_in (clk_in),
      .rst_n  (rst_n),
      .clk_out(clk_out_1)
  );
  clk_divider #(
      .PERIOD(6)
  ) d2 (
      .clk_in (clk_in),
      .rst_n  (rst_n),
      .clk_out(clk_out_2)
  );
  clk_divider #(
      .PERIOD(10)
  ) d3 (
      .clk_in (clk_in),
      .rst_n  (rst_n),
      .clk_out(clk_out_3)
  );

  always #2 clk_in = ~clk_in;

  initial begin
    $dumpvars();

    clk_in = 0;
    rst_n  = 0;
    #1 rst_n = 1;

    #60 $finish();
  end
endmodule
