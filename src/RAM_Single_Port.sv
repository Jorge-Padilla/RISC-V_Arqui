//////////////////////////////////////////////////////////////////////////////////
// Company: ITESO
// Engineer: Jorge Alberto Padilla Gutierrez
// Module Description: Single port RAM with single read/write address 
//////////////////////////////////////////////////////////////////////////////////

module RAM_Single_Port #(parameter DATA_WIDTH = 32, parameter ADDR_WIDTH = 10) (
	//Inputs
	input [(DATA_WIDTH-1):0]    WD,
	input [(ADDR_WIDTH-1):0]    A,
	input                       we,
    input                       clk,
	//Output
	output [(DATA_WIDTH-1):0]   RD
);

	//Declare the RAM array
	reg [DATA_WIDTH-1:0] ram [2**ADDR_WIDTH-1:0];
	
	//Initial MEM Values
	initial begin
		//$readmemh("RISC_V_mem.txt", ram);
		$readmemh("RISC_V_data_arqui_testmul.txt", ram);
	end

	always @ (posedge clk) begin
		//Write
		if (we)
			ram[A] <= WD;
	end
	
	//Reading continuously
	assign RD = ram[A];

endmodule
