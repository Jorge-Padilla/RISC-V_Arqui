//////////////////////////////////////////////////////////////////////////////////
// Company: ITESO 
// Engineer: Jorge Alberto Padilla Gutiérrez
// Testbench of the Functional model of a parametric register
// with asynchronous reset.
//////////////////////////////////////////////////////////////////////////////////

`timescale 1 ns / 10 ps

module Reg_File_tb ();

	//Parameter for the DUT
	localparam ADDRESS_WIDTH    = 5;
	localparam DATA_WIDTH       = 32;
	
	//DUT Signals
    reg                     clk_tb;
    reg                     we3_tb;
	reg [ADDRESS_WIDTH-1:0] a1_tb;
    reg [ADDRESS_WIDTH-1:0] a2_tb;
    reg [ADDRESS_WIDTH-1:0] a3_tb;
	reg [DATA_WIDTH-1:0]    wd3_tb;
	wire [DATA_WIDTH-1:0]   rd1_tb;
    wire [DATA_WIDTH-1:0]   rd2_tb;

	//DUT Instance
	Reg_File #(.ADDRESS_WIDTH(ADDRESS_WIDTH), .DATA_WIDTH(DATA_WIDTH)) DUT (
	    .clk(clk_tb),
	    .we3(we3_tb),
	    .a1(a1_tb),
        .a2(a2_tb),
        .a3(a3_tb),
	    .wd3(wd3_tb),
	    .rd1(rd1_tb),
        .rd2(rd2_tb)
    );

	//Initial values
	initial begin
		clk_tb = 1'b0;
		we3_tb = 1'b1;
		a1_tb  = {ADDRESS_WIDTH{1'b1}};
		a2_tb  = {ADDRESS_WIDTH{1'b0}};
		a3_tb  = {ADDRESS_WIDTH{1'b0}};
		wd3_tb = {DATA_WIDTH{1'b1}};
	end

	//Clock signal
	always begin
		#1 clk_tb = ~ clk_tb;
	end    

	//Data modification
	always begin
		#1 wd3_tb = wd3_tb + 1'b1;
	end
    
	always begin
		#2 a1_tb = a1_tb + 1'b1;
		   a2_tb = a2_tb + 1'b1;
		   a3_tb = a3_tb + 1'b1;
	end   

	//Toggle Write Enable
	always begin
		#5 we3_tb = ~ we3_tb;
	end
		 
endmodule
