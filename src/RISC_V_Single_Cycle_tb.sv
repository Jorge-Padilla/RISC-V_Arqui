//////////////////////////////////////////////////////////////////////////////////
// Company: ITESO
// Engineer: Jorge Alberto Padilla Gutierrez
// Module Description: RISC-V TestBench for UART
//////////////////////////////////////////////////////////////////////////////////

`timescale 1ns / 1ps

import Control_Unit_enum::*;
import UART_pkg::*;

module RISC_V_Single_Cycle_tb;

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
	RISC_V_Single_Cycle DUT(
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
	
	//Proceso de impresión a consola
	initial
	begin
		$dumpfile("dump.vcd");
		$dumpvars(1);
		
		//$monitor("Input: clk=%b. Output: d=%b", clk, d);
	end
	
	//Señales sin uso
	initial
	begin
		gpio_port_in = 8'h03;
        rx = 1'b0;
	end
	
	initial
	begin
		clk = 1'b0;
		rst = 1'b1;

		#1 rst = 1'b0;
		#1 rst = 1'b1;

		@(DUT.CORE.PCREG.Q == 32'h40002c);

        #10

		$finish();
	end

	//Proceso que fluctua a clock
	initial forever #1 clk = ~clk;

endmodule