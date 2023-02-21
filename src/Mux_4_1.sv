//////////////////////////////////////////////////////////////////////////////////
// Company: ITESO 
// Engineer: Jorge Alberto Padilla Gutiérrez
// Module Description: Simple 4 to 1 Multiplexer
//////////////////////////////////////////////////////////////////////////////////

module Mux_4_1 #(parameter DATA_WIDTH=8)(
	//Inputs
	input [DATA_WIDTH-1:0]  A,
	input [DATA_WIDTH-1:0]  B,
	input [DATA_WIDTH-1:0]  C,
	input [DATA_WIDTH-1:0]  D,
	input [1:0]             sel,
	//Output
	output [DATA_WIDTH-1:0] Q
);

	//Internal wires
	wire [DATA_WIDTH-1:0] mux0, mux1;

	//Assign both 2 to 1 Muxes to the internal wires
	Mux_2_1  #(.DATA_WIDTH(DATA_WIDTH)) M0 (
		.A(A),
		.B(B),
		.sel(sel[0]),
		.Q(mux0)
	);
	Mux_2_1  #(.DATA_WIDTH(DATA_WIDTH)) M1 (
		.A(C),
		.B(D),
		.sel(sel[0]),
		.Q(mux1)
	);
	
	//Assign final 2 to 1 Mux to output
	Mux_2_1  #(.DATA_WIDTH(DATA_WIDTH)) M2 (
		.A(mux0),
		.B(mux1),
		.sel(sel[1]),
		.Q(Q)
	);

endmodule
