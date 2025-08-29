`timescale 1ns / 1ns

module mux_tb ();
  reg a, b, sel;
  wire f;
  mux m1 (
      .f  (f),
      .a  (a),
      .b  (b),
      .sel(sel)
  );

  initial begin
    $dumpfile(`DUMP_FILE);
    $dumpvars(0, mux_tb);

    #10 a = 0;
    b   = 1;
    sel = 0;

    #20 sel = 1;
    #100 $finish();
  end
endmodule
