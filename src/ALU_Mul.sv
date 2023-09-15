//////////////////////////////////////////////////////////////////////////////////
// Company: ITESO
// Engineer: Jorge Alberto Padilla Gutierrez
// Module Description: RISC-V ALU
//////////////////////////////////////////////////////////////////////////////////

`include "ALU_sel.sv"

module ALU(
	//Inputs
	input[31:0]		a,
	input[31:0]		b,
	input[4:0]		sel,
	input			clk,
	input			rst,
	input[4:0]		Rs1,
	input[4:0]		Rs2,
	input[4:0]		Rd,
	//Outputs
	output[31:0]	f,
	output[4:0]		Rs1_1,
	output[4:0]		Rs2_1,
	output[4:0]		Rd_1,
	output[4:0]		Rs1_2,
	output[4:0]		Rs2_2,
	output[4:0]		Rd_2,
	output[4:0]		Rs1_3,
	output[4:0]		Rs2_3,
	output[4:0]		Rd_3,
	output[4:0]		Rs1_Out,
	output[4:0]		Rs2_Out,
	output[4:0]		Rd_Out,
	output			regmul_Out
);

	//4 cycles multiplication
	reg[31:0]	f_0;
	reg[31:0]	f_1;
	reg[31:0]	f_2;
	reg[31:0]	f_3;
	reg			regmul_1;
	reg			regmul_2;
	reg			regmul_3;

	//Combinational Always
	always @(*)
	begin
		//Selector
		case (sel)
			`SEL_MUL	: f_0 = a * b;	//mul
			default		: f_0 = 32'h0;
		endcase
	end

	// From 0 to 1
	Reg_Param #(.DATA_WIDTH(32)) F0F1 (
		.rst(rst),
		.clk(clk),
		.en(1'b1),
		.D(f_0),
		.Q(f_1)
	);
	Reg_Param #(.DATA_WIDTH(5)) RS10RS11 (
		.rst(rst),
		.clk(clk),
		.en(1'b1),
		.D(Rs1),
		.Q(Rs1_1)
	);
	Reg_Param #(.DATA_WIDTH(5)) RS20RS21 (
		.rst(rst),
		.clk(clk),
		.en(1'b1),
		.D(Rs2),
		.Q(Rs2_1)
	);
	Reg_Param #(.DATA_WIDTH(5)) RD0RD1 (
		.rst(rst),
		.clk(clk),
		.en(1'b1),
		.D(Rd),
		.Q(Rd_1)
	);
	Reg_Param #(.DATA_WIDTH(1)) RM0RM1 (
		.rst(rst),
		.clk(clk),
		.en(1'b1),
		.D(sel[3]),
		.Q(regmul_1)
	);

	// From 1 to 2
	Reg_Param #(.DATA_WIDTH(32)) F1F2 (
		.rst(rst),
		.clk(clk),
		.en(1'b1),
		.D(f_1),
		.Q(f_2)
	);
	Reg_Param #(.DATA_WIDTH(5)) RS11RS12 (
		.rst(rst),
		.clk(clk),
		.en(1'b1),
		.D(Rs1_1),
		.Q(Rs1_2)
	);
	Reg_Param #(.DATA_WIDTH(5)) RS21RS22 (
		.rst(rst),
		.clk(clk),
		.en(1'b1),
		.D(Rs2_1),
		.Q(Rs2_2)
	);
	Reg_Param #(.DATA_WIDTH(5)) RD1RD2 (
		.rst(rst),
		.clk(clk),
		.en(1'b1),
		.D(Rd_1),
		.Q(Rd_2)
	);
	Reg_Param #(.DATA_WIDTH(1)) RM1RM2 (
		.rst(rst),
		.clk(clk),
		.en(1'b1),
		.D(regmul_1),
		.Q(regmul_2)
	);

	// From 2 to 3
	Reg_Param #(.DATA_WIDTH(32)) F2F3 (
		.rst(rst),
		.clk(clk),
		.en(1'b1),
		.D(f_2),
		.Q(f_3)
	);
	Reg_Param #(.DATA_WIDTH(5)) RS12RS13 (
		.rst(rst),
		.clk(clk),
		.en(1'b1),
		.D(Rs1_2),
		.Q(Rs1_3)
	);
	Reg_Param #(.DATA_WIDTH(5)) RS22RS23 (
		.rst(rst),
		.clk(clk),
		.en(1'b1),
		.D(Rs2_2),
		.Q(Rs2_3)
	);
	Reg_Param #(.DATA_WIDTH(5)) RD2RD3 (
		.rst(rst),
		.clk(clk),
		.en(1'b1),
		.D(Rd_2),
		.Q(Rd_3)
	);
	Reg_Param #(.DATA_WIDTH(1)) RM2RM3 (
		.rst(rst),
		.clk(clk),
		.en(1'b1),
		.D(regmul_2),
		.Q(regmul_3)
	);

	// From 3 to out
	Reg_Param #(.DATA_WIDTH(32)) F3FOUT (
		.rst(rst),
		.clk(clk),
		.en(1'b1),
		.D(f_3),
		.Q(f)
	);
	Reg_Param #(.DATA_WIDTH(5)) RS13RS1OUT (
		.rst(rst),
		.clk(clk),
		.en(1'b1),
		.D(Rs1_3),
		.Q(Rs1_Out)
	);
	Reg_Param #(.DATA_WIDTH(5)) RS23RS2OUT (
		.rst(rst),
		.clk(clk),
		.en(1'b1),
		.D(Rs2_3),
		.Q(Rs2_Out)
	);
	Reg_Param #(.DATA_WIDTH(5)) RD3RDOUT (
		.rst(rst),
		.clk(clk),
		.en(1'b1),
		.D(Rd_3),
		.Q(Rd_Out)
	);
	Reg_Param #(.DATA_WIDTH(1)) RM3RMOUT (
		.rst(rst),
		.clk(clk),
		.en(1'b1),
		.D(regmul_3),
		.Q(regmul_Out)
	);
	
endmodule