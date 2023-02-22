//////////////////////////////////////////////////////////////////////////////////
// Company: ITESO
// Engineer: Jorge Alberto Padilla Gutierrez
// Module Description: Logic for PC Enable 
//////////////////////////////////////////////////////////////////////////////////

module PC_Enable (
	//Inputs
	input   PCWrite,
	input   Branch,
	input   Zero,
    input   XorZero,
	//Output
	output  PCEn
);

	//Declare the output
	assign PCEn = PCWrite | (Branch & (XorZero ^ Zero));

endmodule
