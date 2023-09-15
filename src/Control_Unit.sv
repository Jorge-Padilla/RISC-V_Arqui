//////////////////////////////////////////////////////////////////////////////////
// Company: ITESO
// Engineer: Jorge Alberto Padilla Gutierrez
// Module Description: RISC-V Control Unit
//////////////////////////////////////////////////////////////////////////////////

`include "Control_Unit_defs.sv"
`include "ALU_sel.sv"

import Control_Unit_enum::*;

module Control_Unit(
	//Inputs
	input           clk,
	input           rst,
	input[6:0]      Opcode,
	input[6:0]      Funct7,
	input[2:0]      Funct3,
	//Outputs
	output reg[1:0] ALUSrcA,
	output reg[1:0] ALUSrcB,
	output reg[1:0] ShiftAmnt,
	output reg[2:0] SignExt,
	output reg      PCEn, 
	output reg      MemWrite, 
	output reg      MemRead,
	output reg      RegWrite,
	output reg      RegMul,
	output reg      Jump,
	output reg      Branch,
	output reg      XorZero,
	output reg      MemtoReg,
	output reg		JalrMux,
	output reg[4:0] ALUControl
);
	
	//Combinational Output Block
	always @(*) begin
		case(Opcode)
			`OPCODE_REG: begin
				PCEn		= 1'b1;	
				MemWrite	= 1'b0;		
				MemRead		= 1'b0;		
				RegWrite	= ~Funct7[0];	//Write to RegFile, If MUL will be written by RegMul
				RegMul		= Funct7[0];	//Multiplication defined by 1st bit of Funct7
				Jump		= 1'b0;		
				Branch		= 1'b0;		
				XorZero		= 1'b0;		
				SignExt		= `EXT_NONE;	
				ShiftAmnt	= `SHIFT_0;	
				JalrMux		= 1'b0;		
				ALUSrcA		= `ALU_A_REG;	//rs1 is source a
				ALUSrcB		= `ALU_B_REG;	//rs2 is source b
				MemtoReg	= 1'b0;		
				ALUControl	= {Funct7[5],Funct7[0],Funct3};	//Functions define ALU Operation
			end
			`OPCODE_IMMI: begin
				PCEn		= 1'b1;	
				MemWrite	= 1'b0;		
				MemRead		= 1'b0;		
				RegWrite	= 1'b1;			//Write to RegFile
				RegMul		= 1'b0;
				Jump		= 1'b0;		
				Branch		= 1'b0;		
				XorZero		= 1'b0;		
				SignExt		= `EXT_IMMI;	//Extend from 12 bits I-type
				ShiftAmnt	= `SHIFT_0;	
				JalrMux		= 1'b0;		
				ALUSrcA		= `ALU_A_REG;	//rs1 is source a
				MemtoReg	= 1'b0;		
				case (Funct3)
					`FUNCT_SHIFT_LEFT : begin
						ALUSrcB		= `ALU_B_IMM5;					//Immidiate[4:0] is source b
						ALUControl	= {Funct7[5],Funct7[0],Funct3};	//Function defined by instruction, Immi defines srl or sra
					end
					`FUNCT_SHIFT_RIGHT : begin
						ALUSrcB		= `ALU_B_IMM5;					//Immidiate[4:0] is source b
						ALUControl	= {Funct7[5],Funct7[0],Funct3};	//Function defined by instruction, Immi defines srl or sra
					end
					default	 : begin
						ALUSrcB		= `ALU_B_IMM;					//Immidiate is source b
						ALUControl	= {2'b00,Funct3};				//Function defined by instruction, no SUB no MUL
					end
				endcase
			end
			`OPCODE_LOAD: begin
				PCEn		= 1'b1;	
				MemWrite	= 1'b0;		
				MemRead		= 1'b1;			//Read from Memory Map
				RegWrite	= 1'b1;			//Write to RegFile
				RegMul		= 1'b0;
				Jump		= 1'b0;		
				Branch		= 1'b0;		
				XorZero		= 1'b0;		
				SignExt		= `EXT_LOAD;	//Extend from 12 bits I-type
				ShiftAmnt	= `SHIFT_0;	
				JalrMux		= 1'b0;		
				ALUSrcA		= `ALU_A_REG;	//rs1 is source a
				ALUSrcB		= `ALU_B_IMM;	//Immidiate is source b
				MemtoReg	= 1'b1;			//Write on RegFile from Memory
				ALUControl	= `SEL_ADD;		//Select ADD operation
			end
			`OPCODE_STORE: begin
				PCEn		= 1'b1;	
				MemWrite	= 1'b1;			//Write to Memory Map
				MemRead		= 1'b0;
				RegWrite	= 1'b0;
				RegMul		= 1'b0;
				Jump		= 1'b0;		
				Branch		= 1'b0;		
				XorZero		= 1'b0;		
				SignExt		= `EXT_STORE;	//Extend from 12 bits S-type
				ShiftAmnt	= `SHIFT_0;	
				JalrMux		= 1'b0;		
				ALUSrcA		= `ALU_A_REG;	//rs1 is source a
				ALUSrcB		= `ALU_B_IMM;	//Immidiate is source b
				MemtoReg	= 1'b0;		
				ALUControl	= `SEL_ADD;		//Select ADD operation
			end
			`OPCODE_BRANCH: begin
				PCEn		= 1'b1;	
				MemWrite	= 1'b0;		
				MemRead		= 1'b0;			
				RegWrite	= 1'b0;		
				RegMul		= 1'b0;	
				Jump		= 1'b0;		
				Branch		= 1'b1;			//Branch enable for possible change on PC
				SignExt		= `EXT_BRA;		//Extend from 12 bits B-type
				ShiftAmnt	= `SHIFT_1;		//Branch and Jump require extra bit
				JalrMux		= 1'b0;		
				ALUSrcA		= `ALU_A_REG;	//rs1 is source a
				ALUSrcB		= `ALU_B_REG;	//rs2 is source b
				MemtoReg	= 1'b0;		
				case (Funct3)
					`BRANCH_EQ: begin
						XorZero		= 1'b0;			//Branch Equal
						ALUControl	= `SEL_XOR;		//Branch Equal or Not Equal
					end
					`BRANCH_NE: begin
						XorZero		= 1'b1;			//Branch Not Equal
						ALUControl	= `SEL_XOR;		//Branch Equal or Not Equal
					end
					`BRANCH_LT: begin
						XorZero		= 1'b1;			//Branch Less Than
						ALUControl	= `SEL_SLT;		//Branch Less Than or Greater Than or Equal
					end
					`BRANCH_GTE: begin
						XorZero		= 1'b0;			//Branch Greater Than or Equal
						ALUControl	= `SEL_SLT;		//Branch Less Than or Greater Than or Equal
					end
					`BRANCH_LTU: begin
						XorZero		= 1'b1;			//Branch Less Than Unsigned
						ALUControl	= `SEL_SLTU;	//Branch Less Than Unsigned or Greater Than or Equal Unsigned
					end
					`BRANCH_GTEU: begin
						XorZero		= 1'b0;			//Branch Less Greater Than or Equal Unsigned
						ALUControl	= `SEL_SLTU;	//Branch Less Than Unsigned or Greater Than or Equal Unsigned
					end
					default: begin
						XorZero		= 1'b0;			//Invalid
						ALUControl	= `SEL_XOR;		//Invalid
					end
				endcase
			end
			`OPCODE_JAL: begin
				PCEn		= 1'b1;	
				MemWrite	= 1'b0;			
				MemRead		= 1'b0;			
				RegWrite	= 1'b1;			//Write to RegFile
				RegMul		= 1'b0;
				Jump		= 1'b1;			//Jump enable for change on PC
				Branch		= 1'b0;			
				XorZero		= 1'b0;		
				SignExt		= `EXT_JAL;		//Extend from 30 bits
				ShiftAmnt	= `SHIFT_1;		//Branch and Jump require extra bit
				JalrMux		= 1'b0;		
				ALUSrcA		= `ALU_A_PC;	//PC is source a
				ALUSrcB		= `ALU_B_FOUR;	//32'h4 is source b
				MemtoReg	= 1'b0;		
				ALUControl	= `SEL_ADD;		//Select ADD operation
			end
			`OPCODE_JALR: begin
				PCEn		= 1'b1;	
				MemWrite	= 1'b0;			
				MemRead		= 1'b0;			
				RegWrite	= 1'b1;			//Write to RegFile
				RegMul		= 1'b0;
				Jump		= 1'b1;			//Jump enable for change on PC
				Branch		= 1'b0;			
				XorZero		= 1'b0;		
				SignExt		= `EXT_JALR;	//Extend from 12 bits I-type
				ShiftAmnt	= `SHIFT_1;		//Branch and Jump require extra bit
				JalrMux		= 1'b1;			//Use rs1 as new PC for sum
				ALUSrcA		= `ALU_A_PC;	//PC is source a
				ALUSrcB		= `ALU_B_FOUR;	//32'h4 is source b
				MemtoReg	= 1'b0;		
				ALUControl	= `SEL_ADD;		//Select ADD operation
			end
			`OPCODE_LUI: begin
				PCEn		= 1'b1;	
				MemWrite	= 1'b0;		
				MemRead		= 1'b0;		
				RegWrite	= 1'b1;			//Write to RegFile
				RegMul		= 1'b0;
				Jump		= 1'b0;		
				Branch		= 1'b0;		
				XorZero		= 1'b0;		
				SignExt		= `EXT_UPPER;	//Extend from U-type
				ShiftAmnt	= `SHIFT_C;		//Shif 12 bits for U instruction
				JalrMux		= 1'b0;		
				ALUSrcA		= `ALU_A_ZERO;	//0 is source a
				ALUSrcB		= `ALU_B_IMM;	//Immidiate is source b
				MemtoReg	= 1'b0;		
				ALUControl	= `SEL_ADD;		//Functions define ALU Operation
			end
			`OPCODE_AUIPC: begin
				PCEn		= 1'b1;	
				MemWrite	= 1'b0;		
				MemRead		= 1'b0;		
				RegWrite	= 1'b1;			//Write to RegFile
				RegMul		= 1'b0;
				Jump		= 1'b0;		
				Branch		= 1'b0;		
				XorZero		= 1'b0;		
				SignExt		= `EXT_UPPER;	//Extend from U-type
				ShiftAmnt	= `SHIFT_C;		//Shif 12 bits for U instruction
				JalrMux		= 1'b0;		
				ALUSrcA		= `ALU_A_PC;	//PC is source a
				ALUSrcB		= `ALU_B_IMM;	//Immidiate is source b
				MemtoReg	= 1'b0;		
				ALUControl	= `SEL_ADD;		//Functions define ALU Operation
			end
			`OPCODE_STALL: begin
				PCEn		= 1'b0;			//On reset, PC is not incremented
				MemWrite	= 1'b0;		
				MemRead		= 1'b0;		
				RegWrite	= 1'b0;	
				RegMul		= 1'b0;	
				Jump		= 1'b0;		
				Branch		= 1'b0;		
				XorZero		= 1'b0;		
				SignExt		= `EXT_NONE;	
				ShiftAmnt	= `SHIFT_0;		
				JalrMux		= 1'b0;		
				ALUSrcA		= `ALU_A_REG;	
				ALUSrcB		= `ALU_B_REG;	
				MemtoReg	= 1'b0;		
				ALUControl	= `SEL_ADD;	
			end
			default: begin
				PCEn		= 1'b0;			//On reset, PC is not incremented
				MemWrite	= 1'b0;		
				MemRead		= 1'b0;		
				RegWrite	= 1'b0;	
				RegMul		= 1'b0;	
				Jump		= 1'b0;		
				Branch		= 1'b0;		
				XorZero		= 1'b0;		
				SignExt		= `EXT_NONE;	
				ShiftAmnt	= `SHIFT_0;		
				JalrMux		= 1'b0;		
				ALUSrcA		= `ALU_A_REG;	
				ALUSrcB		= `ALU_B_REG;	
				MemtoReg	= 1'b0;		
				ALUControl	= `SEL_ADD;	
			end
		endcase
	end

endmodule