//////////////////////////////////////////////////////////////////////////////////
// Company: ITESO
// Engineer: Jorge Alberto Padilla Gutierrez
// Module Description: RISC-V Pipelined Core
//////////////////////////////////////////////////////////////////////////////////

import Control_Unit_enum::*;

module RISC_V_Core #(parameter DATA_WIDTH = 32, parameter ADDR_WIDTH = 32) (
	//Inputs
	input wire              clk, 
	input wire              rst,
	input [DATA_WIDTH-1:0]  InstrData,
	input [DATA_WIDTH-1:0]  MemData,
	//Outputs
	output wire             MemRead, 
	output wire             MemWrite,
	output [DATA_WIDTH-1:0] WriteData,
	output [DATA_WIDTH-1:0] RWAddress,
	output [DATA_WIDTH-1:0] PC
);

	//Signals required for connections
	//Fetch
	wire					F_PCEn;
	wire [DATA_WIDTH-1:0]   F_PCp;
	wire [DATA_WIDTH-1:0]   F_PCp4;
	//Decode
	wire					D_PCEn;
	wire					D_PCWrite;
	wire					D_RegEn;
	wire					D_Stall;
	wire					D_MemWrite;
	wire					D_MemWrite_H;
	wire					D_MemRead;
	wire					D_MemRead_H;
	wire                    D_RegWrite;
	wire                    D_RegWrite_H;
	wire                    D_RegMul;
	wire                    D_RegMul_H;
	wire                    D_Jump;
	wire                    D_Jump_H;
	wire                    D_Branch;
	wire                    D_Branch_H;
	wire                    D_XorZero;
	wire                    D_XorZero_H;
	wire                    D_MemtoReg;
	wire                    D_MemtoReg_H;
	wire                    D_JalrMux;
	wire                    D_JalrMux_H;
	wire [1:0]              D_ALUSrcA;
	wire [1:0]              D_ALUSrcA_H;
	wire [1:0]              D_ALUSrcB;
	wire [1:0]              D_ALUSrcB_H;
	wire [1:0]              D_ShiftAmnt;
	wire [1:0]              D_ShiftAmnt_H;
	wire [2:0]              D_SignExt;
	wire [2:0]              D_SignExt_H;
	wire [4:0]              D_ALUControl;
	wire [4:0]              D_ALUControl_H;
	wire [DATA_WIDTH-1:0]   D_PC;
	wire [DATA_WIDTH-1:0]   D_InstrData;
	wire [DATA_WIDTH-1:0]   D_RD1;
	wire [DATA_WIDTH-1:0]   D_RD2;
	wire [DATA_WIDTH-1:0]	D_WD;
    
    /// FIXME Branch wires
    wire                    D_B_SignExt;
    wire [11:0]             D_B_Data;
    wire [DATA_WIDTH-1:0]   D_B_Data_SE;
    wire [DATA_WIDTH-1:0]   D_B_ShiftImm;
    wire [DATA_WIDTH-1:0]   D_B_PCj;
    wire [DATA_WIDTH-1:0]   D_B_PCbra;


	//Execute
	wire					E_MemWrite;
	wire					E_MemWrite_H;
	wire					E_MemRead;
	wire					E_MemRead_H;
	wire					E_RegWrite;
	wire					E_RegWrite_H;
	wire					E_RegMul;
	wire                    E_Jump;
	wire                    E_Jump_H;
	wire                    E_Branch;
	wire                    E_Branch_H;
	wire                    E_XorZero;
	wire                    E_XorZero_H;
	wire                    E_MemtoReg;
	wire                    E_MemtoReg_H;
	wire                    E_JalrMux;
	wire                    E_Zero;
	wire [1:0]              E_AForward;
	wire [1:0]              E_BForward;
	wire [1:0]              E_ALUSrcA;
	wire [1:0]              E_ALUSrcB;
	wire [1:0]              E_ShiftAmnt;
	wire [2:0]              E_SignExt;
	wire [4:0]              E_ALUControl;
	wire [DATA_WIDTH-1:0]   E_PC;
	wire [DATA_WIDTH-1:0]   E_InstrData;
	wire [DATA_WIDTH-1:0]   E_RD1;
	wire [DATA_WIDTH-1:0]   E_RD2;
	wire [DATA_WIDTH-1:0]   E_SignImm;
	wire [DATA_WIDTH-1:0]   E_ShiftImm;
	wire [DATA_WIDTH-1:0]   E_PCj;
	wire [DATA_WIDTH-1:0]   E_PCbra;
	wire [DATA_WIDTH-1:0]   E_RegA;
	wire [DATA_WIDTH-1:0]   E_RegB;
	wire [DATA_WIDTH-1:0]   E_SrcA;
	wire [DATA_WIDTH-1:0]   E_SrcB;
	wire [DATA_WIDTH-1:0]   E_ALUOut;
	//Product
	wire [4:0]				P1_Rs1;
	wire [4:0]				P1_Rs2;
	wire [4:0]				P1_Rd;
	wire					P1_RegMul;
	wire [4:0]				P2_Rs1;
	wire [4:0]				P2_Rs2;
	wire [4:0]				P2_Rd;
	wire					P2_RegMul;
	wire [4:0]				P3_Rs1;
	wire [4:0]				P3_Rs2;
	wire [4:0]				P3_Rd;
	wire					P3_RegMul;
	//Memory
	wire					M_RegWrite;
	wire                    M_Jump;
	wire                    M_Branch;
	wire                    M_XorZero;
	wire                    M_MemtoReg;
	wire                    M_Zero;
	wire                    M_PCSrc;
	wire [DATA_WIDTH-1:0]   M_InstrData;
	wire [DATA_WIDTH-1:0]   M_PCbra;
	//Writeback
	wire					W_RegWrite;
	wire					W_RegMul;
	wire                    W_MemtoReg;
	wire [4:0]				W_Rs1;
	wire [4:0]				W_Rs2;
	wire [4:0]				W_Rd;
	wire [DATA_WIDTH-1:0]	W_MemData;
	wire [DATA_WIDTH-1:0]   W_ALUOut;
	wire [DATA_WIDTH-1:0]   W_MULOut;
	wire [DATA_WIDTH-1:0]   W_InstrData;
	wire [DATA_WIDTH-1:0]   W_WD3;

	
	//Instance of Modules

	/*
		FETCH STAGE
	*/

	//Program Counter Register
	Reg_PC #(.DATA_WIDTH(DATA_WIDTH)) PCREG (
		.rst(rst),
		.clk(clk),
		.en(F_PCEn | M_PCSrc),
		.D(F_PCp),
		.Q(PC)
	);

	//PC Enable logic for stalls
	PC_Enable PCEN(
		.D_PCEn(D_PCEn),
		.D_PCWrite(D_PCWrite),
		.F_PCEn(F_PCEn)
	);

	//PC+4 Adder
	Adder #(.DATA_WIDTH(DATA_WIDTH)) PCP4 (
		.a(PC),
		.b(32'h4),
		.f(F_PCp4)
	);
	
    //Mux for next PC
	Mux_2_1 #(.DATA_WIDTH(DATA_WIDTH)) PCOUTMUX (
		.A(F_PCp4),
		.B(M_PCbra), // FIXME new wire for Branch in decode: D_B_PCbra
		.sel(M_PCSrc),
		.Q(F_PCp)
	);

	/*
		FETCH/DECODE FFs
	*/

	//PC F/D
	Reg_Neg_Param #(.DATA_WIDTH(DATA_WIDTH)) F_D_PC(
		.rst(rst),
		.clk(clk),
		.en(D_RegEn | M_PCSrc),
		.D(PC),
		.Q(D_PC)
	);

	//InstrData F/D
	Reg_Neg_Param #(.DATA_WIDTH(DATA_WIDTH)) F_D_INSTRDATA(
		.rst(rst),
		.clk(clk),
		.en(D_RegEn | M_PCSrc),
		.D(InstrData),
		.Q(D_InstrData)
	);

	/*
		DECODE STAGE
	*/

    //Contrl Unit
	Control_Unit CU(
        .clk(clk),
        .rst(rst),
        .Opcode(D_InstrData[6:0]),
        .Funct7(D_InstrData[31:25]),
        .Funct3(D_InstrData[14:12]),
        .ALUSrcA(D_ALUSrcA),
        .ALUSrcB(D_ALUSrcB),
        .ShiftAmnt(D_ShiftAmnt),
        .SignExt(D_SignExt),
        .PCEn(D_PCEn),
        .MemWrite(D_MemWrite), 
        .MemRead(D_MemRead),
        .RegWrite(D_RegWrite),
        .RegMul(D_RegMul),
        .Jump(D_Jump),
        .Branch(D_Branch),
        .XorZero(D_XorZero),
        .MemtoReg(D_MemtoReg),
        .JalrMux(D_JalrMux),
        .ALUControl(D_ALUControl)
    );
	
	//Mux for Multiplier Address
	Mux_2_1 #(.DATA_WIDTH(DATA_WIDTH)) MUXMUL (
		.A(W_InstrData[11:7]),
		.B(W_Rd),
		.sel(W_RegMul),
		.Q(D_WD)
	);

    //Register File
	Reg_File #(.ADDRESS_WIDTH(5), .DATA_WIDTH(DATA_WIDTH)) REGFILE (
		.clk(clk),
		.rst(rst),
		.we3(W_RegWrite | W_RegMul),
		.a1(D_InstrData[19:15]),
		.a2(D_InstrData[24:20]),
		.a3(D_WD),
		.wd3(W_WD3),
		.rd1(D_RD1),
		.rd2(D_RD2)
	);

	//Hazard Detection Unit
	Hazard_Detection_Unit #(.DATA_WIDTH(5)) HDU (
		.Rs1(D_InstrData[19:15]),
		.Rs2(D_InstrData[24:20]),
		.Rd(D_InstrData[11:7]),
		.E_Rd(E_InstrData[11:7]),
		.P1_Rd(P1_Rd),
		.P2_Rd(P2_Rd),
		.RegWrite(D_RegWrite),
		.E_MemRead(E_MemRead),
		.P0_RegMul(E_RegMul),
		.P1_RegMul(P1_RegMul),
		.P2_RegMul(P2_RegMul),
		.PCWrite(D_PCWrite),
		.IDWrite(D_RegEn),
		.Stall(D_Stall)
	);

    // FIXME BEGIN
    // B INSTR IN DECODE
    // Compare Rt == Rs regs
    Comparator #(.DATA_WIDTH(DATA_WIDTH)) CMP_D (
    	.a(D_RD1),
    	.b(D_RD2),
    	.f(D_B_SignExt)
    );

    // Moving PC + Offset adder and AND gate
    //Sign Extender + mux, give it B instruction encoding
    // Mux makes it easier to debug but it can be removed, uses CMP_D as selector
    Mux_2_1 #(.DATA_WIDTH(12)) MUX_B_D (
        .A({12{1'b0}}),
        .B({E_InstrData[31],E_InstrData[7],E_InstrData[30:25],E_InstrData[11:8]}),
        .sel(D_B_SignExt),
        .Q(D_B_Data)
    );
    Sign_Ext #(.IN_WIDTH(12), .OUT_WIDTH(DATA_WIDTH)) SE_D (
		.In(D_B_Data),
		.Out(D_B_Data_SE)
	);
    
    //Shift Unit
    // selector for B instructions has shift amt of 1
    Shift_Unit #(.DATA_WIDTH(DATA_WIDTH)) SU_D (
        .In(D_B_Data_SE),
        .sel(D_ShiftAmnt), // FIXME ???
        .Out(D_B_ShiftImm)
    );

    //PC + Offset adder for B instructions
    Adder #(.DATA_WIDTH(DATA_WIDTH)) PCBJ_D (
		.a(D_PC),
		.b(D_B_ShiftImm),
		.f(D_B_PCbra) // This is the new wire for PC mux
	);
    // FIXME END

	//Muxes for Stall
	Mux_2_1 #(.DATA_WIDTH(2)) STALL_ALUSRCA (
		.A(D_ALUSrcA),
		.B(2'b00),
		.sel(D_Stall | M_PCSrc),
		.Q(D_ALUSrcA_H)
	);
	Mux_2_1 #(.DATA_WIDTH(2)) STALL_ALUSRCB (
		.A(D_ALUSrcB),
		.B(2'b00),
		.sel(D_Stall | M_PCSrc),
		.Q(D_ALUSrcB_H)
	);
	Mux_2_1 #(.DATA_WIDTH(2)) STALL_SHIFTAMNT (
		.A(D_ShiftAmnt),
		.B(2'b00),
		.sel(D_Stall | M_PCSrc),
		.Q(D_ShiftAmnt_H)
	);
	Mux_2_1 #(.DATA_WIDTH(3)) STALL_SIGNEXT (
		.A(D_SignExt),
		.B(3'b000),
		.sel(D_Stall | M_PCSrc),
		.Q(D_SignExt_H)
	);
	Mux_2_1 #(.DATA_WIDTH(1)) STALL_MEMWRITE (
		.A(D_MemWrite),
		.B(1'b0),
		.sel(D_Stall | M_PCSrc),
		.Q(D_MemWrite_H)
	);
	Mux_2_1 #(.DATA_WIDTH(1)) STALL_MEMREAD (
		.A(D_MemRead),
		.B(1'b0),
		.sel(D_Stall | M_PCSrc),
		.Q(D_MemRead_H)
	);
	Mux_2_1 #(.DATA_WIDTH(1)) STALL_REGWRITE (
		.A(D_RegWrite),
		.B(1'b0),
		.sel(D_Stall | M_PCSrc),
		.Q(D_RegWrite_H)
	);
	Mux_2_1 #(.DATA_WIDTH(1)) STALL_REGMUL (
		.A(D_RegMul),
		.B(1'b0),
		.sel(D_Stall | M_PCSrc),
		.Q(D_RegMul_H)
	);
	Mux_2_1 #(.DATA_WIDTH(1)) STALL_JUMP (
		.A(D_Jump),
		.B(1'b0),
		.sel(D_Stall | M_PCSrc),
		.Q(D_Jump_H)
	);
	Mux_2_1 #(.DATA_WIDTH(1)) STALL_BRANCH (
		.A(D_Branch),
		.B(1'b0),
		.sel(D_Stall | M_PCSrc),
		.Q(D_Branch_H)
	);
	Mux_2_1 #(.DATA_WIDTH(1)) STALL_XORZERO (
		.A(D_XorZero),
		.B(1'b0),
		.sel(D_Stall | M_PCSrc),
		.Q(D_XorZero_H)
	);
	Mux_2_1 #(.DATA_WIDTH(1)) STALL_MEMTOREG (
		.A(D_MemtoReg),
		.B(1'b0),
		.sel(D_Stall | M_PCSrc),
		.Q(D_MemtoReg_H)
	);
	Mux_2_1 #(.DATA_WIDTH(1)) STALL_JALRMUX (
		.A(D_JalrMux),
		.B(1'b0),
		.sel(D_Stall | M_PCSrc),
		.Q(D_JalrMux_H)
	);
	Mux_2_1 #(.DATA_WIDTH(5)) STALL_ALUCONTROL (
		.A(D_ALUControl),
		.B(5'b00000),
		.sel(D_Stall | M_PCSrc),
		.Q(D_ALUControl_H)
	);

	/*
		DECODE/EXECUTE FFs
	*/

	//PC D/E
	Reg_Neg_Param #(.DATA_WIDTH(DATA_WIDTH)) D_E_PC(
		.rst(rst),
		.clk(clk),
		.en(1'b1),
		.D(D_PC),
		.Q(E_PC)
	);

	//RD1 D/E
	Reg_Neg_Param #(.DATA_WIDTH(DATA_WIDTH)) D_E_RD1(
		.rst(rst),
		.clk(clk),
		.en(1'b1),
		.D(D_RD1),
		.Q(E_RD1)
	);

	//RD2 D/E
	Reg_Neg_Param #(.DATA_WIDTH(DATA_WIDTH)) D_E_RD2(
		.rst(rst),
		.clk(clk),
		.en(1'b1),
		.D(D_RD2),
		.Q(E_RD2)
	);

	//InstrData D/E
	Reg_Neg_Param #(.DATA_WIDTH(DATA_WIDTH)) D_E_INSTRDATA(
		.rst(rst),
		.clk(clk),
		.en(1'b1),
		.D(D_InstrData),
		.Q(E_InstrData)
	);

	//Control Unit Signals D/E
	Reg_Neg_Param #(.DATA_WIDTH(2)) D_E_ALUSRCA(
		.rst(rst),
		.clk(clk),
		.en(1'b1),
		.D(D_ALUSrcA_H),
		.Q(E_ALUSrcA)
	);
	Reg_Neg_Param #(.DATA_WIDTH(2)) D_E_ALUSRCB(
		.rst(rst),
		.clk(clk),
		.en(1'b1),
		.D(D_ALUSrcB_H),
		.Q(E_ALUSrcB)
	);
	Reg_Neg_Param #(.DATA_WIDTH(2)) D_E_SHIFTAMNT(
		.rst(rst),
		.clk(clk),
		.en(1'b1),
		.D(D_ShiftAmnt_H),
		.Q(E_ShiftAmnt)
	);
	Reg_Neg_Param #(.DATA_WIDTH(3)) D_E_SIGNEXT(
		.rst(rst),
		.clk(clk),
		.en(1'b1),
		.D(D_SignExt_H),
		.Q(E_SignExt)
	);
	Reg_Neg_Param #(.DATA_WIDTH(1)) D_E_MEMWRITE(
		.rst(rst),
		.clk(clk),
		.en(1'b1),
		.D(D_MemWrite_H),
		.Q(E_MemWrite)
	);
	Reg_Neg_Param #(.DATA_WIDTH(1)) D_E_MEMREAD(
		.rst(rst),
		.clk(clk),
		.en(1'b1),
		.D(D_MemRead_H),
		.Q(E_MemRead)
	);
	Reg_Neg_Param #(.DATA_WIDTH(1)) D_E_REGWRITE(
		.rst(rst),
		.clk(clk),
		.en(1'b1),
		.D(D_RegWrite_H),
		.Q(E_RegWrite)
	);
	Reg_Neg_Param #(.DATA_WIDTH(1)) D_E_REGMUL(
		.rst(rst),
		.clk(clk),
		.en(1'b1),
		.D(D_RegMul_H),
		.Q(E_RegMul)
	);
	Reg_Neg_Param #(.DATA_WIDTH(1)) D_E_JUMP(
		.rst(rst),
		.clk(clk),
		.en(1'b1),
		.D(D_Jump_H),
		.Q(E_Jump)
	);
	Reg_Neg_Param #(.DATA_WIDTH(1)) D_E_BRANCH(
		.rst(rst),
		.clk(clk),
		.en(1'b1),
		.D(D_Branch_H),
		.Q(E_Branch)
	);
	Reg_Neg_Param #(.DATA_WIDTH(1)) D_E_XORZERO(
		.rst(rst),
		.clk(clk),
		.en(1'b1),
		.D(D_XorZero_H),
		.Q(E_XorZero)
	);
	Reg_Neg_Param #(.DATA_WIDTH(1)) D_E_MEMTOREG(
		.rst(rst),
		.clk(clk),
		.en(1'b1),
		.D(D_MemtoReg_H),
		.Q(E_MemtoReg)
	);
	Reg_Neg_Param #(.DATA_WIDTH(1)) D_E_JALRMUX(
		.rst(rst),
		.clk(clk),
		.en(1'b1),
		.D(D_JalrMux_H),
		.Q(E_JalrMux)
	);
	Reg_Neg_Param #(.DATA_WIDTH(5)) D_E_ALUCONTROL(
		.rst(rst),
		.clk(clk),
		.en(1'b1),
		.D(D_ALUControl_H),
		.Q(E_ALUControl)
	);
	
	/*
		EXECUTE STAGE
	*/
    
    //Sign Extender Unit
    Sign_Ext_Unit #(.IN_WIDTH_1(12), .IN_WIDTH_2(20), .OUT_WIDTH(DATA_WIDTH)) SEU (
        .In_12_I(E_InstrData[31:20]),
        .In_12_S({E_InstrData[31:25],E_InstrData[11:7]}),
        .In_12_B({E_InstrData[31],E_InstrData[7],E_InstrData[30:25],E_InstrData[11:8]}),
        .In_20_U(E_InstrData[31:12]),
        .In_20_J({E_InstrData[31],E_InstrData[19:12],E_InstrData[20],E_InstrData[30:21]}),
        .sel(E_SignExt),
        .Out(E_SignImm)
    );
    
    //Shift Unit
    Shift_Unit #(.DATA_WIDTH(DATA_WIDTH)) SU (
        .In(E_SignImm),
        .sel(E_ShiftAmnt),
        .Out(E_ShiftImm)
    );

	//Forwarding Unit
	Forwarding_Unit #(.DATA_WIDTH(5)) FU (
		.Rs1(E_InstrData[19:15]),
		.Rs2(E_InstrData[24:20]),
		.M_Rd(M_InstrData[11:7]),
		.W_Rd(W_InstrData[11:7]),
		.W_Rd_Mul(W_Rd),
		.M_RegWrite(M_RegWrite),
		.W_RegWrite(W_RegWrite),
		.W_RegMul(W_RegMul),
		.AForward(E_AForward),
		.BForward(E_BForward)
	);
	
	//Mux for jal and jalr source
	Mux_2_1 #(.DATA_WIDTH(DATA_WIDTH)) JALRMUX (
		.A(E_PC),
		.B(E_RD1),
		.sel(E_JalrMux),
		.Q(E_PCj)
	);

	//Branch and Jump Adder
	Adder #(.DATA_WIDTH(DATA_WIDTH)) PCBJ (
		.a(E_PCj),
		.b(E_ShiftImm),
		.f(E_PCbra)
	);

	//Mux for Forwarding A input
	Mux_4_1 #(.DATA_WIDTH(DATA_WIDTH)) AFW (
		.A(E_RD1),
		.B(RWAddress),
		.C(W_WD3),
		.D(32'h0),
		.sel(E_AForward),
		.Q(E_RegA)
	);
	
    //Mux for Forwarding B input
	Mux_4_1 #(.DATA_WIDTH(DATA_WIDTH)) BFW (
		.A(E_RD2),
		.B(RWAddress),
		.C(W_WD3),
		.D(32'h0),
		.sel(E_BForward),
		.Q(E_RegB)
	);
	
    //Mux for ALU A input
	Mux_4_1 #(.DATA_WIDTH(DATA_WIDTH)) AMUX (
		.A(E_PC),
		.B(E_RegA),
		.C(32'h0),
		.D(32'h0),
		.sel(E_ALUSrcA),
		.Q(E_SrcA)
	);
	
    //Mux for ALU B input
	Mux_4_1 #(.DATA_WIDTH(DATA_WIDTH)) BMUX (
		.A(E_RegB),
		.B(32'h4),
		.C(E_ShiftImm),
		.D({27'h0,E_ShiftImm[4:0]}),
		.sel(E_ALUSrcB),
		.Q(E_SrcB)
	);
	
    //ALU for RV32I
	ALU ALURISCV(
		.a(E_SrcA),
		.b(E_SrcB),
		.sel(E_ALUControl),
		.f(E_ALUOut),
		.z(E_Zero)
	);

	//MUL for RV32I
	ALU_Mul MULRISCV(
		.a(E_SrcA),
		.b(E_SrcB),
		.sel(E_ALUControl),
		.clk(clk),
		.rst(rst),
		.Rs1(E_InstrData[19:15]),
		.Rs2(E_InstrData[24:20]),
		.Rd(E_InstrData[11:7]),
		.f(W_MULOut),
		.Rs1_1(P1_Rs1),
		.Rs2_1(P1_Rs2),
		.Rd_1(P1_Rd),
		.regmul_1(P1_RegMul),
		.Rs1_2(P2_Rs1),
		.Rs2_2(P2_Rs2),
		.Rd_2(P2_Rd),
		.regmul_2(P2_RegMul),
		.Rs1_3(P3_Rs1),
		.Rs2_3(P3_Rs2),
		.Rd_3(P3_Rd),
		.regmul_3(P3_RegMul),
		.Rs1_Out(W_Rs1),
		.Rs2_Out(W_Rs2),
		.Rd_Out(W_Rd),
		.regmul_Out(W_RegMul)
	);

	//Muxes for Nop
	Mux_2_1 #(.DATA_WIDTH(1)) NOP_MEMWRITE (
		.A(E_MemWrite),
		.B(1'b0),
		.sel(M_PCSrc),
		.Q(E_MemWrite_H)
	);
	Mux_2_1 #(.DATA_WIDTH(1)) NOP_MEMREAD (
		.A(E_MemRead),
		.B(1'b0),
		.sel(M_PCSrc),
		.Q(E_MemRead_H)
	);
	Mux_2_1 #(.DATA_WIDTH(1)) NOP_REGWRITE (
		.A(E_RegWrite),
		.B(1'b0),
		.sel(M_PCSrc),
		.Q(E_RegWrite_H)
	);
	Mux_2_1 #(.DATA_WIDTH(1)) NOP_JUMP (
		.A(E_Jump),
		.B(1'b0),
		.sel(M_PCSrc),
		.Q(E_Jump_H)
	);
	Mux_2_1 #(.DATA_WIDTH(1)) NOP_BRANCH (
		.A(E_Branch),
		.B(1'b0),
		.sel(M_PCSrc),
		.Q(E_Branch_H)
	);
	Mux_2_1 #(.DATA_WIDTH(1)) NOP_XORZERO (
		.A(E_XorZero),
		.B(1'b0),
		.sel(M_PCSrc),
		.Q(E_XorZero_H)
	);
	Mux_2_1 #(.DATA_WIDTH(1)) NOP_MEMTOREG (
		.A(E_MemtoReg),
		.B(1'b0),
		.sel(M_PCSrc),
		.Q(E_MemtoReg_H)
	);

	/*
		EXECUTE/MEMORY FFs
	*/

	//PCBra E/M
	Reg_Neg_Param #(.DATA_WIDTH(DATA_WIDTH)) E_M_PCBRA(
		.rst(rst),
		.clk(clk),
		.en(1'b1),
		.D(E_PCbra),
		.Q(M_PCbra)
	);

	//ALUOut E/M
	Reg_Neg_Param #(.DATA_WIDTH(DATA_WIDTH)) E_M_ALUOUT(
		.rst(rst),
		.clk(clk),
		.en(1'b1),
		.D(E_ALUOut),
		.Q(RWAddress)
	);

	//Zero E/M
	Reg_Neg_Param #(.DATA_WIDTH(1)) E_M_ZERO(
		.rst(rst),
		.clk(clk),
		.en(1'b1),
		.D(E_Zero),
		.Q(M_Zero)
	);

	//RD2 E/M
	Reg_Neg_Param #(.DATA_WIDTH(DATA_WIDTH)) E_M_RD2(
		.rst(rst),
		.clk(clk),
		.en(1'b1),
		.D(E_RegB),
		.Q(WriteData)
	);
	
	//InstrData E/M
	Reg_Neg_Param #(.DATA_WIDTH(DATA_WIDTH)) E_M_INSTRDATA(
		.rst(rst),
		.clk(clk),
		.en(1'b1),
		.D(E_InstrData),
		.Q(M_InstrData)
	);

	//Control Unit Signals E/M
	Reg_Neg_Param #(.DATA_WIDTH(1)) E_M_MEMWRITE(
		.rst(rst),
		.clk(clk),
		.en(1'b1),
		.D(E_MemWrite_H),
		.Q(MemWrite)
	);
	Reg_Neg_Param #(.DATA_WIDTH(1)) E_M_MEMREAD(
		.rst(rst),
		.clk(clk),
		.en(1'b1),
		.D(E_MemRead_H),
		.Q(MemRead)
	);
	Reg_Neg_Param #(.DATA_WIDTH(1)) E_M_REGWRITE(
		.rst(rst),
		.clk(clk),
		.en(1'b1),
		.D(E_RegWrite_H),
		.Q(M_RegWrite)
	);
	Reg_Neg_Param #(.DATA_WIDTH(1)) E_M_JUMP(
		.rst(rst),
		.clk(clk),
		.en(1'b1),
		.D(E_Jump_H),
		.Q(M_Jump)
	);
	Reg_Neg_Param #(.DATA_WIDTH(1)) E_M_BRANCH(
		.rst(rst),
		.clk(clk),
		.en(1'b1),
		.D(E_Branch_H),
		.Q(M_Branch)
	);
	Reg_Neg_Param #(.DATA_WIDTH(1)) E_M_XORZERO(
		.rst(rst),
		.clk(clk),
		.en(1'b1),
		.D(E_XorZero_H),
		.Q(M_XorZero)
	);
	Reg_Neg_Param #(.DATA_WIDTH(1)) E_M_MEMTOREG(
		.rst(rst),
		.clk(clk),
		.en(1'b1),
		.D(E_MemtoReg_H),
		.Q(M_MemtoReg)
	);

	/*
		MEMORY STAGE
	*/

    //PC Src Logic for Branches and Jumps
	PC_Src PCSRC(
		.PCWrite(M_Jump),
		.Branch(M_Branch),
		.Zero(M_Zero),
		.XorZero(M_XorZero),
		.PCSrc(M_PCSrc)
	);

	/*
		MEMORY/WRITEBACK FFs
	*/

	//MemData M/W
	Reg_Neg_Param #(.DATA_WIDTH(DATA_WIDTH)) M_W_MEMDATA(
		.rst(rst),
		.clk(clk),
		.en(1'b1),
		.D(MemData),
		.Q(W_MemData)
	);

	//ALUOut M/W
	Reg_Neg_Param #(.DATA_WIDTH(DATA_WIDTH)) M_W_RWADDRESS(
		.rst(rst),
		.clk(clk),
		.en(1'b1),
		.D(RWAddress),
		.Q(W_ALUOut)
	);

	//InstrData M/W
	Reg_Neg_Param #(.DATA_WIDTH(DATA_WIDTH)) M_W_INSTRDATA(
		.rst(rst),
		.clk(clk),
		.en(1'b1),
		.D(M_InstrData),
		.Q(W_InstrData)
	);

	//Control Unit Signals M/W
	Reg_Neg_Param #(.DATA_WIDTH(1)) M_W_REGWRITE(
		.rst(rst),
		.clk(clk),
		.en(1'b1),
		.D(M_RegWrite),
		.Q(W_RegWrite)
	);
	Reg_Neg_Param #(.DATA_WIDTH(1)) M_W_MEMTOREG(
		.rst(rst),
		.clk(clk),
		.en(1'b1),
		.D(M_MemtoReg),
		.Q(W_MemtoReg)
	);

	/*
		WRITEBACK STAGE
	*/
	
    //Mux for WD3
	Mux_4_1 #(.DATA_WIDTH(32)) WD3MUX (
		.A(W_ALUOut),
		.B(W_MemData),
		.C(W_MULOut),
		.D({DATA_WIDTH{1'b0}}),
		.sel({W_RegMul,W_MemtoReg}),
		.Q(W_WD3)
	);
	
endmodule