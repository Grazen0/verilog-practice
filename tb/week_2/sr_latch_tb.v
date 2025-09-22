`timescale 1ns / 1ps

module sr_latch_tb ();
  reg set, reset;

  wire q;
  wire nq;

  sr_latch sr1 (
      .set(set),
      .reset(reset),
      .q(q),
      .nq(nq)
  );

  initial begin
    $dumpvars();

    set   = 0;
    reset = 0;

    #1 reset = 1;
    #1 reset = 0;

    #3 set = 1;
    #1 set = 0;

    #3 set = 1;
    reset = 1;

    #10 $finish();
  end

endmodule
