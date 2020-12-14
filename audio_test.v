`timescale 1ns / 1ps

module audio_test(
    input clk,
    output jack
);

    reg[31:0] delay = 50000000;
    wire toggle;
    fm(clk, delay, toggle);

    reg[31:0] num = 192307;
    fm(clk, num, jack);

    reg[3:0] c = 0;

    always @(negedge toggle) begin
        c = (c + 1) % 8;
        num = c > 6 ? 191131 : c > 5 ? 202511 : c > 4 ? 227272 : c > 3 ? 255102 : c > 2 ? 286368 : c > 1 ? 303398 : c > 0 ? 340599 : 382263;
    end

endmodule