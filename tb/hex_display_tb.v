module hex_display_tb ();
  reg clk, rst_n;
  reg  [15:0] data;
  wire [ 7:0] seg;
  wire [ 3:0] anode;

  always #5 clk = ~clk;

  hex_display d (
      .clk  (clk),
      .rst_n(rst_n),
      .data (data),
      .anode(anode),
      .seg  (seg)
  );

  initial begin
    $dumpvars();

    clk   = 1;
    rst_n = 1;
    data  = 16'hBF47;

    #1 rst_n = 0;
    #1 rst_n = 1;

    #100 $finish();
  end
endmodule
