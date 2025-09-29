`timescale 1ns / 1ps

module vm_tb ();
  reg clk, rst_n, nickel, dime, quarter;
  wire mo_dispense, mo_return_nickel, mo_return_dime, mo_return_two_dimes;
  wire me_dispense, me_return_nickel, me_return_dime, me_return_two_dimes;

  vm_moore_bin vm_moore (
      .clk(clk),
      .rst_n(rst_n),
      .nickel(nickel),
      .dime(dime),
      .quarter(quarter),
      .dispense(mo_dispense),
      .return_nickel(mo_return_nickel),
      .return_dime(mo_return_dime),
      .return_two_dimes(mo_return_two_dimes)
  );

  vm_mealy_bin vm_mealy (
      .clk(clk),
      .rst_n(rst_n),
      .nickel(nickel),
      .dime(dime),
      .quarter(quarter),
      .dispense(me_dispense),
      .return_nickel(me_return_nickel),
      .return_dime(me_return_dime),
      .return_two_dimes(me_return_two_dimes)
  );

  always #5 clk = ~clk;

  initial begin
    $dumpvars(0, vm_tb);

    clk   = 1;
    rst_n = 0;

    #2 rst_n = 1;
    #3;

    nickel = 1;
    dime = 0;
    quarter = 0;
    #20;
    nickel = 0;
    dime = 1;
    quarter = 0;
    #10;
    nickel = 0;
    dime = 0;
    quarter = 1;
    #10;
    nickel = 0;
    dime = 0;
    quarter = 0;
    #10;
    nickel = 1;
    dime = 0;
    quarter = 0;
    #10;
    nickel = 0;
    dime = 0;
    quarter = 1;

    #30 $finish();
  end
endmodule
