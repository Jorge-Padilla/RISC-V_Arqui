//////////////////////////////////////////////////////////////////////////////////
// Company: ITESO
// Engineer: Jorge Alberto Padilla Gutierrez
// Module Description: RISC-V TestBench
//////////////////////////////////////////////////////////////////////////////////

`timescale 1ns / 1ps

import Control_Unit_enum::*;
module RISC_V_tb;

	//Wires
	reg                     clk;
    reg                     rst;
	reg [7:0]				gpio_port_in;
	wire [7:0]				gpio_port_out;
	//wire                    uart_tx_out;
    wire              		clk_out;
	cu_fsm_state_t          CU_State;
	
	//Instancia del DUT
	RISC_V_Multi_Cycle DUT(
		.clk(clk),
		.rst(rst),
        .clk_out(clk_out),
		.gpio_port_in(gpio_port_in),
		.gpio_port_out(gpio_port_out),
		//.uart_tx_out(uart_tx_out),
		.CU_State(CU_State)
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
		clk = 1'b0;
		rst = 1'b1;
		#1 rst = 1'b0;
		clk = 1'b1;
		#1 rst = 1'b1;
		clk = 1'b0;

		@(DUT.CORE.PCREG.Q == '0);
		@(DUT.CORE.PCREG.Q == '0);
		@(posedge clk);
		@(posedge clk);

		$finish();
	end

	initial forever #1 clk = ~clk;
endmodule