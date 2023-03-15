//////////////////////////////////////////////////////////////////////////////////
// Company: ITESO
// Engineer: Jorge Alberto Padilla Gutierrez
// Module Description: RISC-V Control Unit Enum
//////////////////////////////////////////////////////////////////////////////////

package Control_Unit_enum;

typedef enum logic [3:0] {
	FETCH,
	DECODE,
	MEM_ADDR,
	MEM_READ,
	MEM_WRBACK,
	MEM_WRITE,
	REG_EXE,
	REG_WRBACK,
	BRANCH,
	IMMI_EXE,
	IMMI_WRBACK,
	JUMP,
	STALL
} cu_fsm_state_t;

endpackage