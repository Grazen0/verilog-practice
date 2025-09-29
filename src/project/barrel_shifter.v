module barrel_shifter #(
    parameter WIDTH = 32
) (
    input wire [WIDTH-1:0] in,
    input wire [$clog2(WIDTH)-1:0] shift,
    input wire dir,
    output reg [WIDTH-1:0] out
);
    integer i;
    reg [WIDTH-1:0] stage[0:$clog2(WIDTH)];

    always @(*) begin
        stage[0] = in;

        for (i = 0; i < $clog2(WIDTH); i = i + 1) begin
            if (shift[i]) begin
                if (dir) begin
                    stage[i+1] = stage[i] >> (1 << i);
                end else begin
                    stage[i+1] = stage[i] << (1 << i);
                end
            end else begin
                stage[i+1] = stage[i];
            end
        end

        out = stage[$clog2(WIDTH)];
    end
endmodule
