module watchdog #(
    parameter clk_num = 2400000000
)(
    input clk,
    input rst,
    input ok,
    output reg err
);

    reg [$clog2(clk_num + 1):0] counter = 0;

    always @(posedge clk) begin
        
        if (~rst) begin
            counter <= 0;
            err <= 0;
        end
        else if (counter == clk_num) begin
            err <= !ok;
        end
        else begin
            counter <= counter + 1;
        end
        
    end

endmodule