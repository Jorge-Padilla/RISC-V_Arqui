//////////////////////////////////////////////////////////////////////////////////
//  Company: ITESO
//  Engineer: Jorge Alberto Padilla Gutierrez
//  Module Description: Definition of a Counter, that converts clock signals
//////////////////////////////////////////////////////////////////////////////////

module Counter_Param #(parameter MAX_COUNT = 2, parameter NUM_BITS = $clog2(MAX_COUNT)) (
    //Inputs
    input                       clk,
    input                       en,
    input                       rst,
    //Outputs
    output                      max_cnt_hit,
    output reg[NUM_BITS-1:0]    cnt = 'h0
);

    assign max_cnt_hit = ((cnt == (MAX_COUNT - 1'b1)) & en);
    
    always @(posedge clk, negedge rst) begin
        if (~rst)
            cnt <= 'h0;
        else
            if (en)
                if (cnt == (MAX_COUNT - 1))
                    cnt <= 'h0;                
                else
                    cnt <= cnt + 1'b1;
    end

endmodule
