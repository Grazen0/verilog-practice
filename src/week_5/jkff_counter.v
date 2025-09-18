module jkff_counter (
    input clk,
    input rst,
    input j,
    input k,
    output [3:0] q
);
  jkff jk1 (
      .clk(clk),
      .rst(rst),
      .j  (j),
      .k  (k),
      .q  (q[0])
  );
  jkff jk2 (
      .clk(clk),
      .rst(rst),
      .j  (q[0]),
      .k  (q[0]),
      .q  (q[1])
  );
  jkff jk3 (
      .clk(clk),
      .rst(rst),
      .j  (q[1]),
      .k  (q[0]),
      .q  (q[2])
  );
  jkff jk4 (
      .clk(clk),
      .rst(rst),
      .j  (q[2]),
      .k  (q[2]),
      .q  (q[3])
  );
endmodule

