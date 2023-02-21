//////////////////////////////////////////////////////////////////////////////////
// Company: ITESO
// Engineer: Jorge Alberto Padilla Gutierrez
// Module Description: Simple sign extender
//////////////////////////////////////////////////////////////////////////////////

module Sign_Ext #(parameter IN_WIDTH = 16, parameter OUT_WIDTH = 32) (
	//Input
	input [IN_WIDTH-1:0]    In,
	//Output
	output [OUT_WIDTH-1:0]  Out
);

	//Assign the output as the signed extended version of the input
	assign Out = {{OUT_WIDTH-IN_WIDTH{In[IN_WIDTH-1]}},In};

endmodule