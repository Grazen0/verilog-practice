module dff_async (
    input clk,
    input load,
    input pause,
    input p_data,
    input s_data,
    output reg q
);
  always @(posedge clk or negedge load)
    if (load == 0) q <= p_data;
    else if (pause == 0) q <= s_data;
    else q <= q;
endmodule

module shift_reg (
    input clk,
    input load,
    input pause,
    input [3:0] data_in,
    output serial_out
);
  wire w1, w2, w3;

  dff_async t1 (
      .clk(clk),
      .load(load),
      .pause(pause),
      .p_data(data_in[0]),
      .s_data(1'b0),
      .q(w1)
  );
  dff_async t2 (
      .clk(clk),
      .load(load),
      .pause(pause),
      .p_data(data_in[1]),
      .s_data(w1),
      .q(w2)
  );
  dff_async t3 (
      .clk(clk),
      .load(load),
      .pause(pause),
      .p_data(data_in[2]),
      .s_data(w2),
      .q(w3)
  );
  dff_async t4 (
      .clk(clk),
      .load(load),
      .pause(pause),
      .p_data(data_in[3]),
      .s_data(w3),
      .q(serial_out)
  );
endmodule
