//////////////////////////////////////////////////////////////////////////////////
//  Company: ITESO
//  Engineer: Jorge Alberto Padilla Gutierrez
//  Module Description: UART Full Duplex Testbench
//////////////////////////////////////////////////////////////////////////////////

`timescale 1 ns / 10 ps

import UART_pkg::*;

module UART_Full_Duplex_tb;
    reg         clk;
    reg         rst;
    reg         tx_send;
    reg         tx_send_en;
    reg [7:0]   Tx_Data;
    reg         rx_data_clf;
    wire [7:0]  Rx_Data_w;
	wire        parity_error;
    wire        in_save_data_bits;
    wire        tx;
    wire        tx_fsm_in_STOP_S;
    rx_state_t  Rx_state_out;
    tx_state_t  Tx_state_out;

    //DUT Module
	UART_Full_Duplex DUT(
        .clk(clk),
        .rst(rst),
        .rx(tx),
        .rx_data_clf(rx_data_clf),
        .Rx_Data_w(Rx_Data_w),
        .parity_error(parity_error),
        .in_save_data_bits_w(in_save_data_bits),
        .Rx_state_out(Rx_state_out),
        .tx_send(tx_send),
        .tx_send_en(tx_send_en),
        .tx_data_en(1'b1),
        .Tx_Data(Tx_Data),
        .tx(tx),
        .tx_send_w(tx_fsm_in_STOP_S),
        .Tx_state_out(Tx_state_out)
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
        clk = 1'b0;
		rst = 1'b0;
        tx_send = 0;
        Tx_Data = '0;
        rx_data_clf = 1'b0;
        tx_send_en = 1'b0;
		#1 rst = 1'b1;
        #1 Tx_Data = 8'hEA;
        #2 tx_send = 1'b1;
        tx_send_en = 1'b1;
        #2 tx_send = 1'b0;
        tx_send_en = 1'b0;

		//@(DUT.CORE.PCREG.Q == '0);
		//@(DUT.CORE.PCREG.Q == '0);
		//@(posedge clk);
		//@(posedge clk);

        @(posedge in_save_data_bits);

        #1 rx_data_clf = 1'b1;
        #1 rx_data_clf = 1'b0;
        #1 Tx_Data = 8'h50;
        #2 tx_send = 1'b1;
        tx_send_en = 1'b1;
        #2 tx_send = 1'b0;
        tx_send_en = 1'b0;

        @(posedge in_save_data_bits);

        #1 rx_data_clf = 1'b1;
        #1 rx_data_clf = 1'b0;

        #10

		$finish();
	end

	initial forever #1 clk = ~clk;

endmodule		