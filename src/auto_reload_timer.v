module auto_reload_timer #(
    parameter WIDTH = 16
) (
    input wire clk,
    input wire rst_n,
    input wire [WIDTH-1:0] load_value,
    input wire enable,
    output wire done
);
    reg [WIDTH-1:0] counter;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            counter <= 1;
        end else if (enable) begin
            if (counter == 1) begin
                counter <= load_value;
            end else begin
                counter <= counter - 1;
            end
        end
    end

    assign done = (counter == 1 & enable);
endmodule
