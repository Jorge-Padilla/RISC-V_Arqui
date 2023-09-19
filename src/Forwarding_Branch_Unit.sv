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
	//Output
	output reg              B_AForward,
	output reg              B_BForward
);

    //Forward Vectors
    reg bw_forward;

    assign bw_forward = W_RegMul && W_Rd_Mul != {DATA_WIDTH{1'b0}} && Branch;

	//Combinational always block
	always @(*) begin
        //Forwarding Branch on the WB stage
        if (bw_forward) begin
            if (W_Rd_Mul == Rs1)    B_AForward = 1'b1;  else    B_AForward = 1'b0;
            if (W_Rd_Mul == Rs2)    B_BForward = 1'b1;  else    B_BForward = 1'b0;
        end else begin
            B_AForward = 1'b0;
            B_BForward = 1'b0;
        end
    end

endmodule
