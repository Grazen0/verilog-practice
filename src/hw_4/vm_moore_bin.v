module vm_moore_bin (
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
    localparam S0 = 4'b0000;  // 0
    localparam S1 = 4'b0001;  // 5
    localparam S2 = 4'b0010;  // 10
    localparam S3 = 4'b0011;  // 15
    localparam S4 = 4'b0100;  // 20
    localparam S5 = 4'b0101;  // 25
    localparam S6 = 4'b0110;  // 30
    localparam S7 = 4'b0111;  // 35
    localparam S8 = 4'b1000;  // 40
    localparam S9 = 4'b1001;  // 45

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
