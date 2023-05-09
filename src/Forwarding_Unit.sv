//////////////////////////////////////////////////////////////////////////////////
// Company: ITESO 
// Engineer: Jorge Alberto Padilla Gutiérrez
// Module Description: Pipeline Forwarding Unit
//////////////////////////////////////////////////////////////////////////////////

module Forwarding_Unit #(parameter DATA_WIDTH=5)(
	//Inputs
	input [DATA_WIDTH-1:0]	Rs1,
	input [DATA_WIDTH-1:0]	Rs2,
	input [DATA_WIDTH-1:0]	M_Rd,
	input [DATA_WIDTH-1:0]	W_Rd,
	input                   M_RegWrite,
	input                   W_RegWrite,
	//Output
	output reg [1:0]        AForward,
	output reg [1:0]        BForward
);

	//Combinational always block
	always @(*) begin
        //We take priority over the instruction on MEM
        if (M_RegWrite && M_Rd != {DATA_WIDTH{1'b0}}) begin
            if (M_Rd == Rs1)    AForward[0] = 1'b1;   else    AForward[0] = 1'b0;
            if (M_Rd == Rs2)    BForward[0] = 1'b1;   else    BForward[0] = 1'b0;
        end else begin
            AForward[0] = 1'b0;
            BForward[0] = 1'b0;
        end
        //Forwarding on the WB stage
        if (W_RegWrite && W_Rd != {DATA_WIDTH{1'b0}}) begin
            if (W_Rd == Rs1 && M_Rd != Rs1)    AForward[1] = 1'b1;  else    AForward[1] = 1'b0;
            if (W_Rd == Rs2 && M_Rd != Rs2)    BForward[1] = 1'b1;  else    BForward[1] = 1'b0;
        end else begin
            AForward[1] = 1'b0;
            BForward[1] = 1'b0;
        end
    end

endmodule
