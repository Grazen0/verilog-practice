`timescale 1ns / 1ps

module speaker_driver_tb ();
  reg clk, rst_n;
  reg [7:0] half_period;
  wire speaker;

  speaker_driver s (
      .clk(clk),
      .rst_n(rst_n),
      .half_period(half_period),
      .speaker(speaker)
  );

  always #5 clk = ~clk;

  initial begin
    $dumpvars(0, speaker_driver_tb);
    clk   = 1;
    rst_n = 0;

        #1 rst_n = 1;

    half_period = 3;
    #100 half_period = 5;
    #125 half_period = 7;
    #150 half_period = 1;

    #100 $finish();
  end
endmodule

// module music_tb ();
//   reg clk, rst_n;
//   wire speaker;
//
//   always #5 clk = ~clk;
//
//   music m (
//       .clk(clk),
//       .rst_n(rst_n),
//       .speaker(speaker)
//   );
//
//   initial begin
//     $dumpvars(0, music_tb);
//
//     clk   = 0;
//     rst_n = 0;
//
//     #1 rst_n = 1;
//
//     #1_000_000 $finish();
//   end
// endmodule
