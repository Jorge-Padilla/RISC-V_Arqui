//////////////////////////////////////////////////////////////////////////////////
// Company: ITESO 
// Engineer: Jorge Alberto Padilla Gutiérrez
// Module Description: Pipeline Forwarding Unit
//////////////////////////////////////////////////////////////////////////////////

module Forwarding_Branch_Unit #(parameter DATA_WIDTH=5)(
	//Inputs
	input [DATA_WIDTH-1:0]	Rs1,
	input [DATA_WIDTH-1:0]	Rs2,
	input [DATA_WIDTH-1:0]	W_Rd_Mul,
	input                   Branch,
	input                   W_RegMul,
	
	input [DATA_WIDTH-1:0]	W_Rd,
	input [DATA_WIDTH-1:0]	M_Rd,
	input                   M_RegWrite,
	input                   W_RegWrite,

	//Output
	output reg  [1:0]       B_AForward,
	output reg  [1:0]       B_BForward
);

    //Forward Vectors
    reg bw_forward;
    reg mem_forward;
    reg wb_forward_alu;
    reg wb_forward_mul;

    assign mem_forward    = M_RegWrite && M_Rd != {DATA_WIDTH{1'b0}};
    assign wb_forward_alu = W_RegWrite && W_Rd != {DATA_WIDTH{1'b0}};
    assign wb_forward_mul = W_RegMul && W_Rd_Mul != {DATA_WIDTH{1'b0}};
    //assign bw_forward = W_RegMul && W_Rd_Mul != {DATA_WIDTH{1'b0}} && Branch;
    assign bw_forward = Branch && (wb_forward_alu | wb_forward_mul);

	//Combinational always block
	always @(*) begin
		//We take priority over the instruction on MEM
		if (mem_forward) begin
            if (M_Rd == Rs1)    B_AForward[0] = 1'b1;   else    B_AForward[0] = 1'b0;
            if (M_Rd == Rs2)    B_BForward[0] = 1'b1;   else    B_BForward[0] = 1'b0;
        //Forwarding Branch on the WB stage
        end else 
        if (bw_forward) begin
            if ( ((W_RegWrite && W_Rd == Rs1 && M_Rd != Rs1) || (W_RegMul && W_Rd_Mul == Rs1)) || (W_Rd_Mul == Rs1) ) B_AForward = 1'b1;  else    B_AForward[1] = 1'b0;
            if ( ((W_RegWrite && W_Rd == Rs2 && M_Rd != Rs2) || (W_RegMul && W_Rd_Mul == Rs2)) || (W_Rd_Mul == Rs2) ) B_BForward = 1'b1;  else    B_BForward[1] = 1'b0;
        end else begin
            B_AForward[1] = 1'b0;
            B_BForward[1] = 1'b0;
        end
    end

endmodule
