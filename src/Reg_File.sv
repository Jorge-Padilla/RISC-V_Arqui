//////////////////////////////////////////////////////////////////////////////////
// Company: ITESO
// Engineer: Jorge Alberto Padilla Gutierrez
// Module Description: Register File Module
//////////////////////////////////////////////////////////////////////////////////

module Reg_File #(parameter ADDRESS_WIDTH = 5, parameter DATA_WIDTH = 32) (
	//Inputs
	input                       clk,
	input                       we3,
	input [ADDRESS_WIDTH-1:0]   a1,
    input [ADDRESS_WIDTH-1:0]   a2,
    input [ADDRESS_WIDTH-1:0]   a3,
	input [DATA_WIDTH-1:0]      wd3,
	//Outputs
	output [DATA_WIDTH-1:0]     rd1,
    output [DATA_WIDTH-1:0]     rd2
);

	//Declaring the Registers array
	reg [DATA_WIDTH-1:0] registers [2**ADDRESS_WIDTH-1:0];

	//Initialize Zero and SP
	initial begin
		registers[0] = 32'h0;
		registers[2] = 32'h7fffeffc;
		registers[3] = 32'h10008000;
	end
	
	//Read is async, with x0 being always 0
	assign rd1 = (a1 == {ADDRESS_WIDTH{1'b0}}) ? {DATA_WIDTH{1'b0}} : registers[a1];
	assign rd2 = (a2 == {ADDRESS_WIDTH{1'b0}}) ? {DATA_WIDTH{1'b0}} : registers[a2];

	//Write is sync, with x0 being always 0
	always @(posedge clk)
		if(we3)
			registers[a3] <= (a3 == {ADDRESS_WIDTH{1'b0}}) ? {DATA_WIDTH{1'b0}} : wd3;

endmodule