//////////////////////////////////////////////////////////////////////////////////
// Company: ITESO
// Engineer: Jorge Alberto Padilla Gutierrez
// Module Description: RISC-V ALU
//////////////////////////////////////////////////////////////////////////////////

`include "ALU_sel.sv"

module ALU(
	//Inputs
	input[31:0]			a,
	input[31:0]			b,
	input[4:0]			sel,
	//Outputs
	output reg[31:0]	f,
	output reg			z
);

	//Combinational Always
	always @(*)
	begin
		//Selector
		case (sel)
			`SEL_ADD	: f = a + b;											//add
			`SEL_SUB	: f = a - b;											//sub
			`SEL_XOR	: f = a ^ b;											//xor
			`SEL_OR		: f = a | b;											//or
			`SEL_AND	: f = a & b;											//and
			`SEL_SLL	: f = a << b;											//sll
			`SEL_SRL	: f = a >> b;											//srl
			`SEL_SRA	: f = signed'(a) >>> b;									//sra
			`SEL_SLT	: f = (signed'(a) < signed'(b)) ? 32'h1 : 32'h0;		//slt
			`SEL_SLTU	: f = (unsigned'(a) < unsigned'(b)) ? 32'h1 : 32'h0;	//sltu
			`SEL_MUL	: f = a * b;											//mul
			default		: f = 32'h0;
		endcase
		//Zero flag
		if (f == 0)
			z = 1'b1;
		else
			z = 1'b0;
	end
	
endmodule