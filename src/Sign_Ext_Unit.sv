//////////////////////////////////////////////////////////////////////////////////
// Company: ITESO
// Engineer: Jorge Alberto Padilla Gutierrez
// Module Description: Simple sign extender unit
//////////////////////////////////////////////////////////////////////////////////

module Sign_Ext_Unit #(parameter IN_WIDTH_1 = 12, parameter IN_WIDTH_2 = 20, parameter OUT_WIDTH = 32) (
	//Input
	input [IN_WIDTH_1-1:0]	In_12_I,
	input [IN_WIDTH_1-1:0]	In_12_S,
	input [IN_WIDTH_1-1:0]	In_12_B,
	input [IN_WIDTH_2-1:0]	In_20_U,
	input [IN_WIDTH_2-1:0]	In_20_J,
	input [2:0]				sel,
	//Output
	output [OUT_WIDTH-1:0]	Out
);

    //Wires for selected inputs
    wire[OUT_WIDTH-1:0] In_12;
    wire[OUT_WIDTH-1:0] In_20;

	//Selector of Instruction Format
    Mux_4_1 #(.DATA_WIDTH(IN_WIDTH_1)) MUX12 (
        .A(In_12_I),
        .B(In_12_S),
        .C({IN_WIDTH_1{1'b1}}),
        .D(In_12_B),
        .sel(sel[1:0]),
        .Q(In_12)
    );

	Mux_2_1 #(.DATA_WIDTH(IN_WIDTH_2)) MUX20 (
        .A(In_20_U),
        .B(In_20_J),
        .sel(sel[0]),
        .Q(In_20)
    );

    //Wires for sign extended values
    wire[OUT_WIDTH-1:0] In_0;
    wire[OUT_WIDTH-1:0] In_1;

	//Assign the output as the selected sign extended value
	Sign_Ext #(.IN_WIDTH(IN_WIDTH_1), .OUT_WIDTH(OUT_WIDTH)) SE12 (
		.In(In_12),
		.Out(In_0)
	);

	Sign_Ext #(.IN_WIDTH(IN_WIDTH_2), .OUT_WIDTH(OUT_WIDTH)) SE20 (
		.In(In_20),
		.Out(In_1)
	);

	Mux_2_1 #(.DATA_WIDTH(OUT_WIDTH)) MUX (
        .A(In_0),
        .B(In_1),
        .sel(sel[2]),
        .Q(Out)
    );

endmodule