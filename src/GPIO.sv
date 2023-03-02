//////////////////////////////////////////////////////////////////////////////////
// Company: ITESO
// Engineer: Jorge Alberto Padilla Gutierrez
// Module Description: GPIO for the FPGA
//////////////////////////////////////////////////////////////////////////////////

`include "Regs.sv"

module GPIO  #(parameter DATA_WIDTH = 8) (
	//Inputs
	input                       clk,
	input                       en,
	input  [DATA_WIDTH-1:0]      GPIO_Data,
	input  [DATA_WIDTH-1:0]      GPIO_In,
	//Outputs
	output [DATA_WIDTH-1:0]      GPIO_toMem,
	output reg[DATA_WIDTH-1:0]   GPIO_Out
);

	//Assign the GPIO input to be directed to memory
    assign GPIO_toMem = GPIO_In;

    //Assign the GPIO Output from memory on enable
    `FF_D_RST_EN(clk, 1'b1, en, GPIO_Data, GPIO_Out)

endmodule