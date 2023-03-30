//////////////////////////////////////////////////////////////////////////////////
// Company: ITESO
// Engineer: Jorge Alberto Padilla Gutierrez
// Module Description: Simple n-bit Adder
//////////////////////////////////////////////////////////////////////////////////

`include "ALU_sel.sv"

module Adder #(parameter DATA_WIDTH = 32) (
	//Inputs
	input[DATA_WIDTH-1:0]   a,
	input[DATA_WIDTH-1:0]   b,
	//Outputs
	output [DATA_WIDTH-1:0] f
);

    //output logic of sum
    assign f = a + b;
	
endmodule