module serial_detector (
    input wire clk,
    input wire rst_n,
    input wire [3:0] x,
    output wire z
);
    localparam S0 = 2'b00;
    localparam S1 = 2'b01;
    localparam S2 = 2'b10;

    reg [1:0] state, next_state;
    reg [3:0] n1, n2, n3;

    always @(posedge clk, negedge rst_n) begin
        if (!rst_n) begin
            state <= S0;
            n1 <= 4'h0;
            n2 <= 4'h0;
            n3 <= 4'h0;
        end else begin
            n1 <= n2;
            n2 <= n3;
            n3 <= x;
            state <= next_state;
        end
    end

    always @(*) begin
        case (state)
            S0: next_state = S1;
            S1: next_state = S2;
            S2: next_state = S2;
            default: next_state = S0;
        endcase
    end

    assign z = (state == S2 && (n1 + n2 == n3 || n1 - n2 == n3));
endmodule
