//////////////////////////////////////////////////////////////////////////////////
// Company: ITESO
// Engineer: Jorge Alberto Padilla Gutierrez
// Module Description: Single port RAM with single read/write address 
//////////////////////////////////////////////////////////////////////////////////

`include "Regs.sv"

module Mem_Map #(parameter DATA_WIDTH = 32, parameter ADDR_WIDTH = 32) (
	//Inputs
	input [(DATA_WIDTH-1):0]        WD,
	input [(ADDR_WIDTH-1):0]        A,
	input                           re,
	input                           we,
    input                           clk,
	//Output
	output reg[(DATA_WIDTH-1):0]    RD
);

    //Signals for read values
    wire [(DATA_WIDTH-1):0] ReadRAM;
    wire [(DATA_WIDTH-1):0] ReadROM;
    wire [(DATA_WIDTH-1):0] ReadMEM;

    //Signals for Map detection
    wire    data;
    wire    mem;

    //Instruction Memory
    ROM_Single_Port #(.DATA_WIDTH(DATA_WIDTH), .ADDR_WIDTH(10)) ROM (
        .A(A[11:2]),
        .RD(ReadROM)
    );

    //Data Memory
    RAM_Single_Port #(.DATA_WIDTH(DATA_WIDTH), .ADDR_WIDTH(10)) RAM (
        .WD(WD),
        .A(A[11:2]),
        .we(we),
        .clk(clk),
        .RD(ReadRAM)
    );

    //0x00400000 is instruction memory
    //0x10000000 is data memory
    assign mem = |A[DATA_WIDTH-1:28];
    assign data = ~mem & (|A[27:22]);

    //Select Memory
    Mux_4_1 #(.DATA_WIDTH(DATA_WIDTH)) MUX (
        .A(32'h0),
        .B(ReadRAM),
        .C(ReadROM),
        .D(32'h0),
        .sel({data,mem}),
        .Q(RD)
    );

    //FF for read output
    //TODO: FIX DISPLACEMENT
    //`FF_D_RST_EN(clk, 1'b1, re, ReadMEM, RD)

endmodule
