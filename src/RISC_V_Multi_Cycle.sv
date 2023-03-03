//////////////////////////////////////////////////////////////////////////////////
// Company: ITESO
// Engineer: Jorge Alberto Padilla Gutierrez
// Module Description: RISC-V Multi Cycle DUT
//////////////////////////////////////////////////////////////////////////////////

import Control_Unit_enum::*;

module RISC_V_Multi_Cycle (
	//Inputs
	input wire      clk, 
	input wire      rst,
	input [7:0]     gpio_port_in,
	//Outputs
	output [7:0]    gpio_port_out,
    //Debug Outputs
    output                  clk_out,
	output cu_fsm_state_t   CU_State
);

    //Conection Signals
    wire        MemWrite;             //Memory Map Outside Core
    wire        MemRead;              //Memory Map Outside Core
    wire [31:0] Adr;                  //Memory Map Outside Core
    wire [31:0] MemData;              //Memory Map Outside Core
    wire [31:0] Data;                 //Memory Map Outside Core
    
    wire        weRAM;
    wire        weGPIO;
    wire [31:0] ReadROM;
    wire [31:0] ReadRAM;
    wire [31:0] ReadGPIO;
    wire [31:0] DataGPIO;
    wire [31:0] AddrROM;
    wire [31:0] AddrRAM;
    wire [31:0] DataRAM;

	//RISC-V Core
    RISC_V_Core #(.DATA_WIDTH(32), .ADDR_WIDTH(32)) CORE (
        .clk(clk), 
        .rst(rst),
        .MemData(MemData),
        .MemRead(MemRead), 
        .MemWrite(MemWrite),
        .WriteData(Data),
        .RWAddress(Adr),
        .CU_State(CU_State)
    );

    //Memory Map Controler for RAM, ROM, GPIO and UART
    Mem_Map_Controler #(.DATA_WIDTH(32),.ADDR_WIDTH(32)) MM (
        .clk(clk),
        .re(MemRead),
        .we(MemWrite),
        .ReadROM(ReadROM),
        .ReadRAM(ReadRAM),
        .ReadGPIO({24'h0,ReadGPIO[7:0]}),
        .WD(Data),
        .A(Adr),
        .weRAM(weRAM),
        .weGPIO(weGPIO),
        .DataGPIO(DataGPIO),
        .AddrROM(AddrROM),
        .AddrRAM(AddrRAM),
        .DataRAM(DataRAM),
        .RD(MemData)
    );

    //Instruction Memory
    ROM_Single_Port #(.DATA_WIDTH(32), .ADDR_WIDTH(10)) ROM (
        .A(AddrROM[11:2]),
        .RD(ReadROM)
    );

    //Data Memory
    RAM_Single_Port #(.DATA_WIDTH(32), .ADDR_WIDTH(10)) RAM (
        .WD(DataRAM),
        .A(AddrRAM[11:2]),
        .we(weRAM),
        .clk(clk),
        .RD(ReadRAM)
    );

    //GPIO
    GPIO  #(.DATA_WIDTH(8)) IO (
        .clk(clk),
        .en(weGPIO),
        .GPIO_Data(DataGPIO),
        .GPIO_In(gpio_port_in),
        .GPIO_toMem(ReadGPIO),
        .GPIO_Out(gpio_port_out)
    );

    //Debug Output
    assign clk_out = clk;


endmodule