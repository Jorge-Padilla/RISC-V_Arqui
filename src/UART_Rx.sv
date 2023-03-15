//////////////////////////////////////////////////////////////////////////////////
//  Company: ITESO
//  Engineer: Jorge Alberto Padilla Gutierrez
//  Module Description: UART Rx
////////////////////////////////////////////////////////////////////////////////////

import UART_pkg::*;

module UART_Rx(
    //Inputs
	input           clk,
	input           rst,
	input           rx,
	//Outputs
    output [7:0]    Rx_Data_w,
	output          parity_error,
    output          in_save_data_bits,
    //Debug Outputs
    output rx_state_t Rx_state_out
);

    wire        rst_bit_counter_w;
    wire        rst_BR_w;
    wire        sample_bit_w;
    wire        end_bit_time_w;
    wire        end_half_time_w;
    wire        bit_count_enable_w;
    wire        enable_out_reg_w;
    wire [3:0]  count_bits_w;
    wire [8:0]  Q_SR_w /* synthesis keep */;
    wire        parity;

    //Parity error signal for possible parity errors
    assign parity_error = (parity != ^Rx_Data_w) ? 1'b1 : 1'b0;
    assign in_save_data_bits = (Rx_state_out == SAVE_DATA_BITS);
    
    //UART Rx FSM
    FSM_UART_Rx FSM (
        .rx(rx),
        .clk(clk),
        .rst(rst),
        .end_half_time_i(end_half_time_w),
        .end_bit_time_i(end_bit_time_w),
        .Rx_bit_Count(count_bits_w), 
        .sample_o(sample_bit_w),
        .bit_count_enable(bit_count_enable_w),
        .rst_BR(rst_BR_w),
        .rst_bit_counter(rst_bit_counter_w),
        .enable_out_reg(enable_out_reg_w),
        .Rx_state_out(Rx_state_out)
    );	

    //Shift register for 9 input bits
    Shift_Register_R_Param #(.DATA_WIDTH(9)) SHIFT_REG (
        .clk(clk),
        .rst(rst),
        .enable(sample_bit_w),
        .d(rx),
        .Q(Q_SR_w)
    );

    //Output Reg
    Reg_Param #(.DATA_WIDTH(8)) RX_REG (
        .clk(clk),
        .rst(rst),
        .en(enable_out_reg_w),
        .D(Q_SR_w[7:0]),
        .Q(Rx_Data_w)
    );	

    //Parity Register
    Reg_Param #(.DATA_WIDTH(1)) FF_PAR (
        .clk(clk),
        .rst(rst),
        .en(enable_out_reg_w),
        .D(Q_SR_w[8]),
        .Q(parity)
    );    

    //For a baud rate of 9600 baudios: bit time 104.2 us, half time 52.1 us
    //For a clock frequency of 50 MHz bit time = 5210 T50MHz;
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