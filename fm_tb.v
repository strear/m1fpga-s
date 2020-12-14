//~ `New testbench
`timescale  1ns / 1ps

module tb_fm;

// fm Parameters
parameter PERIOD  = 2;


// fm Inputs
reg   i_clk                                = 0 ;
reg   [31:0]  freq                         = 0 ;

// fm Outputs
wire  o_clk                                ;


initial
begin
    forever #(PERIOD/2)  i_clk=~i_clk;
end

fm  u_fm (
    .i_clk                   ( i_clk         ),
    .freq                    ( freq   [31:0] ),

    .o_clk                   ( o_clk         )
);

initial
begin
    freq = 10000;
    #(PERIOD * 12500) freq = 5000;
    #(PERIOD * 4500) freq = 2500;
    #(PERIOD * 5000) $finish;
end

endmodule
