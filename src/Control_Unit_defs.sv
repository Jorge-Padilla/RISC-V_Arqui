//////////////////////////////////////////////////////////////////////////////////
// Company: ITESO
// Engineer: Jorge Alberto Padilla Gutierrez
// Module Description: RISC-V Control Unit Defines
//////////////////////////////////////////////////////////////////////////////////

`define OPCODE_REG		7'b0110011
`define OPCODE_IMMI		7'b0010011
`define OPCODE_LOAD		7'b0000011
`define OPCODE_STORE	7'b0100011
`define OPCODE_BRANCH	7'b1100011
`define OPCODE_JAL		7'b1101111
`define OPCODE_JALR		7'b1100111
`define OPCODE_LUI		7'b0110111
`define OPCODE_AUIPC	7'b0010111
`define OPCODE_UART		7'b1111111
`define OPCODE_STALL	7'b0000000

`define BRANCH_EQ	3'b000
`define BRANCH_NE	3'b001
`define BRANCH_LT	3'b100
`define BRANCH_GTE	3'b101
`define BRANCH_LTU	3'b110
`define BRANCH_GTEU	3'b111

`define BRANCH_EQ_NEQ	2'b00
`define BRANCH_LT_GTE	2'b10
`define BRANCH_LTU_GTEU	2'b11

`define FUNCT_SHIFT_LEFT	3'b001
`define FUNCT_SHIFT_RIGHT	3'b101

`define EXT_JAL		3'b101
`define EXT_JALR	3'b000
`define EXT_BRA		3'b011
`define EXT_LOAD	3'b000
`define EXT_STORE	3'b001
`define EXT_IMMI	3'b000

`define SHIFT_0	2'b00
`define SHIFT_1	2'b01
`define SHIFT_2	2'b10
`define SHIFT_C	2'b11
