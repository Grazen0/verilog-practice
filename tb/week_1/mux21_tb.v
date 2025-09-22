`timescale 1ns / 1ps

module mux21_tb ();
  reg a, b, sel;
  wire f;
  mux21 m1 (
      .a  (a),
      .b  (b),
      .sel(sel),
      .f  (f)
  );

  always #1 a = !a;
  always #2 b = !b;
  always #3 sel = !sel;

  initial begin
    $dumpvars();

    a   = 0;
    b   = 0;
    sel = 0;

    #6 $finish();
  end
endmodule
