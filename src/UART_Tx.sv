//////////////////////////////////////////////////////////////////////////////////
//  Company: ITESO
//  Engineer: Jorge Alberto Padilla Gutierrez
//  Module Description: UART Tx
//////////////////////////////////////////////////////////////////////////////////

import UART_pkg::*;

module UART_Tx (
    //Inputs
    input       clk,
    input       rst,
    input       tx_send,
    input [7:0] Tx_Data,
    //Outputs
    output      tx,
    output wire tx_fsm_in_STOP_S,
    //Debug Outputs
    output tx_state_t Tx_state_out
);

	wire        rst_bit_counter_w;
    wire        rst_BR_w;
	wire        shift_bit_w;
	wire        end_bit_time_w;
    wire        end_half_time_w;
	wire        enable_shift_reg_w;
    wire        enable_in_reg_w;
	wire        parity;
	wire [3:0]  count_bits_w;
	wire [8:0]  Q_SR_w /* synthesis keep */;
	wire [7:0]  Tx_Data_w;
	
	assign parity = ^(Tx_Data_w);

	//FSM
	FSM_UART_Tx FSM_Tx (
		.tx_send(tx_send), 
		.clk(clk), 
		.rst(rst), 
		.end_half_time_i(end_half_time_w),
		.end_bit_time_i(end_bit_time_w), 
		.Tx_bit_Count(count_bits_w), 
		.bit_count_enable(bit_count_enable_w), 
		.rst_BR(rst_BR_w),
		.rst_bit_counter(rst_bit_counter_w), 
		.enable_in_reg(enable_in_reg_w), 
		.enable_shift_reg(enable_shift_reg_w), 
		.shift_shift_reg(shift_bit_w),
		.tx_fsm_in_STOP_S(tx_fsm_in_STOP_S),
        .Tx_state_out(Tx_state_out)
	);	

	//Input register
	Reg_Param #(.DATA_WIDTH(8)) TX_REG (
		.clk(clk),
		.rst(rst), 
		.en(enable_in_reg_w), 
		.D(Tx_Data[7:0]),
		.Q(Tx_Data_w)    
	);

	//Shift register PISO
	Shift_Register_PISO_Param #(.NUM_BITS(11)) PISO (
		.clk(clk),
		.rst(rst), 
		.enable(enable_shift_reg_w), 
		.shift(shift_bit_w),
		.D({1'b1,parity,Tx_Data_w,1'b0}), 
		.q(tx)    
	);  

    // For a baud rate of 9600 baudios: bit time 104.2 us, half time 52.1 us
    // For a clock frequency of 50 MHz bit time = 5210 T50MHz;
    Bit_Rate_Pulse #(.DELAY_COUNTS(5210)) BR_PULSE (
        .clk(clk),
        .rst(rst_BR_w), 
        .enable(1'b1),
        .end_bit_time(end_bit_time_w),
        .end_half_time (end_half_time_w)
    );		   

    //Counter for 9 input bits   
    Counter_Param # (.MAX_COUNT(16)) COUNT_BITS (
        .clk(clk),
        .rst(rst_bit_counter_w),
        .en(bit_count_enable_w),
        .cnt(count_bits_w)
    );	

endmodule		