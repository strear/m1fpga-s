module pixel_provider #(
    parameter scanline_width = 320,
    parameter offset = 54,
    parameter size = 320 * 256 * 3
)(
    input clk,
    input rst,
    input ena,
    input [7:0] i_data,
    output reg [7:0] o_data,
    output [15:0] led,
    output reg d_ok = 0
);

    reg [7:0] databuf [0:size + offset - 1];

    reg [$clog2(size + offset + 1):0] i = 0;
    
    assign led[7:0] = d_ok ? o_data : i_data;
    assign led[13:8] = i[5:0];
    assign led[14] = d_ok;
    assign led[15] = ena;

    always @(posedge clk) begin
        
        if (~rst) begin
            i = 0;
            d_ok = 0;
        end
        else if (!d_ok) begin
            if (i >= size + offset) begin
                d_ok <= 1;
                i = size + offset - scanline_width * 3 + 1;
            end
            else if (ena) begin
                databuf[i] = i_data;
                i = i + 1;
            end
        end
        else if (i >= offset) begin
            if (ena) begin
                o_data = databuf[i];

                if ((i - offset + 3) % (scanline_width * 3) == 0)
                    i = i - scanline_width * 3 + 5;
                else if ((i - offset + 2) % (scanline_width * 3) == 0)
                    i = i - scanline_width * 3 + 2;
                else if ((i - offset + 1) % (scanline_width * 3) == 0)
                    i = i - scanline_width * 6 + 2;
                else
                    i = i + 3;
            end
        end
        else begin
            i = 8'b10101010;
        end

    end

endmodule