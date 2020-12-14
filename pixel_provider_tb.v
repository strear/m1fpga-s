//~ `New testbench
`timescale  1ns / 1ps

module tb_pixel_provider;

// pixel_provider Parameters
parameter PERIOD          = 10       ;
parameter scanline_width  = 6        ;
parameter size            = 6 * 3 * 3;

// pixel_provider Inputs
reg   clk                                  = 0 ;
reg   rst                                  = 0 ;
reg   ena                                  = 1 ;
reg   [7:0]  i_data                        = 0 ;

// pixel_provider Outputs
wire  [7:0]  o_data                        ;
wire  [15:0]  led                          ;
wire  d_ok                                 ;

initial
begin
    forever #(PERIOD/2)  clk=~clk;
end

pixel_provider #(
    .scanline_width ( scanline_width ),
    .size           ( size           ))
 u_pixel_provider (
    .clk                     ( clk            ),
    .rst                     ( rst            ),
    .ena                     ( ena            ),
    .i_data                  ( i_data  [7:0]  ),

    .o_data                  ( o_data  [7:0]  ),
    .led                     ( led     [15:0] ),
    .d_ok                    ( d_ok           )
);

integer k;

initial
begin
    #(PERIOD/4)rst =    1;
            i_data =    0;

    for (k = 1; k <= 56; k = k + 1)
        #PERIOD i_data = k;
        
    #(PERIOD*70) $finish;
end

initial
begin
    #(PERIOD*239/4) ena = 0;
    forever #(PERIOD)  ena=~ena;
end

endmodule
