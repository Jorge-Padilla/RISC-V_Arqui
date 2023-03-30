//////////////////////////////////////////////////////////////////////////////////
// Company: ITESO
// Engineer: Jorge Alberto Padilla Gutierrez
// Module Description: RISC-V Core
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
    wire                    Zero;
    wire                    RegWrite;
    wire                    Jump;
    wire                    Branch;
    wire                    XorZero;
    wire                    MemtoReg;
    wire                    PCSrc;
    wire                    JalrMux;
    wire [1:0]              ALUSrcA;
    wire [1:0]              ALUSrcB;
    wire [1:0]              ShiftAmnt;
    wire [2:0]              SignExt;
    wire [4:0]              ALUControl;
    wire [DATA_WIDTH-1:0]   PCp;
    wire [DATA_WIDTH-1:0]   PCj;
    wire [DATA_WIDTH-1:0]   PCp4;
    wire [DATA_WIDTH-1:0]   PCbra;
    wire [DATA_WIDTH-1:0]   WD3;
    wire [DATA_WIDTH-1:0]   RD1;
    wire [DATA_WIDTH-1:0]   SignImm;
    wire [DATA_WIDTH-1:0]   ShiftImm;
    wire [DATA_WIDTH-1:0]   SrcA;
    wire [DATA_WIDTH-1:0]   SrcB;
	
	//Instance of Modules

    //Contrl Unit
	Control_Unit CU(
        .clk(clk),
        .rst(rst),
        .Opcode(InstrData[6:0]),
        .Funct7(InstrData[31:25]),
        .Funct3(InstrData[14:12]),
        .ALUSrcA(ALUSrcA),
        .ALUSrcB(ALUSrcB),
        .ShiftAmnt(ShiftAmnt),
        .SignExt(SignExt),
        .MemWrite(MemWrite), 
        .MemRead(MemRead),
        .RegWrite(RegWrite),
        .Jump(Jump),
        .Branch(Branch),
        .XorZero(XorZero),
        .MemtoReg(MemtoReg),
        .JalrMux(JalrMux),
        .ALUControl(ALUControl)
    );
	
    //PC Enable Logic for Branches and Jumps
	PC_Enable PCE(
		.PCWrite(Jump),
		.Branch(Branch),
		.Zero(Zero),
		.XorZero(XorZero),
		.PCEn(PCSrc)
	);
	
    //Program Counter Register
	Reg_PC #(.DATA_WIDTH(DATA_WIDTH)) PCREG (
		.rst(rst),
		.clk(clk),
		.en(1'b1),
		.D(PCp),
		.Q(PC)
	);

	//PC+4 Adder
	Adder #(.DATA_WIDTH(DATA_WIDTH)) PCP4 (
		.a(PC),
		.b(32'h4),
		.f(PCp4)
	);

	//Mux for jal and jalr source
	Mux_2_1 #(.DATA_WIDTH(DATA_WIDTH)) JALRMUX (
		.A(PC),
		.B(RD1),
		.sel(JalrMux),
		.Q(PCj)
	);

	//Branch and Jump Adder
	Adder #(.DATA_WIDTH(DATA_WIDTH)) PCBJ (
		.a(PCj),
		.b(ShiftImm),
		.f(PCbra)
	);
	
    //Mux for next PC
	Mux_2_1 #(.DATA_WIDTH(DATA_WIDTH)) PCOUTMUX (
		.A(PCp4),
		.B(PCbra),
		.sel(PCSrc),
		.Q(PCp)
	);
	
    //Register File
	Reg_File #(.ADDRESS_WIDTH(5), .DATA_WIDTH(DATA_WIDTH)) REGFILE (
		.clk(clk),
		.we3(RegWrite),
		.a1(InstrData[19:15]),
		.a2(InstrData[24:20]),
		.a3(InstrData[11:7]),
		.wd3(WD3),
		.rd1(RD1),
		.rd2(WriteData)
	);
    
    //Sign Extender Unit
    Sign_Ext_Unit #(.IN_WIDTH_1(12), .IN_WIDTH_2(20), .OUT_WIDTH(DATA_WIDTH)) SEU (
        .In_12_I(InstrData[31:20]),
        .In_12_S({InstrData[31:25],InstrData[11:7]}),
        .In_12_B({InstrData[31],InstrData[7],InstrData[30:25],InstrData[11:8]}),
        .In_20_U(InstrData[31:12]),
        .In_20_J({InstrData[31],InstrData[19:12],InstrData[20],InstrData[30:21]}),
        .sel(SignExt),
        .Out(SignImm)
    );
    
    //Shift Unit
    Shift_Unit #(.DATA_WIDTH(DATA_WIDTH)) SU (
        .In(SignImm),
        .sel(ShiftAmnt),
        .Out(ShiftImm)
    );
	
    //Mux for ALU A input
	Mux_4_1 #(.DATA_WIDTH(DATA_WIDTH)) AMUX (
		.A(PC),
		.B(RD1),
		.C(32'h0),
		.D(32'h0),
		.sel(ALUSrcA),
		.Q(SrcA)
	);
	
    //Mux for ALU B input
	Mux_4_1 #(.DATA_WIDTH(DATA_WIDTH)) BMUX (
		.A(WriteData),
		.B(32'h4),
		.C(ShiftImm),
		.D({27'h0,ShiftImm[4:0]}),
		.sel(ALUSrcB),
		.Q(SrcB)
	);
	
    //ALU for RV32I
	ALU ALURISCV(
		.a(SrcA),
		.b(SrcB),
		.sel(ALUControl),
		.f(RWAddress),
		.z(Zero)
	);
	
    //Mux for WD3
	Mux_2_1 #(.DATA_WIDTH(32)) WD3MUX (
		.A(RWAddress),
		.B(MemData),
		.sel(MemtoReg),
		.Q(WD3)
	);
	
endmodule