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
	wire                    uart_tx_out;
    wire [31:0]             mem_data;
	cu_fsm_state_t          CU_State;
	
	//Instancia del DUT
	RISC_V #(.DATA_WIDTH(32), .ADDR_WIDTH (32)) DUT(
		.clk(clk),
		.rst(rst),
        .mem_data(mem_data),
		.uart_tx_out(uart_tx_out),
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
		clk = 1'b0;
		rst = 1'b1;
		#1 rst = 1'b0;
		clk = 1'b1;
		#1 rst = 1'b1;
		clk = 1'b0;

		@(DUT.PCREG.Q == '0);
		@(DUT.PCREG.Q == '0);
		@(posedge clk);
		@(posedge clk);

		$finish();
	end

	initial forever #1 clk = ~clk;
endmodule