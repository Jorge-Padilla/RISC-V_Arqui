//////////////////////////////////////////////////////////////////////////////////
//  Company: ITESO
//  Engineer: Jorge Alberto Padilla Gutierrez
//  Module Description: Finite State Machine to send a 32bit word on the UART
////////////////////////////////////////////////////////////////////////////////////

import UART_pkg::*;

module UART_Word_FSM(
    //Inputs
    input               clk,
    input               rst,
    input               start_fsm,
    input               tx_fsm_in_STOP_S,
    input [1:0]         Counter,
    //Outputs
    output reg          rst_send_en,
    output reg          rst_counter,
    output reg          tx_send,
    output reg          tx_send_en,
    output reg          tx_data_en,
    output word_state_t Word_state_out
);

    word_state_t word_state;

    assign Word_state_out = word_state;

    always @(posedge clk, negedge rst) begin
        if (~rst) 
            word_state <= INIT_W;
        else 
            case (word_state)
                INIT_W: 
                    word_state <= (start_fsm) ? SEND_W : INIT_W;
                SEND_W:
                    word_state <= WAIT_W;
                WAIT_W:
                    if(tx_fsm_in_STOP_S)
                        word_state <= (Counter === 2'b00) ? FINISH_W : SEND_W;
                    else
                        word_state <= WAIT_W;
                FINISH_W:
                    word_state <= INIT_W;
                default:
                    word_state <= INIT_W;
            endcase
    end

    //OUTPUT DEFINITION
    always @(word_state) begin
        case(word_state)
            INIT_W: begin
                rst_send_en = 1'b1;
                rst_counter = 1'b0;
                tx_send     = 1'b0;
                tx_send_en  = 1'b0;
                tx_data_en  = 1'b0;
            end
            SEND_W: begin
                rst_send_en = 1'b1;
                rst_counter = 1'b1;
                tx_send     = 1'b1;
                tx_send_en  = 1'b1;
                tx_data_en  = 1'b1;
                
            end
            WAIT_W: begin
                rst_send_en = 1'b1;
                rst_counter = 1'b1;
                tx_send     = 1'b0;
                tx_send_en  = 1'b0;
                tx_data_en  = 1'b0;
                
            end
            FINISH_W: begin
                rst_send_en = 1'b0;
                rst_counter = 1'b1;
                tx_send     = 1'b0;
                tx_send_en  = 1'b0;
                tx_data_en  = 1'b0;
                
            end
            default: begin
                rst_send_en = 1'b1;
                rst_counter = 1'b1;
                tx_send     = 1'b0;
                tx_send_en  = 1'b0;
                tx_data_en  = 1'b0;
            end
        endcase
    end

endmodule
