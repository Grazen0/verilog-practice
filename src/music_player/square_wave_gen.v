module square_wave_gen #(
    parameter TIMER_WIDTH = 16
) (
    input wire clk,
    input wire rst_n,
    input wire [TIMER_WIDTH-1:0] divider,
    output reg speaker
);
    wire toggle;

    auto_reload_timer #(
        .WIDTH(TIMER_WIDTH)
    ) timer (
        .clk(clk),
        .rst_n(rst_n),
        .load_value(divider),
        .enable(divider != 0),
        .done(toggle)
    );

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            speaker <= 0;
        end else if (divider == 0) begin
            speaker <= 0;
        end
        if (toggle) begin
            speaker <= ~speaker;
        end
    end
endmodule
