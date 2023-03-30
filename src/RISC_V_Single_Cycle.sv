//////////////////////////////////////////////////////////////////////////////////
// Company: ITESO
// Engineer: Jorge Alberto Padilla Gutierrez
// Module Description: RISC-V Single Cycle DUT
//////////////////////////////////////////////////////////////////////////////////

import Control_Unit_enum::*;
import UART_pkg::*;

module RISC_V_Single_Cycle (
    //Inputs
    input wire      clk, 
    input wire      rst,
    input           rx,
    input [7:0]     gpio_port_in,
    //Outputs
    output          tx,
    output [7:0]    gpio_port_out,
    //Debug Outputs
    output                  clk_out,
    output                  parity_error,
    output rx_state_t       Rx_state_out,
    output tx_state_t       Tx_state_out
);

    //Conection Signals
    wire        weRAM;
    wire        weGPIO;
    wire        MemWrite;
    wire        MemRead;
    wire        rx_data;
    wire        in_save_data_bits_w;
    wire        tx_fsm_in_STOP_S;
    wire        tx_send;
    wire        tx_data_en;
    wire        tx_send_en;
    wire [7:0]  Rx_Data;
    wire [7:0]  Tx_Data;
    wire [31:0] Adr;
    wire [31:0] InstrData;
    wire [31:0] MemData;
    wire [31:0] PC;
    wire [31:0] Data;
    wire [31:0] ReadRAM;
    wire [31:0] ReadGPIO;
    wire [31:0] DataGPIO;
    wire [31:0] AddrRAM;
    wire [31:0] DataRAM;

	//RISC-V Core
    RISC_V_Core #(.DATA_WIDTH(32), .ADDR_WIDTH(32)) CORE (
        .clk(clk), 
        .rst(rst),
        .InstrData(InstrData),
        .MemData(MemData),
        .MemRead(MemRead), 
        .MemWrite(MemWrite),
        .WriteData(Data),
        .RWAddress(Adr),
        .PC(PC)
    );

    //Memory Map Controler for RAM, ROM, GPIO and UART
    Mem_Map_Controler #(.DATA_WIDTH(32),.ADDR_WIDTH(32)) MM (
        .clk(clk),
        .re(MemRead),
        .we(MemWrite),
	    .parity_error(parity_error),
        .in_save_data_bits_w(in_save_data_bits_w),
        .tx_fsm_in_STOP_S(tx_fsm_in_STOP_S),
        .Rx_Data(Rx_Data),
        .ReadRAM(ReadRAM),
        .ReadGPIO({24'h0,ReadGPIO[7:0]}),
        .WD(Data),
        .A(Adr),
        .weRAM(weRAM),
        .weGPIO(weGPIO),
        .rx_data(rx_data),
        .tx_send_en(tx_send_en),
        .tx_data_en(tx_data_en),
        .tx_send(tx_send),
        .Tx_Data_w(Tx_Data),
        .DataGPIO(DataGPIO),
        .AddrRAM(AddrRAM),
        .DataRAM(DataRAM),
        .RD(MemData)
    );

    //Instruction Memory
    ROM_Single_Port #(.DATA_WIDTH(32), .ADDR_WIDTH(6)) ROM (
        .A(PC[7:2]),
        .RD(InstrData)
    );

    //Data Memory
    RAM_Single_Port #(.DATA_WIDTH(32), .ADDR_WIDTH(6)) RAM (
        .WD(DataRAM),
        .A(AddrRAM[7:2]),
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

    //UART
    UART_Full_Duplex UART(
        .clk(clk),
        .rst(rst),
        .rx(rx),
        .tx_send(tx_send),
        .tx_data_en(tx_data_en),
        .tx_send_en(tx_send_en),
        .Tx_Data(Tx_Data),
        .Rx_Data_w(Rx_Data),
        .rx_data_clf(rx_data),
        .parity_error(parity_error),
        .in_save_data_bits_w(in_save_data_bits_w),
        .tx(tx),
        .tx_send_w(tx_fsm_in_STOP_S),
        .Rx_state_out(Rx_state_out),
        .Tx_state_out(Tx_state_out)
    );

    //Debug Output
    assign clk_out = clk;


endmodule