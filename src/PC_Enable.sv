//////////////////////////////////////////////////////////////////////////////////
// Company: ITESO
// Engineer: Jorge Alberto Padilla Gutierrez
// Module Description: Logic for PC Enable 
//////////////////////////////////////////////////////////////////////////////////

module PC_Enable (
	//Inputs
	input   D_PCEn,
	input   D_PCWrite,
	//Output
	output  F_PCEn
);

	//Declare the output
	assign F_PCEn = D_PCEn & D_PCWrite;

endmodule
