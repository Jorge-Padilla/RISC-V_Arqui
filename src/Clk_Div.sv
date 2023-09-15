//////////////////////////////////////////////////////////////////////////////////
// Company: ITESO
// Engineer: Jorge Alberto Padilla Gutierrez
// Module Description: Frequency divisor from 50MHz to 1MHz
//////////////////////////////////////////////////////////////////////////////////

import Control_Unit_enum::*;

module Clk_Div #( parameter MAX_COUNT = 25000000, parameter NUMBER_OF_BITS = $clog2(MAX_COUNT)) (
	//Inputs
	input wire  clk,
	input wire  rst,
	//Outputs
    output reg  out_clk
);

    //Counter
    reg [NUMBER_OF_BITS-1:0] cnt = 'h0;

    always @(posedge clk, negedge rst) begin
        if (~rst)
            cnt <= 'h0;
        else
            if (cnt == (MAX_COUNT-1)) begin
                cnt     <= 'h0;
                out_clk <= ~out_clk;               
            end else
                cnt     <= cnt + 1'b1;
    end

endmodule