//////////////////////////////////////////////////////////////////////////////////
// Company: ITESO 
// Engineer: Jorge Alberto Padilla Gutiérrez
// Module Description: Pipeline Hazard Detection Unit
//////////////////////////////////////////////////////////////////////////////////

module Hazard_Detection_Unit #(parameter DATA_WIDTH=5)(
	//Inputs
	input [DATA_WIDTH-1:0]	Rs1,
	input [DATA_WIDTH-1:0]	Rs2,
	input [DATA_WIDTH-1:0]	E_Rd,
	input                   E_MemRead,
	//Output
    output reg              PCWrite,
    output reg              IDWrite,
	output reg              Stall
);

	//Combinational always block
	always @(*) begin
        //We detect a hazard on a lw instruction
        if (E_MemRead && E_Rd != {DATA_WIDTH{1'b0}} && (E_Rd == Rs1 || E_Rd == Rs2)) begin
            PCWrite = 1'b0;
            IDWrite = 1'b0;
            Stall   = 1'b1;
        end else begin
            PCWrite = 1'b1;
            IDWrite = 1'b1;
            Stall   = 1'b0;
        end
    end

endmodule
