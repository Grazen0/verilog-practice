`timescale 1ns / 1ps

module d_latch_tb ();
  reg d, we;
  wire q, nq;

  d_latch dl (
      .d (d),
      .we(we),
      .q (q),
      .nq(nq)
  );

  initial begin
    $dumpvars(0, d_latch_tb);

    d  = 0;
    we = 0;

    #1 d = 1;
    #1 d = 0;
    #1 d = 1;
    #1 d = 0;

    #2 we = 1;

    #1 d = 1;
    #3 d = 0;

    #2 we = 0;

    #1 d = 0;
    #1 d = 1;

    #2 we = 1;

    #10 $finish();
  end
endmodule






