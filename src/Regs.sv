//////////////////////////////////////////////////////////////////////////////////
// Company: ITESO 
// Engineer: Jorge Alberto Padilla Gutiérrez
// Module Description: Register Macros
//////////////////////////////////////////////////////////////////////////////////

`define FF_D_RST_EN(clk, rst, en, D, Q)\
    always @(posedge clk, negedge rst) begin \
        if (~rst) \
            Q <= 'h0;\
        else if (en)\
            Q <= D;\
		end

`define PC_FF_D_RST_EN(clk, rst, en, D, Q)\
    always @(posedge clk, negedge rst) begin \
        if (~rst) \
            Q <= 32'h400000;\
        else if (en)\
            Q <= D;\
		end