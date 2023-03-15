//////////////////////////////////////////////////////////////////////////////////
//  Company: ITESO
//  Engineer: Jorge Alberto Padilla Gutierrez
//  Module Description: UART Full Duplex that instanciates Rx and Tx
//////////////////////////////////////////////////////////////////////////////////

import UART_pkg::*;

module UART_Full_Duplex (
    //Inputs
    input           clk,
    input           rst,
	input           rx,
    input           rx_data_clf,
    input           tx_send,
    input           tx_data_en,
    input           tx_send_en,
    input [7:0]     Tx_Data,
	//Outputs
    output [7:0]    Rx_Data_w,
	output          parity_error,
    output          in_save_data_bits_w,
    output          tx,
    output          tx_send_w,
    //Debug Outputs
    output rx_state_t Rx_state_out,
    output tx_state_t Tx_state_out
);

    //Wires for internal conections
    wire        in_save_data_bits;
    wire        tx_fsm_in_STOP_S;
    wire [7:0]  Rx_Data;
    wire [7:0]  Tx_Data_w;

    //Rx Register
	Reg_Param #(.DATA_WIDTH(8)) RXREG (
		.clk(clk),
		.rst(rst),
		.en(1'b1),
		.D(Rx_Data),
		.Q(Rx_Data_w)
	);

    //Tx Register
	Reg_Param #(.DATA_WIDTH(8)) TXREG (
		.clk(clk),
		.rst(rst),
		.en(tx_data_en),
		.D(Tx_Data),
		.Q(Tx_Data_w)
	);

    //Rx Ready Register
	Reg_Param #(.DATA_WIDTH(1)) RXRREG (
		.clk(clk),
		.rst(~rx_data_clf&rst),
		.en(in_save_data_bits),
		.D(1'b1),
		.Q(in_save_data_bits_w)
	);

    //Tx Send Register
	Reg_Param #(.DATA_WIDTH(1)) TXSREG (
		.clk(clk),
		.rst(~tx_fsm_in_STOP_S&rst),
		.en(tx_send_en),
		.D(tx_send),
		.Q(tx_send_w)
	);

    //Rx Module
	UART_Rx RX(
        .clk(clk),
        .rst(rst),
        .rx(rx),
        .Rx_Data_w(Rx_Data),
        .parity_error(parity_error),
        .in_save_data_bits(in_save_data_bits),
        .Rx_state_out(Rx_state_out)
    );

    //Tx Module
    UART_Tx TX(
        .clk(clk),
        .rst(rst),
        .tx_send(tx_send_w),
        .Tx_Data(Tx_Data_w),
        .tx(tx),
        .tx_fsm_in_STOP_S(tx_fsm_in_STOP_S),
        .Tx_state_out(Tx_state_out)
    );

endmodule		