//////////////////////////////////////////////////////////////////////////////////
// Company: ITESO
// Engineer: Jorge Alberto Padilla Gutierrez
// Module Description: Shift defines
//////////////////////////////////////////////////////////////////////////////////

`define shift_0(A, B)\
    assign B = A << 0;
`define shift_1(A, B)\
    assign B = A << 1;
`define shift_2(A, B)\
    assign B = A << 2;
`define shift_C(A, B)\
    assign B = A << 12;
