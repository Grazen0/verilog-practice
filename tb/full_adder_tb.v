`timescale 1ns / 1ns

module full_adder_tb ();
  reg a, b, c_in;
  wire s, c_out;
  full_adder fa1 (
      .s(s),
      .c_out(c_out),
      .a(a),
      .b(b),
      .c_in(c_in)
  );

  initial begin
    $dumpfile(`DUMP_FILE);
    $dumpvars(0, full_adder_tb);

    a = 0;
    b = 0;
    c_in = 0;

    #10 a = 1;
    #10 b = 1;
    #10 c_in = 1;
    #10 b = 0;
    #10 a = 0;
    #10 b = 1;
    #10 c_in = 0;
    #10 a = 1;

    #10 $finish();
  end
endmodule







