module top(
    input clk,
    input rst,

    input spi_miso,
    output spi_mosi,
    output spi_sck,
    output spi_cs_n,
    output spi_block,
    
    output [7:0] disp_an,
    output [6:0] disp_o,
    output [15:0] led,
    
    output audio_jack
);

    parameter scanline_width = 320;
    parameter scanline_num = 256;

    assign spi_block = 0;

    wire load_trigger;
    wire [7:0] px_idata;
    wire [7:0] px_odata;

    wire load_done;
    wire send_trigger;
    wire err;

    indicator (clk, {err, load_done}, disp_an, disp_o);
    watchdog #(.clk_num(2400000000)) (clk, rst, load_done, err);

    sd_file_reader #(.FILE_NAME("sstv.bmp"), .SPI_CLK_DIV(100)) (
        .clk(clk), .rst_n(rst),
        .spi_miso(spi_miso), .spi_mosi(spi_mosi), .spi_clk(spi_sck), .spi_cs_n(spi_cs_n),
        .sdcardstate(), .sdcardtype(), .fatstate(), .filesystemtype(),
        .file_found(), .outreq(load_trigger), .outbyte(px_idata)
    );

    pixel_provider #(
        .scanline_width(scanline_width), .offset(54),
        .size(scanline_width * scanline_num * 3)
    )(
        .clk(clk), .rst(rst), .ena(load_done ? send_trigger : load_trigger),
        .i_data(px_idata), .o_data(px_odata), .d_ok(load_done), .led(led)
    );

    wave_sender #(.scanline_width(scanline_width), .scanline_num(scanline_num))
                 (clk, rst, load_done, px_odata, audio_jack, send_trigger);

endmodule