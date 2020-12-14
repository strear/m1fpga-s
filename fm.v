module fm(
    input i_clk,
    input [31:0] freq,
    output reg o_clk = 0
);

    reg [31:0] i = 0;

    always @(posedge i_clk) begin
        if (i >= freq / 2 - 1) begin
            i <= 0;
            o_clk <= ~o_clk;
        end
        else i <= i + 1;
    end

endmodule