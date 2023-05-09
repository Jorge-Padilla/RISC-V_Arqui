//////////////////////////////////////////////////////////////////////////////////
// Company: ITESO
// Engineer: Jorge Alberto Padilla Gutierrez
// Module Description: RISC-V TestBench for UART
//////////////////////////////////////////////////////////////////////////////////

`timescale 1ns / 1ps

import Control_Unit_enum::*;
import UART_pkg::*;

module RISC_V_Pipeline_rst_tb;

	//Wires
	reg                     clk;
    reg                     rst;
    reg                     rx;
	reg [7:0]				gpio_port_in;
	wire [7:0]				gpio_port_out;
	wire                    tx;
    wire              		clk_out;
	cu_fsm_state_t          CU_State;
    rx_state_t              Rx_state_out;
    tx_state_t              Tx_state_out;
	
	//Instancia del DUT
	RISC_V_Pipeline DUT(
		.clk(clk),
		.rst(rst),
        .clk_out(clk_out),
        .rx(rx),
        .tx(tx),
		.gpio_port_in(gpio_port_in),
		.gpio_port_out(gpio_port_out),
        .Rx_state_out(Rx_state_out),
        .Tx_state_out(Tx_state_out)
	);

    reg         tx_send;
    reg         tx_send_en;
    reg [7:0]   Tx_Data;
    reg         rx_data_clf;
    wire [7:0]  Rx_Data_w;
	wire        parity_error;
    wire        in_save_data_bits;
    wire        tx_fsm_in_STOP_S;
    rx_state_t  Rx_state_out_u;
    tx_state_t  Tx_state_out_u;

    //DUT Module
	UART_Full_Duplex UART(
        .clk(clk),
        .rst(rst),
        .rx(tx),
        .rx_data_clf(rx_data_clf),
        .Rx_Data_w(Rx_Data_w),
        .parity_error(parity_error),
        .in_save_data_bits_w(in_save_data_bits),
        .Rx_state_out(Rx_state_out_u),
        .tx_send(tx_send),
        .tx_send_en(tx_send_en),
        .tx_data_en(1'b1),
        .Tx_Data(Tx_Data),
        .tx(rx),
        .tx_send_w(tx_fsm_in_STOP_S),
        .Tx_state_out(Tx_state_out_u)
    );
	
	//Proceso de impresión a consola
	initial
	begin
		$dumpfile("dump.vcd");
		$dumpvars(1);
		
		//$monitor("Input: clk=%b. Output: d=%b", clk, d);
	end
	
	//Proceso que fluctua a clock
	initial
	begin
		gpio_port_in = 8'h03;
		rst = 1'b1;
        tx_send = 0;
        Tx_Data = '0;
        rx_data_clf = 1'b0;
        tx_send_en = 1'b0;

		#1 rst = 1'b0;
        #1 rst = 1'b1;
		
        #1

        #1 rst = 1'b0;
        #1 rst = 1'b1;

        #2

        #1 rst = 1'b0;
        #1 rst = 1'b1;
        
        #1

        #2 rst = 1'b0;
        #2 rst = 1'b1;

        #2

        #2 rst = 1'b0;
        #2 rst = 1'b1;

        #200

		$finish();
	end

	initial begin
        clk = 1'b0;
        forever #1 clk = ~clk;
    end
endmodule