//////////////////////////////////////////////////////////////////////////////////
// Company: ITESO
// Engineer: Jorge Alberto Padilla Gutierrez
// Module Description: Simple shift Unit for 0, 1, 2 and 12 bit shift
//////////////////////////////////////////////////////////////////////////////////

`include "Shifts.sv"

module Shift_Unit #(parameter DATA_WIDTH = 32) (
	//Input
	input [DATA_WIDTH-1:0]  In,
    input [1:0]             sel,
	//Output
	output [DATA_WIDTH-1:0] Out
);

    //Wires for shifted values
    wire[DATA_WIDTH-1:0] In_0;
    wire[DATA_WIDTH-1:0] In_1;
    wire[DATA_WIDTH-1:0] In_2;
    wire[DATA_WIDTH-1:0] In_C;
    
	//Assign the shifted values
	`shift_0(In, In_0)
	`shift_1(In, In_1)
	`shift_2(In, In_2)
	`shift_C(In, In_C)

    Mux_4_1 #(.DATA_WIDTH(DATA_WIDTH)) MUX (
        .A(In_0),
        .B(In_1),
        .C(In_2),
        .D(In_C),
        .sel(sel),
        .Q(Out)
    );

endmodule