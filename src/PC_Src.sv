//////////////////////////////////////////////////////////////////////////////////
// Company: ITESO
// Engineer: Jorge Alberto Padilla Gutierrez
// Module Description: Logic for PC Enable 
//////////////////////////////////////////////////////////////////////////////////

module PC_Src (
	//Inputs
	input   PCWrite,
	input   Branch,
	input   Zero,
    input   XorZero,
	//Output
	output  PCSrc
);

	//Declare the output
	assign PCSrc = PCWrite | (Branch & (XorZero ^ Zero));

endmodule
