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
	input           tx_fsm_in_STOP_S,
	//Outputs
	output reg[1:0] ALUSrcA,
	output reg[1:0] ALUSrcB,
	output reg[1:0] ShiftAmnt,
	output reg[2:0] SignExt,
	output reg		PCSrc,
	output reg      MemWrite, 
	output reg      MemRead,
	output reg      IRWrite,
	output reg      RegWrite,
	output reg      PCWrite,
	output reg      IorD,
	output reg      Branch,
	output reg      XorZero,
	output reg      MemtoReg,
	output reg		JalrMux,
	output reg[4:0] ALUControl,
	output wire     uart_tx_send,
	//Debug Output
	output cu_fsm_state_t State_o
);

    //State
    cu_fsm_state_t State;

    assign State_o = State;

    //TODO: Do UART logic cleaner
	assign uart_tx_send = ((State === UART_TX_WAIT)) ? 1'b1 : 1'b0;

	wire uart_dummy_wait_done, uart_dummy_wait_rst;
	assign uart_dummy_wait_rst = (State === UART_DUMMY_WAIT) ? 1'b0 : 1'b1;

	Counter_Param #(
		.MAX_COUNT(10000)
	) uart_dummy_wait_counter (
		.clk(clk),
		.en(1'b1),
		.rst(uart_dummy_wait_rst),
		.max_cnt_hit(uart_dummy_wait_done)
	);
	
	//Next state Block
	always @(posedge clk, negedge rst) begin
		//Rst state is FETCH
		if(~rst) State <= FETCH;
		//Case for Current State
		else case (State)
			FETCH:
				State <= DECODE;
			DECODE:
				case (Opcode)
					`OPCODE_REG		:	State <= REG_EXE;		//R-Type
					`OPCODE_IMMI	:	State <= IMMI_EXE;		//I-Type ALU
					`OPCODE_LOAD	:	State <= MEM_ADDR;		//I-Type Load
					`OPCODE_STORE	:	State <= MEM_ADDR;		//S-Type
					`OPCODE_BRANCH	:	State <= BRANCH;		//B-Type
					`OPCODE_JAL		:	State <= JUMP;			//J-Type
					`OPCODE_JALR	:	State <= JUMP;			//I-Type jalr
					`OPCODE_LUI		:	State <= IMMI_EXE;		//U-Type lui
					`OPCODE_AUIPC	:	State <= IMMI_EXE;		//U-Type auipc
					`OPCODE_UART	:	State <= UART_TX_INIT;	//UART TX
					`OPCODE_STALL	:	State <= STALL;			//STALL
					default			:	State <= FETCH;			//INVALID
				endcase
			MEM_ADDR:
				case (Opcode)
					`OPCODE_LOAD	:	State <= MEM_READ;		//Load
					`OPCODE_STORE	:	State <= MEM_WRITE;		//Store
					default			:	State <= FETCH;			//INVALID
				endcase
			MEM_READ:
				State <= MEM_WRBACK;
			MEM_WRBACK:
				State <= FETCH;
			MEM_WRITE:
				State <= FETCH;
			REG_EXE:
				State <= REG_WRBACK;
			REG_WRBACK:
				State <= FETCH;
			BRANCH:
				State <= FETCH;
			IMMI_EXE:
				State <= IMMI_WRBACK;
			IMMI_WRBACK:
				State <= FETCH;
			JUMP:
				State <= FETCH;
			UART_TX_INIT:
				State <= UART_DUMMY_WAIT;
			UART_DUMMY_WAIT:
				State <= (uart_dummy_wait_done === 1'b1) ? UART_TX_WAIT : UART_DUMMY_WAIT;
			UART_TX_WAIT:
				State <= (tx_fsm_in_STOP_S === 1'b1) ? FETCH : UART_TX_WAIT;
			STALL:
				State <= STALL;
			default:
				State <= FETCH;
		endcase
	end
	
	//Outputs Block
	always @(State) begin
		//State Case
		case (State)
			FETCH: begin
				MemWrite	= 1'b0;
				MemRead		= 1'b1;		//Read from Memory Map
				IRWrite		= 1'b1;		//Write to Instruction Register
				RegWrite	= 1'b0;
				PCWrite		= 1'b1;		//Update PC
				IorD		= 1'b0;
				Branch		= 1'b0;
				XorZero		= 1'b0;
				SignExt		= 3'b000;
				ShiftAmnt	= 2'b00;
				JalrMux		= 1'b0;
				ALUSrcA		= 2'b00;	//PC is source A
				ALUSrcB		= 2'b01;	//4 is source B
				MemtoReg	= 1'b0;
				PCSrc		= 1'b0;		//ALU output is next PC
				ALUControl	= `SEL_ADD;	//Select ADD operation
			end
			DECODE: begin
				MemWrite	= 1'b0;
				MemRead		= 1'b0;
				IRWrite		= 1'b0;
				case (Opcode)
					`OPCODE_JAL: begin
						RegWrite	= 1'b1;			//Save next instruction on rd
						ALUSrcA		= 2'b11;		//Not incremented PC is source a
						SignExt		= `EXT_JAL;		//Extend from 30 bits
						JalrMux		= 1'b0;			//rs1 is not used
					end
					`OPCODE_JALR: begin
						RegWrite	= 1'b1;			//Save next instruction on rd
						ALUSrcA		= 2'b01;		//rs1 is source a
						SignExt		= `EXT_JALR;	//Extend from 12 bits I-type
						JalrMux		= 1'b1;			//Non flopped version of rs1
					end
					default: begin
						RegWrite	= 1'b0;			//No write on Reg File
						ALUSrcA		= 2'b11;		//Not incremented PC is source a
						SignExt		= `EXT_BRA;		//Extend from 12 bits B-type
						JalrMux		= 1'b0;			//rs1 is not used
					end
				endcase
				PCWrite		= 1'b0;
				IorD		= 1'b0;
				Branch		= 1'b0;	
				XorZero		= 1'b0;
				ShiftAmnt	= `SHIFT_1;	//Shift immidiate 1 bit		//REVIEW IF JALR HAS 0 SHIFT
				ALUSrcB		= 2'b10;	//Immidiate is source b
				MemtoReg	= 1'b0;
				PCSrc		= 1'b0;
				ALUControl	= `SEL_ADD;	//Select ADD operation
			end
			MEM_ADDR: begin
				MemWrite	= 1'b0;
				MemRead		= 1'b0;
				IRWrite		= 1'b0;
				RegWrite	= 1'b0;
				PCWrite		= 1'b0;
				IorD		= 1'b0;
				Branch		= 1'b0;
				XorZero		= 1'b0;
				case (Opcode)
					`OPCODE_LOAD:
						SignExt	= `EXT_LOAD;	//Extend from Load format
					`OPCODE_STORE:
						SignExt	= `EXT_STORE;	//Extend from Store format
					default:
						SignExt	= `EXT_LOAD;	//INVALID
				endcase
				ShiftAmnt	= `SHIFT_0;	//No Shift required
				JalrMux		= 1'b0;
				ALUSrcA		= 2'b01;	//rs1 is source a
				ALUSrcB		= 2'b10;	//Immidiate is source b
				MemtoReg	= 1'b0;
				PCSrc		= 1'b0;
				ALUControl	= `SEL_ADD;	//Select ADD operation
			end
			MEM_READ: begin
				MemWrite	= 1'b0;
				MemRead		= 1'b1;		//Read from Memory Map
				IRWrite		= 1'b0;
				RegWrite	= 1'b0;
				PCWrite		= 1'b0;
				IorD		= 1'b1;		//Get memory address
				Branch		= 1'b0;
				XorZero		= 1'b0;
				SignExt		= 3'b000;
				ShiftAmnt	= 2'b00;
				JalrMux		= 1'b0;
				ALUSrcA		= 2'b00;
				ALUSrcB		= 2'b00;
				MemtoReg	= 1'b0;
				PCSrc		= 1'b0;
				ALUControl	= 5'b00000;
			end
			MEM_WRBACK: begin
				MemWrite	= 1'b0;
				MemRead		= 1'b0;
				IRWrite		= 1'b0;
				RegWrite	= 1'b1;		//Write to rd
				PCWrite		= 1'b0;
				IorD		= 1'b0;
				Branch		= 1'b0;
				XorZero		= 1'b0;
				SignExt		= 3'b000;
				ShiftAmnt	= 2'b00;
				JalrMux		= 1'b0;
				ALUSrcA		= 2'b00;
				ALUSrcB		= 2'b00;
				MemtoReg	= 1'b1;		//Value to write comes from Memory
				PCSrc		= 1'b0;
				ALUControl	= 5'b00000;
			end
			MEM_WRITE: begin
				MemWrite	= 1'b1;		//Write to Memory Map
				MemRead		= 1'b0;
				IRWrite		= 1'b0;
				RegWrite	= 1'b0;
				PCWrite		= 1'b0;
				IorD		= 1'b1;		//Get memory address
				Branch		= 1'b0;
				XorZero		= 1'b0;
				SignExt		= 3'b000;
				ShiftAmnt	= 2'b00;
				JalrMux		= 1'b0;
				ALUSrcA		= 2'b00;
				ALUSrcB		= 2'b00;
				MemtoReg	= 1'b0;
				PCSrc		= 1'b0;
				ALUControl	= 5'b00000;
			end
			REG_EXE: begin
				MemWrite	= 1'b0;
				MemRead		= 1'b0;
				IRWrite		= 1'b0;
				RegWrite	= 1'b0;
				PCWrite		= 1'b0;
				IorD		= 1'b0;
				Branch		= 1'b0;
				XorZero		= 1'b0;
				SignExt		= 3'b000;
				ShiftAmnt	= 2'b00;
				JalrMux		= 1'b0;
				ALUSrcA		= 2'b01;	//rs1 is source a
				ALUSrcB		= 2'b00;	//rs2 is source b
				MemtoReg	= 1'b0;
				PCSrc		= 1'b0;
				ALUControl	= {Funct7[5],Funct7[0],Funct3};	//Function defined by instruction
			end
			REG_WRBACK: begin
				MemWrite	= 1'b0;
				MemRead		= 1'b0;
				IRWrite		= 1'b0;
				RegWrite	= 1'b1;		//Write to rd
				PCWrite		= 1'b0;
				IorD		= 1'b0;
				Branch		= 1'b0;
				XorZero		= 1'b0;
				SignExt		= 3'b000;
				ShiftAmnt	= 2'b00;
				JalrMux		= 1'b0;
				ALUSrcA		= 2'b00;
				ALUSrcB		= 2'b00;
				MemtoReg	= 1'b0;		//Value to write comes from ALU
				PCSrc		= 1'b0;
				ALUControl	= 5'b00000;
			end
			BRANCH: begin
				MemWrite	= 1'b0;
				MemRead		= 1'b0;
				IRWrite		= 1'b0;
				RegWrite	= 1'b0;
				PCWrite		= 1'b0;
				IorD		= 1'b0;
				Branch		= 1'b1;		//If ALU is zero, Change PC
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
				SignExt		= 3'b000;
				ShiftAmnt	= 2'b00;
				JalrMux		= 1'b0;
				ALUSrcA		= 2'b01;	//rs1 is source a
				ALUSrcB		= 2'b00;	//rs2 is source b
				MemtoReg	= 1'b0;
				PCSrc		= 1'b1;		//Previous ALU Output is PC
			end
			IMMI_EXE: begin
				MemWrite	= 1'b0;
				MemRead		= 1'b0;
				IRWrite		= 1'b0;
				RegWrite	= 1'b0;
				PCWrite		= 1'b0;
				IorD		= 1'b0;
				Branch		= 1'b0;
				XorZero		= 1'b0;
				JalrMux		= 1'b0;
				case (Opcode)
					`OPCODE_LUI: begin
						ShiftAmnt	= `SHIFT_C;		//Shif 12 bits for U instruction
						ALUControl	= `SEL_ADD;		//Select ADD operation
						ALUSrcA		= 2'b10;		//0x0 is source a
						ALUSrcB		= 2'b10;		//Immidiate is source b
						SignExt		= `EXT_UPPER;	//Extend from U-type
					end
					`OPCODE_AUIPC: begin
						ShiftAmnt	= `SHIFT_C;		//Shif 12 bits for U instruction
						ALUControl	= `SEL_ADD;		//Select ADD operation
						ALUSrcA		= 2'b11;		//Not incremented PC is source a
						ALUSrcB		= 2'b10;		//Immidiate is source b
						SignExt		= `EXT_UPPER;	//Extend from U-type
					end
					default: begin
						ShiftAmnt	= `SHIFT_0;		//No Shift for I instructions
						ALUSrcA		= 2'b01;		//rs1 is source a
						SignExt		= `EXT_IMMI;	//Extend from I-type
						case (Funct3)
							`FUNCT_SHIFT_LEFT : begin
								ALUSrcB		= 2'b11;						//Immidiate[4:0] is source b
								ALUControl	= {Funct7[5],Funct7[0],Funct3};	//Function defined by instruction, Immi defines srl or sra
							end
							`FUNCT_SHIFT_RIGHT : begin
								ALUSrcB		= 2'b11;						//Immidiate[4:0] is source b
								ALUControl	= {Funct7[5],Funct7[0],Funct3};	//Function defined by instruction, Immi defines srl or sra
							end
							default	 : begin
								ALUSrcB		= 2'b10;						//Immidiate is source b
								ALUControl	= {2'b00,Funct3};				//Function defined by instruction, no SUB no MUL
							end
						endcase
					end
				endcase
				MemtoReg	= 1'b0;
				PCSrc		= 1'b0;
			end
			IMMI_WRBACK: begin
				MemWrite	= 1'b0;
				MemRead		= 1'b0;
				IRWrite		= 1'b0;
				RegWrite	= 1'b1;		//Write to rd
				PCWrite		= 1'b0;
				IorD		= 1'b0;
				Branch		= 1'b0;
				XorZero		= 1'b0;
				SignExt		= 3'b000;
				ShiftAmnt	= 2'b00;
				JalrMux		= 1'b0;
				ALUSrcA		= 2'b00;
				ALUSrcB		= 2'b00;
				MemtoReg	= 1'b0;		//Value to write comes from ALU
				PCSrc		= 1'b0;
				ALUControl	= 5'b00000;
			end
			JUMP: begin
				MemWrite	= 1'b0;
				MemRead		= 1'b0;
				IRWrite		= 1'b0;
				RegWrite	= 1'b0;
				PCWrite		= 1'b1;		//Update PC
				IorD		= 1'b0;
				Branch		= 1'b0;
				XorZero		= 1'b0;
				SignExt		= 3'b000;
				ShiftAmnt	= 2'b00;
				JalrMux		= 1'b0;
				ALUSrcA		= 2'b00;
				ALUSrcB		= 2'b00;
				MemtoReg	= 1'b0;
				PCSrc		= 1'b1;		//Previous ALU Output is PC
				ALUControl	= 5'b00000;
			end
			UART_TX_INIT: begin
				MemWrite	= 1'b0;
				MemRead		= 1'b0;
				IRWrite		= 1'b0;
				RegWrite	= 1'b0;
				PCWrite		= 1'b0;
				IorD		= 1'b0;
				Branch		= 1'b0;
				XorZero		= 1'b0;
				SignExt		= 3'b000;
				ShiftAmnt	= 2'b00;
				JalrMux		= 1'b0;
				ALUSrcA		= 2'b00;
				ALUSrcB		= 2'b00;
				MemtoReg	= 1'b0;
				PCSrc		= 1'b0;
				ALUControl	= 5'b00000;
			end
			default: begin
				MemWrite	= 1'b0;
				MemRead		= 1'b0;
				IRWrite		= 1'b0;
				RegWrite	= 1'b0;
				PCWrite		= 1'b0;
				IorD		= 1'b0;
				Branch		= 1'b0;
				XorZero		= 1'b0;
				SignExt		= 3'b000;
				ShiftAmnt	= 2'b00;
				JalrMux		= 1'b0;
				ALUSrcA		= 2'b00;
				ALUSrcB		= 2'b00;
				MemtoReg	= 1'b0;
				PCSrc		= 1'b0;
				ALUControl	= 5'b00000;
			end
		endcase
	end

endmodule