module vm_mealy_bin (
    input  wire clk,
    input  wire rst_n,
    input  wire nickel,
    input  wire dime,
    input  wire quarter,
    output wire dispense,
    output wire return_nickel,
    output wire return_dime,
    output wire return_two_dimes
);
  localparam S0 = 3'b000;  // 0
  localparam S1 = 3'b001;  // 5
  localparam S2 = 3'b010;  // 10
  localparam S3 = 3'b011;  // 15
  localparam S4 = 3'b100;  // 20

  reg [2:0] state, next_state;

  always @(posedge clk, negedge rst_n)
    if (!rst_n) begin
      state <= S0;
    end else begin
      state <= next_state;
    end

  always @(*)
    case (state)
      S0: begin
        if (nickel) next_state <= S1;
        else if (dime) next_state <= S2;
        else if (quarter) next_state <= S0;
        else next_state = state;
      end
      S1: begin
        if (nickel) next_state <= S2;
        else if (dime) next_state <= S3;
        else if (quarter) next_state <= S0;
        else next_state = state;
      end
      S2: begin
        if (nickel) next_state <= S3;
        else if (dime) next_state <= S4;
        else if (quarter) next_state <= S0;
        else next_state = state;
      end
      S3: begin
        if (nickel) next_state <= S4;
        else if (dime) next_state <= S0;
        else if (quarter) next_state <= S0;
        else next_state = state;
      end
      S4: begin
        if (nickel) next_state <= S0;
        else if (dime) next_state <= S0;
        else if (quarter) next_state <= S0;
        else next_state = state;
      end
      default: begin
        next_state = S0;
      end
    endcase

  assign dispense =
      (state == S0 & quarter)
    | (state == S1 & quarter)
    | (state == S2 & quarter)
    | (state == S3 & (quarter | dime))
    | (state == S4 & (quarter | dime | nickel));
  assign return_nickel = (state == S1 & quarter) | (state == S3 & quarter) | (state == S4 & dime);
  assign return_dime = (state == S2 & quarter) | (state == S3 & quarter);
  assign return_two_dimes = (state == S4 & quarter);
endmodule
