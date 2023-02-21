//////////////////////////////////////////////////////////////////////////////////
// Company: ITESO 
// Engineer: Jorge Alberto Padilla Gutiérrez
// Module Description: Simple 2 to 1 Multiplexer
//////////////////////////////////////////////////////////////////////////////////

module Mux_2_1 #(parameter DATA_WIDTH=8)(
	//Inputs
	input [DATA_WIDTH-1:0]	A,
	input [DATA_WIDTH-1:0]	B,
	input sel,
	//Output
	output [DATA_WIDTH-1:0]	Q
);

	//Assign the output as the selected input
	assign Q = sel ? B : A;

endmodule
