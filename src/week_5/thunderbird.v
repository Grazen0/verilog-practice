module thunderbird (
    input  wire clk,
    input  wire rst,
    input  wire left,
    input  wire right,
    output wire l0,
    output wire l1,
    output wire l2,
    output wire r0,
    output wire r1,
    output wire r2
);
    reg [2:0] state, next_state;

    localparam S000_000 = 3'b000;
    localparam S000_100 = 3'b001;
    localparam S000_110 = 3'b010;
    localparam S000_111 = 3'b011;
    localparam S001_000 = 3'b100;
    localparam S011_000 = 3'b101;
    localparam S111_000 = 3'b110;

    always @(posedge clk, posedge rst)
        if (rst) state <= S000_000;
        else state <= next_state;

    always @(*)
        case (state)
            S000_000:
            if (left) next_state <= S001_000;
            else if (right) next_state <= S000_100;
            else next_state <= state;
            S001_000: next_state <= S011_000;
            S011_000: next_state <= S111_000;
            S111_000: next_state <= S000_000;
            S000_100: next_state <= S000_110;
            S000_110: next_state <= S000_111;
            S000_111: next_state <= S000_000;
            default: next_state <= S000_000;
        endcase

    assign l0 = (state == S001_000 | state == S011_000 | state == S111_000);
    assign l1 = (state == S011_000 | state == S111_000);
    assign l2 = (state == S111_000);
    assign r0 = (state == S000_100 | state == S000_110 | state == S000_111);
    assign r1 = (state == S000_110 | state == S000_111);
    assign r2 = (state == S000_111);

endmodule
