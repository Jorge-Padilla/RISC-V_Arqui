//////////////////////////////////////////////////////////////////////////////////
//  Company: ITESO
//  Engineer: Jorge Alberto Padilla Gutierrez
//  Module Description: UART typedef
////////////////////////////////////////////////////////////////////////////////////

package UART_pkg;

    typedef enum logic [2:0] {
        INIT,
        START_BIT,
        DATA_BITS,
        SAMPLE_DATA_BIT,
        WAIT_DATA_BIT_END,
        STOP_BIT,
        SAVE_DATA_BITS
    } rx_state_t;

    typedef enum logic [2:0] {
        INI_S,
        SEND_S,
        START_S,
        tx_BITS_S,
        SHIFT_S,
        STOP_S
    } tx_state_t;

    typedef enum logic [1:0] {
        INIT_W,
        SEND_W,
        WAIT_W,
        FINISH_W
    } word_state_t;

endpackage