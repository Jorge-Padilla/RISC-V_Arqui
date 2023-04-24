//////////////////////////////////////////////////////////////////////////////////
// Company: ITESO 
// Engineer: Jorge Alberto Padilla Gutiérrez
// Module Description: Pipeline Forwarding Unit
//////////////////////////////////////////////////////////////////////////////////

module Forwarding_Unit #(parameter DATA_WIDTH=5)(
	//Inputs
	input [DATA_WIDTH-1:0]	Rs1,
	input [DATA_WIDTH-1:0]	Rs2,
	input [DATA_WIDTH-1:0]	M_Rd,
	input [DATA_WIDTH-1:0]	W_Rd,
	input                   M_RegWrite,
	input                   W_RegWrite,
	//Output
	output [1:0]            AForward,
	output [1:0]            BForward,
);

	//Assign the output as the selected input
	//assign Q = sel ? B : A;

endmodule
