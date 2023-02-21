//////////////////////////////////////////////////////////////////////////////////
// Company: ITESO
// Engineer: Jorge Alberto Padilla Gutierrez
// Module Description: RISC-V ALU Testbench
//////////////////////////////////////////////////////////////////////////////////

module ALU_tb;
	//DUT variables
	reg[31:0]   a_tb;
    reg[31:0]   b_tb;
	reg[4:0]    sel_tb;
	wire[31:0]  f_tb;
	wire        z_tb;
	
	//DUT Instance
	ALU DUT(
		.a(a_tb), .b(b_tb), .sel(sel_tb), .f(f_tb), .z(z_tb)
	);
	
	reg[4:0] stimulus;
	
	initial
		begin
	
		$dumpfile("dump.vcd");
		$dumpvars(1);
		
		a_tb = 32'h0000000F;
		b_tb = 32'h00000003;
		
		for(stimulus = 0; stimulus < 8; stimulus = stimulus + 1)
		begin
			sel_tb = stimulus;
			#1;
		end
			
        sel_tb = 5'b10000;
		#1;
        sel_tb = 5'b10101;
		#1;
        sel_tb = 5'b01000;
		#1;
		
		a_tb = 32'hF000000F;
		b_tb = 32'h00000003;
		
		for(stimulus = 0; stimulus < 8; stimulus = stimulus + 1)
		begin
			sel_tb = stimulus;
			#1;
		end
			
        sel_tb = 5'b10000;
		#1;
        sel_tb = 5'b10101;
		#1;
        sel_tb = 5'b01000;
		#1;
		
		a_tb = 32'h01234567;
		b_tb = 32'h89ABCDEF;
		
		for(stimulus = 0; stimulus < 8; stimulus = stimulus + 1)
		begin
			sel_tb = stimulus;
			#1;
		end
			
        sel_tb = 5'b10000;
		#1;
        sel_tb = 5'b10101;
		#1;
        sel_tb = 5'b01000;
		#1;
		
		a_tb = 32'h00000000;
		b_tb = 32'h00000000;
		
		for(stimulus = 0; stimulus < 8; stimulus = stimulus + 1)
		begin
			sel_tb = stimulus;
			#1;
		end
			
        sel_tb = 5'b10000;
		#1;
        sel_tb = 5'b10101;
		#1;
        sel_tb = 5'b01000;
		#1;
		
		a_tb = 32'hFFFFFFFF;
		b_tb = 32'hFFFFFFFF;
		
		for(stimulus = 0; stimulus < 8; stimulus = stimulus + 1)
		begin
			sel_tb = stimulus;
			#1;
		end

        sel_tb = 5'b10000;
		#1;
        sel_tb = 5'b10101;
		#1;
        sel_tb = 5'b01000;
		#1;
		
		$finish;
		end
endmodule