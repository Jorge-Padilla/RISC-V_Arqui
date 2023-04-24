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
    wire [DATA_WIDTH-1:0]   F_PCp;
    wire [DATA_WIDTH-1:0]   F_PCp4;
	//Decode
	wire					D_PCEn;
    wire					D_MemWrite;
    wire					D_MemRead;
    wire                    D_RegWrite;
    wire                    D_Jump;
    wire                    D_Branch;
    wire                    D_XorZero;
    wire                    D_MemtoReg;
    wire                    D_JalrMux;
    wire [1:0]              D_ALUSrcA;
    wire [1:0]              D_ALUSrcB;
    wire [1:0]              D_ShiftAmnt;
    wire [2:0]              D_SignExt;
    wire [4:0]              D_ALUControl;
    wire [DATA_WIDTH-1:0]   D_PC;
    wire [DATA_WIDTH-1:0]   D_InstrData;
    wire [DATA_WIDTH-1:0]   D_RD1;
    wire [DATA_WIDTH-1:0]   D_RD2;
	//Execute
    wire					E_MemWrite;
    wire					E_MemRead;
    wire					E_RegWrite;
    wire                    E_Jump;
    wire                    E_Branch;
    wire                    E_XorZero;
    wire                    E_MemtoReg;
    wire                    E_JalrMux;
    wire                    E_Zero;
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
    wire [DATA_WIDTH-1:0]   E_SrcA;
    wire [DATA_WIDTH-1:0]   E_SrcB;
    wire [DATA_WIDTH-1:0]   E_ALUOut;
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
    wire                    W_MemtoReg;
    wire [DATA_WIDTH-1:0]	W_MemData;
    wire [DATA_WIDTH-1:0]   W_ALUOut;
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
		.en(D_PCEn),
		.D(F_PCp),
		.Q(PC)
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
		.B(M_PCbra),
		.sel(M_PCSrc),
		.Q(F_PCp)
	);

	/*
		FETCH/DECODE FFs
	*/

	//PC F/D
	Reg_Param #(.DATA_WIDTH(DATA_WIDTH)) F_D_PC(
		.rst(rst),
		.clk(~clk),
		.en(1'b1),
		.D(PC),
		.Q(D_PC)
	);

	//InstrData F/D
	Reg_Param #(.DATA_WIDTH(DATA_WIDTH)) F_D_INSTRDATA(
		.rst(rst),
		.clk(~clk),
		.en(1'b1),
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
        .Jump(D_Jump),
        .Branch(D_Branch),
        .XorZero(D_XorZero),
        .MemtoReg(D_MemtoReg),
        .JalrMux(D_JalrMux),
        .ALUControl(D_ALUControl)
    );
	
    //Register File
	Reg_File #(.ADDRESS_WIDTH(5), .DATA_WIDTH(DATA_WIDTH)) REGFILE (
		.clk(clk),
		.we3(W_RegWrite),
		.a1(D_InstrData[19:15]),
		.a2(D_InstrData[24:20]),
		.a3(W_InstrData[11:7]),
		.wd3(W_WD3),
		.rd1(D_RD1),
		.rd2(D_RD2)
	);

	/*
		DECODE/EXECUTE FFs
	*/

	//PC D/E
	Reg_Param #(.DATA_WIDTH(DATA_WIDTH)) D_E_PC(
		.rst(rst),
		.clk(~clk),
		.en(1'b1),
		.D(D_PC),
		.Q(E_PC)
	);

	//RD1 D/E
	Reg_Param #(.DATA_WIDTH(DATA_WIDTH)) D_E_RD1(
		.rst(rst),
		.clk(~clk),
		.en(1'b1),
		.D(D_RD1),
		.Q(E_RD1)
	);

	//RD2 D/E
	Reg_Param #(.DATA_WIDTH(DATA_WIDTH)) D_E_RD2(
		.rst(rst),
		.clk(~clk),
		.en(1'b1),
		.D(D_RD2),
		.Q(E_RD2)
	);

	//InstrData D/E
	Reg_Param #(.DATA_WIDTH(DATA_WIDTH)) D_E_INSTRDATA(
		.rst(rst),
		.clk(~clk),
		.en(1'b1),
		.D(D_InstrData),
		.Q(E_InstrData)
	);

	//Control Unit Signals D/E
	Reg_Param #(.DATA_WIDTH(2)) D_E_ALUSRCA(
		.rst(rst),
		.clk(~clk),
		.en(1'b1),
		.D(D_ALUSrcA),
		.Q(E_ALUSrcA)
	);
	Reg_Param #(.DATA_WIDTH(2)) D_E_ALUSRCB(
		.rst(rst),
		.clk(~clk),
		.en(1'b1),
		.D(D_ALUSrcB),
		.Q(E_ALUSrcB)
	);
	Reg_Param #(.DATA_WIDTH(2)) D_E_SHIFTAMNT(
		.rst(rst),
		.clk(~clk),
		.en(1'b1),
		.D(D_ShiftAmnt),
		.Q(E_ShiftAmnt)
	);
	Reg_Param #(.DATA_WIDTH(3)) D_E_SIGNEXT(
		.rst(rst),
		.clk(~clk),
		.en(1'b1),
		.D(D_SignExt),
		.Q(E_SignExt)
	);
	Reg_Param #(.DATA_WIDTH(1)) D_E_MEMWRITE(
		.rst(rst),
		.clk(~clk),
		.en(1'b1),
		.D(D_MemWrite),
		.Q(E_MemWrite)
	);
	Reg_Param #(.DATA_WIDTH(1)) D_E_MEMREAD(
		.rst(rst),
		.clk(~clk),
		.en(1'b1),
		.D(D_MemRead),
		.Q(E_MemRead)
	);
	Reg_Param #(.DATA_WIDTH(1)) D_E_REGWRITE(
		.rst(rst),
		.clk(~clk),
		.en(1'b1),
		.D(D_RegWrite),
		.Q(E_RegWrite)
	);
	Reg_Param #(.DATA_WIDTH(1)) D_E_JUMP(
		.rst(rst),
		.clk(~clk),
		.en(1'b1),
		.D(D_Jump),
		.Q(E_Jump)
	);
	Reg_Param #(.DATA_WIDTH(1)) D_E_BRANCH(
		.rst(rst),
		.clk(~clk),
		.en(1'b1),
		.D(D_Branch),
		.Q(E_Branch)
	);
	Reg_Param #(.DATA_WIDTH(1)) D_E_XORZERO(
		.rst(rst),
		.clk(~clk),
		.en(1'b1),
		.D(D_XorZero),
		.Q(E_XorZero)
	);
	Reg_Param #(.DATA_WIDTH(1)) D_E_MEMTOREG(
		.rst(rst),
		.clk(~clk),
		.en(1'b1),
		.D(D_MemtoReg),
		.Q(E_MemtoReg)
	);
	Reg_Param #(.DATA_WIDTH(1)) D_E_JALRMUX(
		.rst(rst),
		.clk(~clk),
		.en(1'b1),
		.D(D_JalrMux),
		.Q(E_JalrMux)
	);
	Reg_Param #(.DATA_WIDTH(5)) D_E_ALUCONTROL(
		.rst(rst),
		.clk(~clk),
		.en(1'b1),
		.D(D_ALUControl),
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
	
    //Mux for ALU A input
	Mux_4_1 #(.DATA_WIDTH(DATA_WIDTH)) AMUX (
		.A(E_PC),
		.B(E_RD1),
		.C(32'h0),
		.D(32'h0),
		.sel(E_ALUSrcA),
		.Q(E_SrcA)
	);
	
    //Mux for ALU B input
	Mux_4_1 #(.DATA_WIDTH(DATA_WIDTH)) BMUX (
		.A(E_RD2),
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

	/*
		EXECUTE/MEMORY FFs
	*/

	//PCBra E/M
	Reg_Param #(.DATA_WIDTH(DATA_WIDTH)) E_M_PCBRA(
		.rst(rst),
		.clk(~clk),
		.en(1'b1),
		.D(E_PCbra),
		.Q(M_PCbra)
	);

	//ALUOut E/M
	Reg_Param #(.DATA_WIDTH(DATA_WIDTH)) E_M_ALUOUT(
		.rst(rst),
		.clk(~clk),
		.en(1'b1),
		.D(E_ALUOut),
		.Q(RWAddress)
	);

	//Zero E/M
	Reg_Param #(.DATA_WIDTH(1)) E_M_ZERO(
		.rst(rst),
		.clk(~clk),
		.en(1'b1),
		.D(E_Zero),
		.Q(M_Zero)
	);

	//RD2 E/M
	Reg_Param #(.DATA_WIDTH(DATA_WIDTH)) E_M_RD2(
		.rst(rst),
		.clk(~clk),
		.en(1'b1),
		.D(E_RD2),
		.Q(WriteData)
	);
	
	//InstrData E/M
	Reg_Param #(.DATA_WIDTH(DATA_WIDTH)) E_M_INSTRDATA(
		.rst(rst),
		.clk(~clk),
		.en(1'b1),
		.D(E_InstrData),
		.Q(M_InstrData)
	);

	//Control Unit Signals E/M
	Reg_Param #(.DATA_WIDTH(1)) E_M_MEMWRITE(
		.rst(rst),
		.clk(~clk),
		.en(1'b1),
		.D(E_MemWrite),
		.Q(MemWrite)
	);
	Reg_Param #(.DATA_WIDTH(1)) E_M_MEMREAD(
		.rst(rst),
		.clk(~clk),
		.en(1'b1),
		.D(E_MemRead),
		.Q(MemRead)
	);
	Reg_Param #(.DATA_WIDTH(1)) E_M_REGWRITE(
		.rst(rst),
		.clk(~clk),
		.en(1'b1),
		.D(E_RegWrite),
		.Q(M_RegWrite)
	);
	Reg_Param #(.DATA_WIDTH(1)) E_M_JUMP(
		.rst(rst),
		.clk(~clk),
		.en(1'b1),
		.D(E_Jump),
		.Q(M_Jump)
	);
	Reg_Param #(.DATA_WIDTH(1)) E_M_BRANCH(
		.rst(rst),
		.clk(~clk),
		.en(1'b1),
		.D(E_Branch),
		.Q(M_Branch)
	);
	Reg_Param #(.DATA_WIDTH(1)) E_M_XORZERO(
		.rst(rst),
		.clk(~clk),
		.en(1'b1),
		.D(E_XorZero),
		.Q(M_XorZero)
	);
	Reg_Param #(.DATA_WIDTH(1)) E_M_MEMTOREG(
		.rst(rst),
		.clk(~clk),
		.en(1'b1),
		.D(E_MemtoReg),
		.Q(M_MemtoReg)
	);

	/*
		MEMORY STAGE
	*/

    //PC Enable Logic for Branches and Jumps
	PC_Enable PCE(
		.PCWrite(M_Jump),
		.Branch(M_Branch),
		.Zero(M_Zero),
		.XorZero(M_XorZero),
		.PCEn(M_PCSrc)
	);

	/*
		MEMORY/WRITEBACK FFs
	*/

	//MemData M/W
	Reg_Param #(.DATA_WIDTH(DATA_WIDTH)) M_W_MEMDATA(
		.rst(rst),
		.clk(~clk),
		.en(1'b1),
		.D(MemData),
		.Q(W_MemData)
	);

	//ALUOut M/W
	Reg_Param #(.DATA_WIDTH(DATA_WIDTH)) M_W_RWADDRESS(
		.rst(rst),
		.clk(~clk),
		.en(1'b1),
		.D(RWAddress),
		.Q(W_ALUOut)
	);

	//InstrData M/W
	Reg_Param #(.DATA_WIDTH(DATA_WIDTH)) M_W_INSTRDATA(
		.rst(rst),
		.clk(~clk),
		.en(1'b1),
		.D(M_InstrData),
		.Q(W_InstrData)
	);

	//Control Unit Signals M/W
	Reg_Param #(.DATA_WIDTH(1)) M_W_REGWRITE(
		.rst(rst),
		.clk(~clk),
		.en(1'b1),
		.D(M_RegWrite),
		.Q(W_RegWrite)
	);
	Reg_Param #(.DATA_WIDTH(1)) M_W_MEMTOREG(
		.rst(rst),
		.clk(~clk),
		.en(1'b1),
		.D(M_MemtoReg),
		.Q(W_MemtoReg)
	);

	/*
		WRITEBACK STAGE
	*/
	
    //Mux for WD3
	Mux_2_1 #(.DATA_WIDTH(32)) WD3MUX (
		.A(W_ALUOut),
		.B(W_MemData),
		.sel(W_MemtoReg),
		.Q(W_WD3)
	);
	
endmodule