module wave_sender #(
    parameter scanline_width = 320,
    parameter scanline_num = 256
)(
    input clk,
    input rst,
    input i_ena,
    input [7:0] px_odata,

    output audio_jack,
    output reg send_trigger = 0
);

    reg [31:0] fm_diamter = 0;

    reg [31:0] wait_counter = 0;

    reg [3:0] vis_ptr = 0;
    reg [7:0] martin_m1_id = 8'b00110100;

    reg [$clog2(scanline_width + 1):0] inlinepos = 0;
    reg [$clog2(scanline_num + 1):0] linecur = 0;

    reg margin_trigger = 0;
    reg done = 0;

    fm (.i_clk(clk), .freq(fm_diamter), .o_clk(audio_jack));

    always @(posedge clk) begin

        if (~rst) begin

            fm_diamter <= 0;
            send_trigger <= 0;
            wait_counter <= 0;
            vis_ptr <= 0;
            linecur <= 0;
            inlinepos <= 0;
            done <= 0;
            margin_trigger <= 0;

        end
        else if (done) begin

            fm_diamter = 0;

        end
        else if (i_ena) begin
                
            if (wait_counter != 0) begin
                wait_counter = wait_counter - 1;
            end
            else begin

                if (vis_ptr <= 12) begin
                    
                    if (vis_ptr == 0 || vis_ptr == 2) begin
                        fm_diamter = 52631;      // 1900 Hz
                        wait_counter = 30000000; // 300 ms
                    end
                    else if (vis_ptr == 1 || vis_ptr == 3 || vis_ptr == 12) begin
                        fm_diamter = 83333;      // 1200 Hz
                        wait_counter = 3000000;  // 30 ms
                    end
                    else if (vis_ptr >= 4 && vis_ptr <= 11) begin
                        fm_diamter = martin_m1_id[vis_ptr - 4] ? 90909 : 76923;  // '0' = 1300 Hz, '1' = 1100 Hz
                        wait_counter = 3000000;  // 30 ms
                    end
                    
                    vis_ptr = vis_ptr + 1;

                end
                else begin
                
                    if (margin_trigger) begin

                        fm_diamter = 66666;   // 1500 Hz
                        wait_counter = 57200; // 0.572 ms
                        margin_trigger = 0;

                    end
                    else if (inlinepos == 0) begin

                        linecur = linecur + 1;

                        if (linecur >= scanline_num) begin
                            done = 1;
                        end
                        else begin
                            fm_diamter = 83333;    // 1200 Hz
                            wait_counter = 486200; // 4.862 ms
                            margin_trigger = 1;
                        end

                        inlinepos = 1;

                    end
                    else if (send_trigger) begin
                        
                        fm_diamter = 100000000 / (px_odata * 800 / 255 + 1500);
                        wait_counter = 45760;  // 0.4576 ms
                        send_trigger = 0;
                        
                        if ((inlinepos - 1) % scanline_width == 0 && inlinepos != 1) begin
                            margin_trigger = 1;
                        end

                        inlinepos = (inlinepos + 1) % (3 * scanline_width + 1);

                    end
                    else begin
                        send_trigger = 1;
                    end
                    
                end
            end
        end
    end
    
endmodule