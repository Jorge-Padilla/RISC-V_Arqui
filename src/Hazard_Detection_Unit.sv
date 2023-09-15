//////////////////////////////////////////////////////////////////////////////////
// Company: ITESO 
// Engineer: Jorge Alberto Padilla Gutiérrez
// Module Description: Pipeline Hazard Detection Unit
//////////////////////////////////////////////////////////////////////////////////

module Hazard_Detection_Unit #(parameter DATA_WIDTH=5)(
	//Inputs
	input [DATA_WIDTH-1:0]	Rs1,
	input [DATA_WIDTH-1:0]	Rs2,
	input [DATA_WIDTH-1:0]	Rd,
	input [DATA_WIDTH-1:0]	E_Rd,
	input [DATA_WIDTH-1:0]	P1_Rd,
	input [DATA_WIDTH-1:0]	P2_Rd,
    input                   RegWrite,
	input                   E_MemRead,
	input                   P0_RegMul,
	input                   P1_RegMul,
	input                   P2_RegMul,
	//Output
    output reg              PCWrite,
    output reg              IDWrite,
	output reg              Stall
);

    //Hazard Vectors
    reg load_stall;
    reg mult_stall;
    reg muwb_stall;
    reg mooo_stall;
    reg mult_stall_0;
    reg mult_stall_1;
    reg mult_stall_2;

    assign load_stall = E_MemRead && E_Rd != {DATA_WIDTH{1'b0}} && (E_Rd == Rs1 || E_Rd == Rs2);
    assign mult_stall_0 = P0_RegMul && E_Rd != {DATA_WIDTH{1'b0}} && (E_Rd == Rs1 || E_Rd == Rs2);
    assign mult_stall_1 = P1_RegMul && P1_Rd != {DATA_WIDTH{1'b0}} && (P1_Rd == Rs1 || P1_Rd == Rs2);
    assign mult_stall_2 = P2_RegMul && P2_Rd != {DATA_WIDTH{1'b0}} && (P2_Rd == Rs1 || P2_Rd == Rs2);
    assign mult_stall = mult_stall_0 | mult_stall_1 | mult_stall_2;
    assign muwb_stall = RegWrite & P1_RegMul;
    assign mooo_stall = RegWrite && Rd != {DATA_WIDTH{1'b0}} && ((Rd == E_Rd && P0_RegMul) || (Rd == P1_Rd && P1_RegMul));

	//Combinational always block
	always @(*) begin
        //We detect a hazard on a lw instruction
        if (load_stall | mult_stall | muwb_stall | mooo_stall) begin
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
