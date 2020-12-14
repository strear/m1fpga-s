module indicator_test(
    input clk,
    output [7:0] disp_an,
    output [6:0] disp_o
);

    reg [9:0] span = 0;
    reg [7:0] i = 0;

    always @(clk) begin
        span = span + 1;
        if (span == 0) i = i + 1;
    end

    indicator(clk, i % 3, disp_an, disp_o);

endmodule