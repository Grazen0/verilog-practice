module vm_moore_onehot (
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
    localparam S0 = 10'b00_0000_0001;  // 0
    localparam S1 = 10'b00_0000_0010;  // 5
    localparam S2 = 10'b00_0000_0100;  // 10
    localparam S3 = 10'b00_0000_1000;  // 15
    localparam S4 = 10'b00_0001_0000;  // 20
    localparam S5 = 10'b00_0010_0000;  // 25
    localparam S6 = 10'b00_0100_0000;  // 30
    localparam S7 = 10'b00_1000_0000;  // 35
    localparam S8 = 10'b01_0000_0000;  // 40
    localparam S9 = 10'b10_0000_0000;  // 45

    reg [3:0] state, next_state;

    always @(posedge clk, negedge rst_n)
        if (!rst_n) begin
            state <= S0;
        end else begin
            state <= next_state;
        end

    always @(*)
        case (state)
            S0, S5, S6, S7, S8, S9: begin
                if (nickel) next_state <= S1;
                else if (dime) next_state <= S2;
                else if (quarter) next_state <= S5;
                else next_state = S0;
            end
            S1: begin
                if (nickel) next_state <= S2;
                else if (dime) next_state <= S3;
                else if (quarter) next_state <= S6;
                else next_state = state;
            end
            S2: begin
                if (nickel) next_state <= S3;
                else if (dime) next_state <= S4;
                else if (quarter) next_state <= S7;
                else next_state = state;
            end
            S3: begin
                if (nickel) next_state <= S4;
                else if (dime) next_state <= S5;
                else if (quarter) next_state <= S8;
                else next_state = state;
            end
            S4: begin
                if (nickel) next_state <= S5;
                else if (dime) next_state <= S6;
                else if (quarter) next_state <= S9;
                else next_state = state;
            end
            default: begin
                next_state = S0;
            end
        endcase

    assign dispense = (state == S5 | state == S6 | state == S7 | state == S8 | state == S9);
    assign return_nickel = (state == S6 | state == S8);
    assign return_dime = (state == S7 | state == S8);
    assign return_two_dimes = (state == S9);
endmodule
