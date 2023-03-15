//////////////////////////////////////////////////////////////////////////////////
//  Company: ITESO
//  Engineer: Jorge Alberto Padilla Gutierrez
//  Module Description: Parametric Right Shift Register
//////////////////////////////////////////////////////////////////////////////////

module Shift_Register_R_Param #(parameter DATA_WIDTH = 9) (
    //Inputs
    input                   clk,
    input                   rst,
    input                   enable,
    input                   d,
    //Outputs
    output reg [DATA_WIDTH-1:0]  Q
);

    always @(posedge clk, negedge rst) begin
        if (~rst)
            Q <= {DATA_WIDTH{1'b0}};
        else
            if (enable)
                Q <= {d,Q[DATA_WIDTH-1:1]};
    end

endmodule
