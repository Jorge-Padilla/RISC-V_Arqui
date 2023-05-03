//////////////////////////////////////////////////////////////////////////////////
// Company: ITESO
// Engineer: Jorge Alberto Padilla Gutierrez
// Module Description: Register File Module
//////////////////////////////////////////////////////////////////////////////////

module Reg_File #(parameter ADDRESS_WIDTH = 5, parameter DATA_WIDTH = 32) (
	//Inputs
	input                       clk,
	input                       rst,
	input                       we3,
	input [ADDRESS_WIDTH-1:0]   a1,
    input [ADDRESS_WIDTH-1:0]   a2,
    input [ADDRESS_WIDTH-1:0]   a3,
	input [DATA_WIDTH-1:0]      wd3,
	//Outputs
	output [DATA_WIDTH-1:0]     rd1,
    output [DATA_WIDTH-1:0]     rd2
);

	//Reg Outs
	wire [DATA_WIDTH-1:0] rdReg [2**ADDRESS_WIDTH-1:0];

	//Declaring the Registers array
	genvar i;
	generate
		for (i = 0; i < 2**ADDRESS_WIDTH; i = i + 1) begin : GENREGS
			if (i == 2)
				Reg_SP_Param  #(.DATA_WIDTH(DATA_WIDTH)) REG_i (
					.rst(rst),
					.clk(clk),
					//Write is sync, with x0 being always 0
					.en(we3 & (a3 == i)),
					.D(wd3),
					.Q(rdReg[i])
				);
			else if (i == 3)
				Reg_GP_Param  #(.DATA_WIDTH(DATA_WIDTH)) REG_i (
					.rst(rst),
					.clk(clk),
					//Write is sync, with x0 being always 0
					.en(we3 & (a3 == i)),
					.D(wd3),
					.Q(rdReg[i])
				);
			else
				Reg_Param  #(.DATA_WIDTH(DATA_WIDTH)) REG_i (
					.rst(rst),
					.clk(clk),
					//Write is sync, with x0 being always 0
					.en(we3 & (a3 == i)),
					.D(wd3),
					.Q(rdReg[i])
				);
		end
	endgenerate

	//Read is async, with x0 being always 0
	assign rd1 = (a1 == {ADDRESS_WIDTH{1'b0}}) ? {DATA_WIDTH{1'b0}} : rdReg[a1];
	assign rd2 = (a2 == {ADDRESS_WIDTH{1'b0}}) ? {DATA_WIDTH{1'b0}} : rdReg[a2];

endmodule