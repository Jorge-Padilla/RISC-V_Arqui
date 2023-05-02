//////////////////////////////////////////////////////////////////////////////////
// Company: ITESO 
// Engineer: Jorge Alberto Padilla Gutiérrez
// Module Description: Pipeline Forwarding Unit
//////////////////////////////////////////////////////////////////////////////////

module Forwarding_Unit_Decode #(parameter DATA_WIDTH=5)(
	//Inputs
	input [DATA_WIDTH-1:0]	Rs1,
	input [DATA_WIDTH-1:0]	Rs2,
	input [DATA_WIDTH-1:0]	W_Rd,
	input                   W_RegWrite,
	//Output
	output reg              AForward,
	output reg              BForward
);

	//Combinational always block
	always @(*) begin
        //Special case for race condition
        if (W_RegWrite && W_Rd != {DATA_WIDTH{1'b0}}) begin
            if (W_Rd == Rs1)    AForward = 1'b1;    else    AForward = 1'b0;
            if (W_Rd == Rs2)    BForward = 1'b1;    else    BForward = 1'b0;
        end else begin
            AForward = 1'b0;
            BForward = 1'b0;
        end
    end

endmodule
