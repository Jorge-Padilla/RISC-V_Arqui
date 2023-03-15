//////////////////////////////////////////////////////////////////////////////////
// Company: ITESO
// Engineer: Jorge Alberto Padilla Gutierrez
// Module Description: Single port RAM with single read/write address 
//////////////////////////////////////////////////////////////////////////////////

`include "Regs.sv"

import UART_pkg::*;

module Mem_Map_Controler #(parameter DATA_WIDTH = 32, parameter ADDR_WIDTH = 32) (
	//Inputs
    input                           clk,
	input                           re,
	input                           we,
	input                           parity_error,
    input                           in_save_data_bits_w,
    input                           tx_fsm_in_STOP_S,
    input [7:0]                     Rx_Data,
	input [(ADDR_WIDTH-1):0]        ReadROM,
	input [(ADDR_WIDTH-1):0]        ReadRAM,
	input [(ADDR_WIDTH-1):0]        ReadGPIO,
	input [(DATA_WIDTH-1):0]        WD,
	input [(ADDR_WIDTH-1):0]        A,
	//Output
	output                          weRAM,
	output                          weGPIO,
    output                          rx_data,
    output                          tx_send_en,
    output                          tx_data_en,
    output                          tx_send,
    output [7:0]                    Tx_Data_w,
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
    wire                    gpio;
    wire                    data;
    wire                    mem;
    wire                    rx_ready;
    wire                    uart;
    wire                    start_fsm;
    wire                    rst_counter;
    wire                    tx_send_read;
    //wire [1:0]              Counter;
    wire [(DATA_WIDTH-1):0] ReadUART;
    //wire [(DATA_WIDTH-1):0] WriteUART;
    //word_state_t            Word_state_out;

    //0x10010000 is data memory
    //0x10010024 and 0x10010028 is GPIO
    //0x00400000 is instruction memory
    assign weGPIO       = A == 32'h10010024 && we;
    assign gpio         = A == 32'h10010028;
    assign rx_data      = A == 32'h10010030 | tx_send_read;
    assign tx_data_en   = A == 32'h10010034 && we;          // && (Word_state_out === INIT_W);
    assign rx_ready     = A == 32'h10010038 | tx_send_read; //clears when reading rx_data
    assign tx_send_en   = A == 32'h1001003C && we;
    assign tx_send_read = A == 32'h1001003C && ~we;
    assign uart         = rx_data | rx_ready;
    assign mem          = (|A[DATA_WIDTH-1:28] && |A[27:16] && !(gpio | weGPIO | tx_data_en | tx_send_en)) | uart;
    assign weRAM        = mem && we;
    assign data         = (~mem & (|A[27:22])) | uart;

    //Select UART Rx
    Mux_4_1 #(.DATA_WIDTH(DATA_WIDTH)) RXMUX (
        .A(32'b0),
        .B({31'h0,in_save_data_bits_w}),
        .C({24'b0,Rx_Data}),
        .D({31'h0,tx_fsm_in_STOP_S}),
        .sel({rx_data,rx_ready}),
        .Q(ReadUART)
    );

    //Select Memory
    Mux_4_1 #(.DATA_WIDTH(DATA_WIDTH)) MEMMUX (
        .A(ReadGPIO),
        .B(ReadRAM),
        .C(ReadROM),
        .D(ReadUART),
        .sel({data,mem}),
        .Q(RD)
    );

    //The Data and Address Values are always sent and just selected with MUX or Enables
    assign AddrROM      = A;
    assign AddrRAM      = A;
    assign DataGPIO     = WD;
    assign DataRAM      = WD;
    assign tx_send      = |WD;
    assign Tx_Data_w    = WD[7:0];

    /*
    //UART Word and send registers
    Reg_Param #(.DATA_WIDTH(DATA_WIDTH)) UARTREG (
		.clk(clk),
		.rst(1'b1),
		.en(word_data_en),
		.D(WD),
		.Q(WriteUART)
	);

    Reg_Param #(.DATA_WIDTH(1)) UARTSREG (
		.clk(clk),
		.rst(rst_send_en),
		.en(word_send_en),
		.D(|WD),
		.Q(start_fsm)
	);

    //Select Part of Word for UART
    Mux_4_1 #(.DATA_WIDTH(8)) TXMUX (
        .A(WriteUART[31:24]),
        .B(WriteUART[23:16]),
        .C(WriteUART[15:8]),
        .D(WriteUART[7:0]),
        .sel(Counter),
        .Q(Tx_Data_w)
    );

    UART_Word_FSM FSM(
        .clk(clk),
        .rst(rst),
        .start_fsm(start_fsm),
        .tx_fsm_in_STOP_S(tx_fsm_in_STOP_S),
        .Counter(Counter),
        .rst_send_en(rst_send_en),
        .rst_counter(rst_counter),
        .tx_send(tx_send),
        .tx_send_en(tx_send_en),
        .tx_data_en(tx_data_en),
        .Word_state_out(Word_state_out)
    );

    Counter_Param # (.MAX_COUNT(4)) COUNT_BITS (
        .clk(clk),
        .rst(rst_counter),
        .en(tx_fsm_in_STOP_S),
        .cnt(Counter)
    );	
    */

    //FF for read output
    //TODO: FIX DISPLACEMENT
    //`FF_D_RST_EN(clk, 1'b1, re, ReadMEM, RD)

endmodule
