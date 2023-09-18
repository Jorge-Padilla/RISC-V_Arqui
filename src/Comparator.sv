//////////////////////////////////////////////////////////////////////////////////
// Company: ITESO
// Engineer: Jorge Alberto Padilla Gutierrez
// Module Description: Simple n-bit Comparator module
//////////////////////////////////////////////////////////////////////////////////

module Comparator #(parameter DATA_WIDTH = 32) (
	//Inputs
	input[DATA_WIDTH-1:0]   a,
	input[DATA_WIDTH-1:0]   b,
	//Outputs
	output f
);

    //output logic of sum
    assign f = (a == b) ? 1'b1 : 1'b0;
	
endmodule