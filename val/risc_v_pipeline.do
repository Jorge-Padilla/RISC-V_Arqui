onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -divider {RISC-V I/O}
add wave -noupdate /RISC_V_Pipeline_UART_tb/DUT/clk
add wave -noupdate /RISC_V_Pipeline_UART_tb/DUT/rst
add wave -noupdate /RISC_V_Pipeline_UART_tb/DUT/gpio_port_in
add wave -noupdate /RISC_V_Pipeline_UART_tb/DUT/gpio_port_out
add wave -noupdate /RISC_V_Pipeline_UART_tb/DUT/rx
add wave -noupdate /RISC_V_Pipeline_UART_tb/DUT/tx
add wave -noupdate -divider FETCH
add wave -noupdate -color Cyan -itemcolor Cyan /RISC_V_Pipeline_UART_tb/DUT/CORE/PC
add wave -noupdate -color Gold -itemcolor Gold /RISC_V_Pipeline_UART_tb/DUT/CORE/InstrData
add wave -noupdate /RISC_V_Pipeline_UART_tb/DUT/CORE/F_PCEn
add wave -noupdate /RISC_V_Pipeline_UART_tb/DUT/CORE/M_PCSrc
add wave -noupdate /RISC_V_Pipeline_UART_tb/DUT/CORE/F_PCp4
add wave -noupdate /RISC_V_Pipeline_UART_tb/DUT/CORE/M_PCbra
add wave -noupdate /RISC_V_Pipeline_UART_tb/DUT/CORE/F_PCp
add wave -noupdate -divider DECODE
add wave -noupdate -color Cyan -itemcolor Cyan /RISC_V_Pipeline_UART_tb/DUT/CORE/D_PC
add wave -noupdate -color Gold -itemcolor Gold /RISC_V_Pipeline_UART_tb/DUT/CORE/D_InstrData
add wave -noupdate /RISC_V_Pipeline_UART_tb/DUT/CORE/D_PCEn
add wave -noupdate /RISC_V_Pipeline_UART_tb/DUT/CORE/D_PCWrite
add wave -noupdate /RISC_V_Pipeline_UART_tb/DUT/CORE/D_RegEn
add wave -noupdate /RISC_V_Pipeline_UART_tb/DUT/CORE/D_Stall
add wave -noupdate /RISC_V_Pipeline_UART_tb/DUT/CORE/D_MemWrite
add wave -noupdate /RISC_V_Pipeline_UART_tb/DUT/CORE/D_MemRead
add wave -noupdate /RISC_V_Pipeline_UART_tb/DUT/CORE/D_RegWrite
add wave -noupdate /RISC_V_Pipeline_UART_tb/DUT/CORE/D_Jump
add wave -noupdate /RISC_V_Pipeline_UART_tb/DUT/CORE/D_Branch
add wave -noupdate /RISC_V_Pipeline_UART_tb/DUT/CORE/D_XorZero
add wave -noupdate /RISC_V_Pipeline_UART_tb/DUT/CORE/D_MemtoReg
add wave -noupdate /RISC_V_Pipeline_UART_tb/DUT/CORE/D_JalrMux
add wave -noupdate /RISC_V_Pipeline_UART_tb/DUT/CORE/D_ALUSrcA
add wave -noupdate /RISC_V_Pipeline_UART_tb/DUT/CORE/D_ALUSrcB
add wave -noupdate /RISC_V_Pipeline_UART_tb/DUT/CORE/D_ShiftAmnt
add wave -noupdate /RISC_V_Pipeline_UART_tb/DUT/CORE/D_SignExt
add wave -noupdate /RISC_V_Pipeline_UART_tb/DUT/CORE/D_ALUControl
add wave -noupdate /RISC_V_Pipeline_UART_tb/DUT/CORE/D_MemWrite_H
add wave -noupdate /RISC_V_Pipeline_UART_tb/DUT/CORE/D_MemRead_H
add wave -noupdate /RISC_V_Pipeline_UART_tb/DUT/CORE/D_RegWrite_H
add wave -noupdate /RISC_V_Pipeline_UART_tb/DUT/CORE/D_Jump_H
add wave -noupdate /RISC_V_Pipeline_UART_tb/DUT/CORE/D_Branch_H
add wave -noupdate /RISC_V_Pipeline_UART_tb/DUT/CORE/D_XorZero_H
add wave -noupdate /RISC_V_Pipeline_UART_tb/DUT/CORE/D_MemtoReg_H
add wave -noupdate /RISC_V_Pipeline_UART_tb/DUT/CORE/D_JalrMux_H
add wave -noupdate /RISC_V_Pipeline_UART_tb/DUT/CORE/D_ALUSrcA_H
add wave -noupdate /RISC_V_Pipeline_UART_tb/DUT/CORE/D_ALUSrcB_H
add wave -noupdate /RISC_V_Pipeline_UART_tb/DUT/CORE/D_ShiftAmnt_H
add wave -noupdate /RISC_V_Pipeline_UART_tb/DUT/CORE/D_SignExt_H
add wave -noupdate /RISC_V_Pipeline_UART_tb/DUT/CORE/D_ALUControl_H
add wave -noupdate /RISC_V_Pipeline_UART_tb/DUT/CORE/D_RD1
add wave -noupdate /RISC_V_Pipeline_UART_tb/DUT/CORE/D_RD2
add wave -noupdate -divider EXECUTE
add wave -noupdate -color Cyan -itemcolor Cyan /RISC_V_Pipeline_UART_tb/DUT/CORE/E_PC
add wave -noupdate -color Gold -itemcolor Gold /RISC_V_Pipeline_UART_tb/DUT/CORE/E_InstrData
add wave -noupdate /RISC_V_Pipeline_UART_tb/DUT/CORE/E_MemWrite
add wave -noupdate /RISC_V_Pipeline_UART_tb/DUT/CORE/E_MemRead
add wave -noupdate /RISC_V_Pipeline_UART_tb/DUT/CORE/E_RegWrite
add wave -noupdate /RISC_V_Pipeline_UART_tb/DUT/CORE/E_Jump
add wave -noupdate /RISC_V_Pipeline_UART_tb/DUT/CORE/E_Branch
add wave -noupdate /RISC_V_Pipeline_UART_tb/DUT/CORE/E_XorZero
add wave -noupdate /RISC_V_Pipeline_UART_tb/DUT/CORE/E_MemtoReg
add wave -noupdate /RISC_V_Pipeline_UART_tb/DUT/CORE/E_MemWrite_H
add wave -noupdate /RISC_V_Pipeline_UART_tb/DUT/CORE/E_MemRead_H
add wave -noupdate /RISC_V_Pipeline_UART_tb/DUT/CORE/E_RegWrite_H
add wave -noupdate /RISC_V_Pipeline_UART_tb/DUT/CORE/E_Jump_H
add wave -noupdate /RISC_V_Pipeline_UART_tb/DUT/CORE/E_Branch_H
add wave -noupdate /RISC_V_Pipeline_UART_tb/DUT/CORE/E_XorZero_H
add wave -noupdate /RISC_V_Pipeline_UART_tb/DUT/CORE/E_MemtoReg_H
add wave -noupdate /RISC_V_Pipeline_UART_tb/DUT/CORE/E_JalrMux
add wave -noupdate /RISC_V_Pipeline_UART_tb/DUT/CORE/E_Zero
add wave -noupdate /RISC_V_Pipeline_UART_tb/DUT/CORE/E_AForward
add wave -noupdate /RISC_V_Pipeline_UART_tb/DUT/CORE/E_BForward
add wave -noupdate /RISC_V_Pipeline_UART_tb/DUT/CORE/W_RegWrite
add wave -noupdate /RISC_V_Pipeline_UART_tb/DUT/CORE/E_ALUSrcA
add wave -noupdate /RISC_V_Pipeline_UART_tb/DUT/CORE/E_ALUSrcB
add wave -noupdate /RISC_V_Pipeline_UART_tb/DUT/CORE/E_ShiftAmnt
add wave -noupdate /RISC_V_Pipeline_UART_tb/DUT/CORE/E_SignExt
add wave -noupdate /RISC_V_Pipeline_UART_tb/DUT/CORE/E_ALUControl
add wave -noupdate /RISC_V_Pipeline_UART_tb/DUT/CORE/E_RD1
add wave -noupdate /RISC_V_Pipeline_UART_tb/DUT/CORE/E_RD2
add wave -noupdate /RISC_V_Pipeline_UART_tb/DUT/CORE/W_WD3
add wave -noupdate /RISC_V_Pipeline_UART_tb/DUT/CORE/E_SignImm
add wave -noupdate /RISC_V_Pipeline_UART_tb/DUT/CORE/E_ShiftImm
add wave -noupdate /RISC_V_Pipeline_UART_tb/DUT/CORE/E_PCj
add wave -noupdate /RISC_V_Pipeline_UART_tb/DUT/CORE/E_PCbra
add wave -noupdate /RISC_V_Pipeline_UART_tb/DUT/CORE/E_RegA
add wave -noupdate /RISC_V_Pipeline_UART_tb/DUT/CORE/E_RegB
add wave -noupdate /RISC_V_Pipeline_UART_tb/DUT/CORE/E_SrcA
add wave -noupdate /RISC_V_Pipeline_UART_tb/DUT/CORE/E_SrcB
add wave -noupdate /RISC_V_Pipeline_UART_tb/DUT/CORE/E_ALUOut
add wave -noupdate -divider MEMORY
add wave -noupdate -color Gold -itemcolor Gold /RISC_V_Pipeline_UART_tb/DUT/CORE/M_InstrData
add wave -noupdate /RISC_V_Pipeline_UART_tb/DUT/CORE/M_RegWrite
add wave -noupdate /RISC_V_Pipeline_UART_tb/DUT/CORE/M_Jump
add wave -noupdate /RISC_V_Pipeline_UART_tb/DUT/CORE/M_Branch
add wave -noupdate /RISC_V_Pipeline_UART_tb/DUT/CORE/M_XorZero
add wave -noupdate /RISC_V_Pipeline_UART_tb/DUT/CORE/M_MemtoReg
add wave -noupdate /RISC_V_Pipeline_UART_tb/DUT/CORE/M_Zero
add wave -noupdate /RISC_V_Pipeline_UART_tb/DUT/CORE/M_PCSrc
add wave -noupdate /RISC_V_Pipeline_UART_tb/DUT/CORE/MemRead
add wave -noupdate /RISC_V_Pipeline_UART_tb/DUT/CORE/MemWrite
add wave -noupdate /RISC_V_Pipeline_UART_tb/DUT/CORE/M_PCbra
add wave -noupdate /RISC_V_Pipeline_UART_tb/DUT/CORE/MemData
add wave -noupdate /RISC_V_Pipeline_UART_tb/DUT/CORE/WriteData
add wave -noupdate /RISC_V_Pipeline_UART_tb/DUT/CORE/RWAddress
add wave -noupdate -divider WRITEBACK
add wave -noupdate -color Gold -itemcolor Gold /RISC_V_Pipeline_UART_tb/DUT/CORE/W_InstrData
add wave -noupdate /RISC_V_Pipeline_UART_tb/DUT/CORE/W_RegWrite
add wave -noupdate /RISC_V_Pipeline_UART_tb/DUT/CORE/W_MemtoReg
add wave -noupdate /RISC_V_Pipeline_UART_tb/DUT/CORE/W_MemData
add wave -noupdate /RISC_V_Pipeline_UART_tb/DUT/CORE/W_ALUOut
add wave -noupdate /RISC_V_Pipeline_UART_tb/DUT/CORE/W_WD3
add wave -noupdate -divider {ROM / RAM / Regs}
add wave -noupdate /RISC_V_Pipeline_UART_tb/DUT/CORE/MemData
add wave -noupdate /RISC_V_Pipeline_UART_tb/DUT/ROM/A
add wave -noupdate /RISC_V_Pipeline_UART_tb/DUT/ROM/RD
add wave -noupdate -expand /RISC_V_Pipeline_UART_tb/DUT/CORE/REGFILE/registers
add wave -noupdate /RISC_V_Pipeline_UART_tb/DUT/RAM/ram
add wave -noupdate -divider {Mem Controler}
add wave -noupdate /RISC_V_Pipeline_UART_tb/DUT/MM/re
add wave -noupdate /RISC_V_Pipeline_UART_tb/DUT/MM/we
add wave -noupdate /RISC_V_Pipeline_UART_tb/DUT/MM/WD
add wave -noupdate /RISC_V_Pipeline_UART_tb/DUT/MM/A
add wave -noupdate /RISC_V_Pipeline_UART_tb/DUT/MM/RD
add wave -noupdate /RISC_V_Pipeline_UART_tb/DUT/MM/data
add wave -noupdate /RISC_V_Pipeline_UART_tb/DUT/MM/mem
add wave -noupdate /RISC_V_Pipeline_UART_tb/DUT/MM/weRAM
add wave -noupdate /RISC_V_Pipeline_UART_tb/DUT/MM/ReadRAM
add wave -noupdate /RISC_V_Pipeline_UART_tb/DUT/MM/AddrRAM
add wave -noupdate /RISC_V_Pipeline_UART_tb/DUT/MM/DataRAM
add wave -noupdate /RISC_V_Pipeline_UART_tb/DUT/MM/gpio
add wave -noupdate /RISC_V_Pipeline_UART_tb/DUT/MM/weGPIO
add wave -noupdate /RISC_V_Pipeline_UART_tb/DUT/MM/ReadGPIO
add wave -noupdate /RISC_V_Pipeline_UART_tb/DUT/MM/DataGPIO
add wave -noupdate /RISC_V_Pipeline_UART_tb/DUT/MM/uart
add wave -noupdate /RISC_V_Pipeline_UART_tb/DUT/MM/in_save_data_bits_w
add wave -noupdate /RISC_V_Pipeline_UART_tb/DUT/MM/tx_fsm_in_STOP_S
add wave -noupdate /RISC_V_Pipeline_UART_tb/DUT/MM/ReadUART
add wave -noupdate /RISC_V_Pipeline_UART_tb/DUT/MM/Rx_Data
add wave -noupdate /RISC_V_Pipeline_UART_tb/DUT/MM/Tx_Data_w
add wave -noupdate /RISC_V_Pipeline_UART_tb/DUT/MM/rx_data
add wave -noupdate /RISC_V_Pipeline_UART_tb/DUT/MM/tx_send_en
add wave -noupdate /RISC_V_Pipeline_UART_tb/DUT/MM/tx_data_en
add wave -noupdate /RISC_V_Pipeline_UART_tb/DUT/MM/tx_send
add wave -noupdate /RISC_V_Pipeline_UART_tb/DUT/MM/rx_ready
add wave -noupdate /RISC_V_Pipeline_UART_tb/DUT/MM/tx_send_read
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {5993 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {0 ps} {18430 ps}
