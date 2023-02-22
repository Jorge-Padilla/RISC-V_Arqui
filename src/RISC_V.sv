//////////////////////////////////////////////////////////////////////////////////
// Company: ITESO
// Engineer: Jorge Alberto Padilla Gutierrez
// Module Description: RISC-V DUT
//////////////////////////////////////////////////////////////////////////////////

import Control_Unit_enum::*;

module RISC_V #(parameter DATA_WIDTH = 32, parameter ADDR_WIDTH = 32) (
	//Inputs
	input wire              clk, 
	input wire              rst,
	//Outputs
	output wire             uart_tx_out,
    //Debug Outputs
    output [DATA_WIDTH-1:0] mem_data,
	output cu_fsm_state_t   CU_State
);

//TODO: Implement pll for FPGA
/*
*	wire pll_clk_out;
*
*	//PLL, 85MHz max frequency
*	pll pll_inst (
*		.refclk   (clk),        // refclk.clk
*		.rst      (1'b0),       // reset.reset
*		.outclk_0 (pll_clk_out)
*	);
*/    

	//Signals required for connections
	wire                    PCEn;
    wire                    Zero;
    wire                    MemWrite;
    wire                    MemRead;
    wire                    IRWrite;
    wire                    RegWrite;
    wire                    PCWrite;
    wire                    IorD;
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
	wire [DATA_WIDTH-1:0]   PC;
	wire [DATA_WIDTH-1:0]   PCp;
	wire [DATA_WIDTH-1:0]   PCbra;
	wire [DATA_WIDTH-1:0]   Adr;
	wire [DATA_WIDTH-1:0]   MemData;
	wire [DATA_WIDTH-1:0]   Instr;
	wire [DATA_WIDTH-1:0]   Data;
	wire [DATA_WIDTH-1:0]   WD3;
	wire [DATA_WIDTH-1:0]   RD1;
	wire [DATA_WIDTH-1:0]   RD2;
	wire [DATA_WIDTH-1:0]   AMux;
	wire [DATA_WIDTH-1:0]   A;
	wire [DATA_WIDTH-1:0]   B;
	wire [DATA_WIDTH-1:0]   SignImm;
	wire [DATA_WIDTH-1:0]   ShiftImm;
	wire [DATA_WIDTH-1:0]   SrcA;
	wire [DATA_WIDTH-1:0]   SrcB;
	wire [DATA_WIDTH-1:0]   ALUResult;
	wire [DATA_WIDTH-1:0]   ALUOut;
	wire                    tx_fsm_in_STOP_S;
	wire                    uart_tx_send;
	
	//Instance of Modules

    //Contrl Unit
	Control_Unit CU(
        .clk(clk),
        .rst(rst),
        .Opcode(Instr[6:0]),
        .Funct7(Instr[31:25]),
        .Funct3(Instr[14:12]),
        .ALUSrcA(ALUSrcA),
        .ALUSrcB(ALUSrcB),
        .PCSrc(PCSrc),
        .ShiftAmnt(ShiftAmnt),
        .SignExt(SignExt),
        .MemWrite(MemWrite), 
        .MemRead(MemRead),
        .IRWrite(IRWrite),
        .RegWrite(RegWrite),
        .PCWrite(PCWrite),
        .IorD(IorD),
        .Branch(Branch),
        .XorZero(XorZero),
        .MemtoReg(MemtoReg),
        .JalrMux(JalrMux),
        .ALUControl(ALUControl),
        .tx_fsm_in_STOP_S(tx_fsm_in_STOP_S),
        .uart_tx_send(uart_tx_send),
        .State_o(CU_State)
    );
	
    //PC Enable Logic for Branches and Jumps
    PC_Enable PCE(
        .PCWrite(PCWrite),
        .Branch(Branch),
        .Zero(Zero),
        .XorZero(XorZero),
        .PCEn(PCEn)
    );
	
    //Program Counter Register
	Reg_PC #(.DATA_WIDTH(DATA_WIDTH)) PCREG (
		.rst(rst),
		.clk(clk),
		.en(PCEn),
		.D(PCp),
		.Q(PC)
	);
	
    //Branch Program Counter Register
	Reg_PC #(.DATA_WIDTH(DATA_WIDTH)) PCBRAREG (
		.rst(rst),
		.clk(clk),
		.en(PCEn),
		.D(PC),
		.Q(PCbra)
	);
	
    //Mux that defines if the Memory address is PC or ALUOut
	Mux_2_1 #(.DATA_WIDTH(DATA_WIDTH)) PCMUX (
		.A(PC),
		.B(ALUOut),
		.sel(IorD),
		.Q(Adr)
	);
	
    //Memory Map
    Mem_Map #(.DATA_WIDTH(DATA_WIDTH),.ADDR_WIDTH(ADDR_WIDTH)) MM (
        .WD(B),
        .A(Adr),
        .re(MemRead),
        .we(MemWrite),
        .clk(clk),
        .RD(MemData)
    );
	
    //Instruction Register
	Reg_Param #(.DATA_WIDTH(DATA_WIDTH)) INSTRREG (
		.rst(1'b1),
		.clk(clk),
		.en(IRWrite),
		.D(MemData),
		.Q(Instr)
	);
	
    //Data Register
	Reg_Param #(.DATA_WIDTH(DATA_WIDTH)) DATAREG (
		.rst(1'b1),
		.clk(clk),
		.en(1'b1),
		.D(MemData),
		.Q(Data)
	);
	
    //Mux for WD3
	Mux_2_1 #(.DATA_WIDTH(32)) WD3MUX (
		.A(ALUOut),
		.B(Data),
		.sel(MemtoReg),
		.Q(WD3)
	);
	
    //Register File
	Reg_File #(.ADDRESS_WIDTH(5), .DATA_WIDTH(DATA_WIDTH)) REGFILE (
		.clk(clk),
		.we3(RegWrite),
		.a1(Instr[19:15]),
		.a2(Instr[24:20]),
		.a3(Instr[11:7]),
		.wd3(WD3),
		.rd1(RD1),
		.rd2(RD2)
	);
    
    //Sign Extender Unit
    Sign_Ext_Unit #(.IN_WIDTH_1(12), .IN_WIDTH_2(20), .OUT_WIDTH(DATA_WIDTH)) SEU (
        .In_12_I(Instr[31:20]),
        .In_12_S({Instr[31:25],Instr[11:7]}),
        .In_12_B({Instr[31],Instr[7],Instr[30:25],Instr[11:8]}),
        .In_20_U(Instr[31:12]),
        .In_20_J({Instr[31],Instr[19:12],Instr[20],Instr[30:21]}),
        .sel(SignExt),
        .Out(SignImm)
    );
    
    //Shift Unit
    Shift_Unit #(.DATA_WIDTH(DATA_WIDTH)) SU (
        .In(SignImm),
        .sel(ShiftAmnt),
        .Out(ShiftImm)
    );
	
    //ALU A Register
	Reg_Param #(.DATA_WIDTH(DATA_WIDTH)) AREG (
		.rst(1'b1),
		.clk(clk),
		.en(1'b1),
		.D(RD1),
		.Q(A)
	);
	
    //ALU B Register
	Reg_Param #(.DATA_WIDTH(DATA_WIDTH)) BREG (
		.rst(1'b1),
		.clk(clk),
		.en(1'b1),
		.D(RD2),
		.Q(B)
	);
	
    //Mux for rs1 value for jalr
	Mux_2_1 #(.DATA_WIDTH(DATA_WIDTH)) JALRMUX (
		.A(A),
		.B(RD1),
		.sel(JalrMux),
		.Q(AMux)
	);
	
    //Mux for ALU A input
	Mux_4_1 #(.DATA_WIDTH(DATA_WIDTH)) AMUX (
		.A(PC),
		.B(AMux),
		.C(32'h0),
		.D(PCbra),
		.sel(ALUSrcA),
		.Q(SrcA)
	);
	
    //Mux for ALU B input
	Mux_4_1 #(.DATA_WIDTH(DATA_WIDTH)) BMUX (
		.A(B),
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
		.f(ALUResult),
		.z(Zero)
	);
	
    //Register for ALU Output
	Reg_Param #(.DATA_WIDTH(DATA_WIDTH)) ALUREG (
		.rst(1'b1),
		.clk(clk),
		.en(1'b1),
		.D(ALUResult),
		.Q(ALUOut)
	);
	
    //Mux for next PC
	Mux_2_1 #(.DATA_WIDTH(DATA_WIDTH)) PCOUTMUX (
		.A(ALUResult),
		.B(ALUOut),
		.sel(PCSrc),
		.Q(PCp)
	);

    //UART
//	UART_Tx UART_Tx_i (
//		.clk(clk),
//		.n_rst(rst),
//		.tx_send(uart_tx_send),
//		.Tx_Data(A),
//		.tx(uart_tx_out),
//		.tx_fsm_in_STOP_S(tx_fsm_in_STOP_S)
//	);

    //Debug Output
    assign mem_data = B;
	
endmodule