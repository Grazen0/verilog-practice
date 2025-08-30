`timescale 1ns / 1ps

module mux21_tb ();
  reg a, b, sel;
  wire f;
  mux21 m1 (
      .f  (f),
      .a  (a),
      .b  (b),
      .sel(sel)
  );

  always #1 a = !a;
  always #2 b = !b;
  always #3 sel = !sel;

  initial begin
    $dumpvars(0, mux21_tb);

    a   = 0;
    b   = 0;
    sel = 0;

    #6 $finish();
  end
endmodule
