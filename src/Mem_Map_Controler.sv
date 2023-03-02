//////////////////////////////////////////////////////////////////////////////////
// Company: ITESO
// Engineer: Jorge Alberto Padilla Gutierrez
// Module Description: Single port RAM with single read/write address 
//////////////////////////////////////////////////////////////////////////////////

`include "Regs.sv"

module Mem_Map_Controler #(parameter DATA_WIDTH = 32, parameter ADDR_WIDTH = 32) (
	//Inputs
    input                           clk,
	input                           re,
	input                           we,
	input [(ADDR_WIDTH-1):0]        ReadROM,
	input [(ADDR_WIDTH-1):0]        ReadRAM,
	input [(ADDR_WIDTH-1):0]        ReadGPIO,
	input [(DATA_WIDTH-1):0]        WD,
	input [(ADDR_WIDTH-1):0]        A,
	//Output
	output                          weRAM,
	output                          weGPIO,
	output [(DATA_WIDTH-1):0]       DataGPIO,
	output [(DATA_WIDTH-1):0]       AddrROM,
	output [(DATA_WIDTH-1):0]       AddrRAM,
	output [(DATA_WIDTH-1):0]       DataRAM,
	output reg[(DATA_WIDTH-1):0]    RD
);

    //Signals for read values
    //wire [(DATA_WIDTH-1):0] ReadRAM;
    //wire [(DATA_WIDTH-1):0] ReadROM;
    //wire [(DATA_WIDTH-1):0] ReadMEM;

    //Signals for Map detection
    wire    gpio;
    wire    data;
    wire    mem;

    //0x10010000 is data memory
    //0x10010024 and 0x10010028 is GPIO
    //0x00400000 is instruction memory
    assign weGPIO = A == 32'h10010024 && we;
    assign gpio = A == 32'h10010028;
    assign mem = |A[DATA_WIDTH-1:28] && |A[27:16] && !(gpio | weGPIO);
    assign weRAM = mem && we;
    assign data = ~mem & (|A[27:22]);

    //Select Memory
    Mux_4_1 #(.DATA_WIDTH(DATA_WIDTH)) MUX (
        .A(ReadGPIO),
        .B(ReadRAM),
        .C(ReadROM),
        .D(32'h0),
        .sel({data,mem}),
        .Q(RD)
    );

    //The Data and Address Values are always sent and just selected with MUX or Enables
    assign DataGPIO = WD;
    assign AddrROM  = A;
    assign AddrRAM  = A;
    assign DataRAM  = WD;

    //FF for read output
    //TODO: FIX DISPLACEMENT
    //`FF_D_RST_EN(clk, 1'b1, re, ReadMEM, RD)

endmodule
