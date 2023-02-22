//////////////////////////////////////////////////////////////////////////////////
// Company: ITESO
// Engineer: Jorge Alberto Padilla Gutierrez
// Module Description: Single port ROM with single read address 
//////////////////////////////////////////////////////////////////////////////////

module ROM_Single_Port #(parameter DATA_WIDTH = 32, parameter ADDR_WIDTH = 10) (
	//Inputs
	input [(ADDR_WIDTH-1):0]    A,
	//Output
	output [(DATA_WIDTH-1):0]   RD
);

	//Declare the ROM array
	reg [DATA_WIDTH-1:0] rom [2**ADDR_WIDTH-1:0];
	
	//Initial MEM Values
	initial begin
		$readmemh("RISC_V_program.txt", rom);
	end
	
	//Reading continuously
	assign RD = rom[A];

endmodule
