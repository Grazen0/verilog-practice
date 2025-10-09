module normalizer_tb ();
  localparam MANT_WIDTH = 22;
  localparam EXP_WIDTH = 8;

  reg clk, rst_n, start;
  reg [MANT_WIDTH-1:0] mant_in;
  reg [EXP_WIDTH-1:0] exp_in;

  wire [MANT_WIDTH-1:0] mant_out;
  wire [EXP_WIDTH-1:0] exp_out;
  wire done;

  always #5 clk = ~clk;

  normalizer n (
      .clk(clk),
      .rst_n(rst_n),
      .start(start),
      .mant_in(mant_in),
      .exp_in(exp_in),
      .mant_out(mant_out),
      .exp_out(exp_out),
      .done(done)
  );

  initial begin
    $dumpvars(0, normalizer_tb);

    clk   = 1;
    rst_n = 0;

    #5;

    rst_n   = 1;
    mant_in = 22'b00_0000_0111_1010_0111_1111;
    exp_in  = 8'd42;
    start   = 1;

    #10;

    start = 0;

    #200 $finish();
  end
endmodule
