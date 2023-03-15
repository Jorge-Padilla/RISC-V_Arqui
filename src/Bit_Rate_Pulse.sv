`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
//  Company: ITESO
//  Engineer: Jorge Alberto Padilla Gutierrez
//  Module Description: Bit rate pulse generator for a Serial RS-232 Receiver
//////////////////////////////////////////////////////////////////////////////////

module Bit_Rate_Pulse # (parameter DELAY_COUNTS = 11 ) (
    //Inputs
    input   clk,
    input   rst,
    input   enable,
    //Outputs
    output  end_bit_time,
    output  end_half_time
);
    
    localparam delay_bits = $clog2(DELAY_COUNTS);
    reg [delay_bits-1:0] count;  

    // Comparator
    assign end_bit_time  = (DELAY_COUNTS - 1'b1 == count) ? 1'b1 : 1'b0;
    assign end_half_time = ((DELAY_COUNTS - 1'b1)/2 == count) ? 1'b1 : 1'b0;

    // Counter
    always @(posedge clk, negedge rst) begin
        if (~rst)
            count <= {delay_bits{1'b0}};
        else 
            if (enable)
                if (end_bit_time)
                    count <= {delay_bits{1'b0}};
                else 
                    count <= count + 1'b1;
            else
                count <= count;
     end

endmodule
