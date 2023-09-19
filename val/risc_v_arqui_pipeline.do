onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -divider {RISC-V I/O}
add wave -noupdate /RISC_V_Pipeline_rst_tb/DUT/clk
add wave -noupdate /RISC_V_Pipeline_rst_tb/DUT/rst
add wave -noupdate /RISC_V_Pipeline_rst_tb/DUT/gpio_port_in
add wave -noupdate /RISC_V_Pipeline_rst_tb/DUT/gpio_port_out
add wave -noupdate /RISC_V_Pipeline_rst_tb/DUT/rx
add wave -noupdate /RISC_V_Pipeline_rst_tb/DUT/tx
add wave -noupdate /RISC_V_Pipeline_rst_tb/Rx_state_out
add wave -noupdate /RISC_V_Pipeline_rst_tb/Tx_state_out
add wave -noupdate -divider FETCH
add wave -noupdate -color Cyan -itemcolor Cyan /RISC_V_Pipeline_rst_tb/DUT/CORE/PC
add wave -noupdate -color Gold -itemcolor Gold /RISC_V_Pipeline_rst_tb/DUT/CORE/InstrData
add wave -noupdate /RISC_V_Pipeline_rst_tb/DUT/CORE/F_PCEn
add wave -noupdate /RISC_V_Pipeline_rst_tb/DUT/CORE/D_B_PCSrc
add wave -noupdate /RISC_V_Pipeline_rst_tb/DUT/CORE/F_PCp4
add wave -noupdate /RISC_V_Pipeline_rst_tb/DUT/CORE/D_B_PCbra
add wave -noupdate /RISC_V_Pipeline_rst_tb/DUT/CORE/F_PCp
add wave -noupdate -divider DECODE
add wave -noupdate -color Cyan -itemcolor Cyan /RISC_V_Pipeline_rst_tb/DUT/CORE/D_PC
add wave -noupdate -color Gold -itemcolor Gold /RISC_V_Pipeline_rst_tb/DUT/CORE/D_InstrData
add wave -noupdate /RISC_V_Pipeline_rst_tb/DUT/CORE/D_PCEn
add wave -noupdate /RISC_V_Pipeline_rst_tb/DUT/CORE/D_PCWrite
add wave -noupdate /RISC_V_Pipeline_rst_tb/DUT/CORE/D_RegEn
add wave -noupdate /RISC_V_Pipeline_rst_tb/DUT/CORE/D_Stall
add wave -noupdate /RISC_V_Pipeline_rst_tb/DUT/CORE/D_MemWrite
add wave -noupdate /RISC_V_Pipeline_rst_tb/DUT/CORE/D_MemRead
add wave -noupdate /RISC_V_Pipeline_rst_tb/DUT/CORE/D_RegWrite
add wave -noupdate /RISC_V_Pipeline_rst_tb/DUT/CORE/D_RegMul
add wave -noupdate /RISC_V_Pipeline_rst_tb/DUT/CORE/D_Jump
add wave -noupdate /RISC_V_Pipeline_rst_tb/DUT/CORE/D_Branch
add wave -noupdate /RISC_V_Pipeline_rst_tb/DUT/CORE/D_XorZero
add wave -noupdate /RISC_V_Pipeline_rst_tb/DUT/CORE/D_MemtoReg
add wave -noupdate /RISC_V_Pipeline_rst_tb/DUT/CORE/D_JalrMux
add wave -noupdate /RISC_V_Pipeline_rst_tb/DUT/CORE/D_ALUSrcA
add wave -noupdate /RISC_V_Pipeline_rst_tb/DUT/CORE/D_ALUSrcB
add wave -noupdate /RISC_V_Pipeline_rst_tb/DUT/CORE/D_ShiftAmnt
add wave -noupdate /RISC_V_Pipeline_rst_tb/DUT/CORE/D_SignExt
add wave -noupdate /RISC_V_Pipeline_rst_tb/DUT/CORE/D_ALUControl
add wave -noupdate /RISC_V_Pipeline_rst_tb/DUT/CORE/D_MemWrite_H
add wave -noupdate /RISC_V_Pipeline_rst_tb/DUT/CORE/D_MemRead_H
add wave -noupdate /RISC_V_Pipeline_rst_tb/DUT/CORE/D_RegWrite_H
add wave -noupdate /RISC_V_Pipeline_rst_tb/DUT/CORE/D_RegMul_H
add wave -noupdate /RISC_V_Pipeline_rst_tb/DUT/CORE/D_Jump_H
add wave -noupdate /RISC_V_Pipeline_rst_tb/DUT/CORE/D_Branch_H
add wave -noupdate /RISC_V_Pipeline_rst_tb/DUT/CORE/D_XorZero_H
add wave -noupdate /RISC_V_Pipeline_rst_tb/DUT/CORE/D_MemtoReg_H
add wave -noupdate /RISC_V_Pipeline_rst_tb/DUT/CORE/D_JalrMux_H
add wave -noupdate /RISC_V_Pipeline_rst_tb/DUT/CORE/D_ALUSrcA_H
add wave -noupdate /RISC_V_Pipeline_rst_tb/DUT/CORE/D_ALUSrcB_H
add wave -noupdate /RISC_V_Pipeline_rst_tb/DUT/CORE/D_ShiftAmnt_H
add wave -noupdate /RISC_V_Pipeline_rst_tb/DUT/CORE/D_SignExt_H
add wave -noupdate /RISC_V_Pipeline_rst_tb/DUT/CORE/D_ALUControl_H
add wave -noupdate /RISC_V_Pipeline_rst_tb/DUT/CORE/D_RD1
add wave -noupdate /RISC_V_Pipeline_rst_tb/DUT/CORE/D_RD2
add wave -noupdate /RISC_V_Pipeline_rst_tb/DUT/CORE/D_WD
add wave -noupdate -divider BRANCH
add wave -noupdate /RISC_V_Pipeline_rst_tb/DUT/CORE/D_B_SignExt
add wave -noupdate /RISC_V_Pipeline_rst_tb/DUT/CORE/D_B_Data_SE
add wave -noupdate /RISC_V_Pipeline_rst_tb/DUT/CORE/D_B_ShiftImm
add wave -noupdate /RISC_V_Pipeline_rst_tb/DUT/CORE/D_B_PCj
add wave -noupdate /RISC_V_Pipeline_rst_tb/DUT/CORE/D_B_PCbra
add wave -noupdate /RISC_V_Pipeline_rst_tb/DUT/CORE/D_B_PCSrc
add wave -noupdate -divider EXECUTE
add wave -noupdate -color Cyan -itemcolor Cyan /RISC_V_Pipeline_rst_tb/DUT/CORE/E_PC
add wave -noupdate -color Gold -itemcolor Gold /RISC_V_Pipeline_rst_tb/DUT/CORE/E_InstrData
add wave -noupdate /RISC_V_Pipeline_rst_tb/DUT/CORE/E_MemWrite
add wave -noupdate /RISC_V_Pipeline_rst_tb/DUT/CORE/E_MemRead
add wave -noupdate /RISC_V_Pipeline_rst_tb/DUT/CORE/E_RegWrite
add wave -noupdate /RISC_V_Pipeline_rst_tb/DUT/CORE/E_Jump
add wave -noupdate /RISC_V_Pipeline_rst_tb/DUT/CORE/E_Branch
add wave -noupdate /RISC_V_Pipeline_rst_tb/DUT/CORE/E_XorZero
add wave -noupdate /RISC_V_Pipeline_rst_tb/DUT/CORE/E_MemtoReg
add wave -noupdate /RISC_V_Pipeline_rst_tb/DUT/CORE/E_MemWrite_H
add wave -noupdate /RISC_V_Pipeline_rst_tb/DUT/CORE/E_MemRead_H
add wave -noupdate /RISC_V_Pipeline_rst_tb/DUT/CORE/E_RegWrite_H
add wave -noupdate /RISC_V_Pipeline_rst_tb/DUT/CORE/E_RegMul
add wave -noupdate /RISC_V_Pipeline_rst_tb/DUT/CORE/E_Jump_H
add wave -noupdate /RISC_V_Pipeline_rst_tb/DUT/CORE/E_Branch_H
add wave -noupdate /RISC_V_Pipeline_rst_tb/DUT/CORE/E_XorZero_H
add wave -noupdate /RISC_V_Pipeline_rst_tb/DUT/CORE/E_MemtoReg_H
add wave -noupdate /RISC_V_Pipeline_rst_tb/DUT/CORE/E_JalrMux
add wave -noupdate /RISC_V_Pipeline_rst_tb/DUT/CORE/E_Zero
add wave -noupdate /RISC_V_Pipeline_rst_tb/DUT/CORE/E_AForward
add wave -noupdate /RISC_V_Pipeline_rst_tb/DUT/CORE/E_BForward
add wave -noupdate /RISC_V_Pipeline_rst_tb/DUT/CORE/W_RegWrite
add wave -noupdate /RISC_V_Pipeline_rst_tb/DUT/CORE/E_ALUSrcA
add wave -noupdate /RISC_V_Pipeline_rst_tb/DUT/CORE/E_ALUSrcB
add wave -noupdate /RISC_V_Pipeline_rst_tb/DUT/CORE/E_ShiftAmnt
add wave -noupdate /RISC_V_Pipeline_rst_tb/DUT/CORE/E_SignExt
add wave -noupdate /RISC_V_Pipeline_rst_tb/DUT/CORE/E_ALUControl
add wave -noupdate /RISC_V_Pipeline_rst_tb/DUT/CORE/E_RD1
add wave -noupdate /RISC_V_Pipeline_rst_tb/DUT/CORE/E_RD2
add wave -noupdate /RISC_V_Pipeline_rst_tb/DUT/CORE/W_WD3
add wave -noupdate /RISC_V_Pipeline_rst_tb/DUT/CORE/E_SignImm
add wave -noupdate /RISC_V_Pipeline_rst_tb/DUT/CORE/E_ShiftImm
add wave -noupdate /RISC_V_Pipeline_rst_tb/DUT/CORE/E_PCj
add wave -noupdate /RISC_V_Pipeline_rst_tb/DUT/CORE/E_PCbra
add wave -noupdate /RISC_V_Pipeline_rst_tb/DUT/CORE/E_RegA
add wave -noupdate /RISC_V_Pipeline_rst_tb/DUT/CORE/E_RegB
add wave -noupdate /RISC_V_Pipeline_rst_tb/DUT/CORE/E_SrcA
add wave -noupdate /RISC_V_Pipeline_rst_tb/DUT/CORE/E_SrcB
add wave -noupdate /RISC_V_Pipeline_rst_tb/DUT/CORE/E_ALUOut
add wave -noupdate -divider PRODUCT
add wave -noupdate /RISC_V_Pipeline_rst_tb/DUT/CORE/P1_Rs1
add wave -noupdate /RISC_V_Pipeline_rst_tb/DUT/CORE/P1_Rs2
add wave -noupdate /RISC_V_Pipeline_rst_tb/DUT/CORE/P1_Rd
add wave -noupdate /RISC_V_Pipeline_rst_tb/DUT/CORE/P1_RegMul
add wave -noupdate /RISC_V_Pipeline_rst_tb/DUT/CORE/P2_Rs1
add wave -noupdate /RISC_V_Pipeline_rst_tb/DUT/CORE/P2_Rs2
add wave -noupdate /RISC_V_Pipeline_rst_tb/DUT/CORE/P2_Rd
add wave -noupdate /RISC_V_Pipeline_rst_tb/DUT/CORE/P2_RegMul
add wave -noupdate /RISC_V_Pipeline_rst_tb/DUT/CORE/P3_Rs1
add wave -noupdate /RISC_V_Pipeline_rst_tb/DUT/CORE/P3_Rs2
add wave -noupdate /RISC_V_Pipeline_rst_tb/DUT/CORE/P3_Rd
add wave -noupdate /RISC_V_Pipeline_rst_tb/DUT/CORE/P3_RegMul
add wave -noupdate /RISC_V_Pipeline_rst_tb/DUT/CORE/W_MULOut
add wave -noupdate -divider MEMORY
add wave -noupdate -color Gold -itemcolor Gold /RISC_V_Pipeline_rst_tb/DUT/CORE/M_InstrData
add wave -noupdate /RISC_V_Pipeline_rst_tb/DUT/CORE/M_RegWrite
add wave -noupdate /RISC_V_Pipeline_rst_tb/DUT/CORE/M_Jump
add wave -noupdate /RISC_V_Pipeline_rst_tb/DUT/CORE/M_Branch
add wave -noupdate /RISC_V_Pipeline_rst_tb/DUT/CORE/M_XorZero
add wave -noupdate /RISC_V_Pipeline_rst_tb/DUT/CORE/M_MemtoReg
add wave -noupdate /RISC_V_Pipeline_rst_tb/DUT/CORE/M_Zero
add wave -noupdate /RISC_V_Pipeline_rst_tb/DUT/CORE/M_PCSrc
add wave -noupdate /RISC_V_Pipeline_rst_tb/DUT/CORE/MemRead
add wave -noupdate /RISC_V_Pipeline_rst_tb/DUT/CORE/MemWrite
add wave -noupdate /RISC_V_Pipeline_rst_tb/DUT/CORE/M_PCbra
add wave -noupdate /RISC_V_Pipeline_rst_tb/DUT/CORE/MemData
add wave -noupdate /RISC_V_Pipeline_rst_tb/DUT/CORE/WriteData
add wave -noupdate /RISC_V_Pipeline_rst_tb/DUT/CORE/RWAddress
add wave -noupdate -divider WRITEBACK
add wave -noupdate -color Gold -itemcolor Gold /RISC_V_Pipeline_rst_tb/DUT/CORE/W_InstrData
add wave -noupdate /RISC_V_Pipeline_rst_tb/DUT/CORE/W_RegWrite
add wave -noupdate /RISC_V_Pipeline_rst_tb/DUT/CORE/W_MemtoReg
add wave -noupdate /RISC_V_Pipeline_rst_tb/DUT/CORE/W_MemData
add wave -noupdate /RISC_V_Pipeline_rst_tb/DUT/CORE/W_ALUOut
add wave -noupdate /RISC_V_Pipeline_rst_tb/DUT/CORE/W_WD3
add wave -noupdate -divider {ROM / RAM / Regs}
add wave -noupdate /RISC_V_Pipeline_rst_tb/DUT/CORE/MemData
add wave -noupdate /RISC_V_Pipeline_rst_tb/DUT/ROM/A
add wave -noupdate -expand -group regs -label r30 {/RISC_V_Pipeline_rst_tb/DUT/CORE/REGFILE/GENREGS[31]/genblk1/REG_i/Q}
add wave -noupdate -expand -group regs -label r31 {/RISC_V_Pipeline_rst_tb/DUT/CORE/REGFILE/GENREGS[30]/genblk1/REG_i/Q}
add wave -noupdate -expand -group regs -label r20 {/RISC_V_Pipeline_rst_tb/DUT/CORE/REGFILE/GENREGS[29]/genblk1/REG_i/Q}
add wave -noupdate -expand -group regs -label r21 {/RISC_V_Pipeline_rst_tb/DUT/CORE/REGFILE/GENREGS[28]/genblk1/REG_i/Q}
add wave -noupdate -expand -group regs -label r22 {/RISC_V_Pipeline_rst_tb/DUT/CORE/REGFILE/GENREGS[27]/genblk1/REG_i/Q}
add wave -noupdate -expand -group regs -label r23 {/RISC_V_Pipeline_rst_tb/DUT/CORE/REGFILE/GENREGS[26]/genblk1/REG_i/Q}
add wave -noupdate -expand -group regs -label r24 {/RISC_V_Pipeline_rst_tb/DUT/CORE/REGFILE/GENREGS[25]/genblk1/REG_i/Q}
add wave -noupdate -expand -group regs -label r25 {/RISC_V_Pipeline_rst_tb/DUT/CORE/REGFILE/GENREGS[24]/genblk1/REG_i/Q}
add wave -noupdate -expand -group regs -label r26 {/RISC_V_Pipeline_rst_tb/DUT/CORE/REGFILE/GENREGS[23]/genblk1/REG_i/Q}
add wave -noupdate -expand -group regs -label r27 {/RISC_V_Pipeline_rst_tb/DUT/CORE/REGFILE/GENREGS[22]/genblk1/REG_i/Q}
add wave -noupdate -expand -group regs -label r28 {/RISC_V_Pipeline_rst_tb/DUT/CORE/REGFILE/GENREGS[21]/genblk1/REG_i/Q}
add wave -noupdate -expand -group regs -label r29 {/RISC_V_Pipeline_rst_tb/DUT/CORE/REGFILE/GENREGS[20]/genblk1/REG_i/Q}
add wave -noupdate -expand -group regs -label r10 {/RISC_V_Pipeline_rst_tb/DUT/CORE/REGFILE/GENREGS[19]/genblk1/REG_i/Q}
add wave -noupdate -expand -group regs -label r11 {/RISC_V_Pipeline_rst_tb/DUT/CORE/REGFILE/GENREGS[18]/genblk1/REG_i/Q}
add wave -noupdate -expand -group regs -label r12 {/RISC_V_Pipeline_rst_tb/DUT/CORE/REGFILE/GENREGS[17]/genblk1/REG_i/Q}
add wave -noupdate -expand -group regs -label r13 {/RISC_V_Pipeline_rst_tb/DUT/CORE/REGFILE/GENREGS[16]/genblk1/REG_i/Q}
add wave -noupdate -expand -group regs -label r14 {/RISC_V_Pipeline_rst_tb/DUT/CORE/REGFILE/GENREGS[15]/genblk1/REG_i/Q}
add wave -noupdate -expand -group regs -label r15 {/RISC_V_Pipeline_rst_tb/DUT/CORE/REGFILE/GENREGS[14]/genblk1/REG_i/Q}
add wave -noupdate -expand -group regs -label r16 {/RISC_V_Pipeline_rst_tb/DUT/CORE/REGFILE/GENREGS[13]/genblk1/REG_i/Q}
add wave -noupdate -expand -group regs -label r17 {/RISC_V_Pipeline_rst_tb/DUT/CORE/REGFILE/GENREGS[12]/genblk1/REG_i/Q}
add wave -noupdate -expand -group regs -label r18 {/RISC_V_Pipeline_rst_tb/DUT/CORE/REGFILE/GENREGS[11]/genblk1/REG_i/Q}
add wave -noupdate -expand -group regs -label r19 {/RISC_V_Pipeline_rst_tb/DUT/CORE/REGFILE/GENREGS[10]/genblk1/REG_i/Q}
add wave -noupdate -expand -group regs -label r9 {/RISC_V_Pipeline_rst_tb/DUT/CORE/REGFILE/GENREGS[9]/genblk1/REG_i/Q}
add wave -noupdate -expand -group regs -label r8 {/RISC_V_Pipeline_rst_tb/DUT/CORE/REGFILE/GENREGS[8]/genblk1/REG_i/Q}
add wave -noupdate -expand -group regs -label r7 {/RISC_V_Pipeline_rst_tb/DUT/CORE/REGFILE/GENREGS[7]/genblk1/REG_i/Q}
add wave -noupdate -expand -group regs -label r6 {/RISC_V_Pipeline_rst_tb/DUT/CORE/REGFILE/GENREGS[6]/genblk1/REG_i/Q}
add wave -noupdate -expand -group regs -label r5 {/RISC_V_Pipeline_rst_tb/DUT/CORE/REGFILE/GENREGS[5]/genblk1/REG_i/Q}
add wave -noupdate -expand -group regs -label r4 {/RISC_V_Pipeline_rst_tb/DUT/CORE/REGFILE/GENREGS[4]/genblk1/REG_i/Q}
add wave -noupdate -expand -group regs -label r3 {/RISC_V_Pipeline_rst_tb/DUT/CORE/REGFILE/GENREGS[3]/genblk1/REG_i/Q}
add wave -noupdate -expand -group regs -label r2 {/RISC_V_Pipeline_rst_tb/DUT/CORE/REGFILE/GENREGS[2]/genblk1/REG_i/Q}
add wave -noupdate -expand -group regs -label r1 {/RISC_V_Pipeline_rst_tb/DUT/CORE/REGFILE/GENREGS[1]/genblk1/REG_i/Q}
add wave -noupdate -expand -group regs -label r0 {/RISC_V_Pipeline_rst_tb/DUT/CORE/REGFILE/GENREGS[0]/genblk1/REG_i/Q}
add wave -noupdate -expand /RISC_V_Pipeline_rst_tb/DUT/RAM/ram
add wave -noupdate -divider {Mem Controler}
add wave -noupdate /RISC_V_Pipeline_rst_tb/DUT/MM/re
add wave -noupdate /RISC_V_Pipeline_rst_tb/DUT/MM/we
add wave -noupdate /RISC_V_Pipeline_rst_tb/DUT/MM/WD
add wave -noupdate /RISC_V_Pipeline_rst_tb/DUT/MM/A
add wave -noupdate /RISC_V_Pipeline_rst_tb/DUT/MM/RD
add wave -noupdate /RISC_V_Pipeline_rst_tb/DUT/MM/data
add wave -noupdate /RISC_V_Pipeline_rst_tb/DUT/MM/mem
add wave -noupdate /RISC_V_Pipeline_rst_tb/DUT/MM/weRAM
add wave -noupdate /RISC_V_Pipeline_rst_tb/DUT/MM/ReadRAM
add wave -noupdate /RISC_V_Pipeline_rst_tb/DUT/MM/AddrRAM
add wave -noupdate /RISC_V_Pipeline_rst_tb/DUT/MM/DataRAM
add wave -noupdate /RISC_V_Pipeline_rst_tb/DUT/MM/gpio
add wave -noupdate /RISC_V_Pipeline_rst_tb/DUT/MM/weGPIO
add wave -noupdate /RISC_V_Pipeline_rst_tb/DUT/MM/ReadGPIO
add wave -noupdate /RISC_V_Pipeline_rst_tb/DUT/MM/DataGPIO
add wave -noupdate /RISC_V_Pipeline_rst_tb/DUT/MM/uart
add wave -noupdate /RISC_V_Pipeline_rst_tb/DUT/MM/in_save_data_bits_w
add wave -noupdate /RISC_V_Pipeline_rst_tb/DUT/MM/tx_fsm_in_STOP_S
add wave -noupdate /RISC_V_Pipeline_rst_tb/DUT/MM/ReadUART
add wave -noupdate /RISC_V_Pipeline_rst_tb/DUT/MM/Rx_Data
add wave -noupdate /RISC_V_Pipeline_rst_tb/DUT/MM/Tx_Data_w
add wave -noupdate /RISC_V_Pipeline_rst_tb/DUT/MM/rx_data
add wave -noupdate /RISC_V_Pipeline_rst_tb/DUT/MM/tx_send_en
add wave -noupdate /RISC_V_Pipeline_rst_tb/DUT/MM/tx_data_en
add wave -noupdate /RISC_V_Pipeline_rst_tb/DUT/MM/tx_send
add wave -noupdate /RISC_V_Pipeline_rst_tb/DUT/MM/rx_ready
add wave -noupdate /RISC_V_Pipeline_rst_tb/DUT/MM/tx_send_read
add wave -noupdate -divider HDU
add wave -noupdate /RISC_V_Pipeline_rst_tb/DUT/CORE/HDU/PCWrite
add wave -noupdate /RISC_V_Pipeline_rst_tb/DUT/CORE/HDU/IDWrite
add wave -noupdate /RISC_V_Pipeline_rst_tb/DUT/CORE/HDU/Stall
add wave -noupdate /RISC_V_Pipeline_rst_tb/DUT/CORE/HDU/load_stall
add wave -noupdate /RISC_V_Pipeline_rst_tb/DUT/CORE/HDU/mult_stall
add wave -noupdate /RISC_V_Pipeline_rst_tb/DUT/CORE/HDU/muwb_stall
add wave -noupdate /RISC_V_Pipeline_rst_tb/DUT/CORE/HDU/mooo_stall
add wave -noupdate /RISC_V_Pipeline_rst_tb/DUT/CORE/HDU/mult_stall_0
add wave -noupdate /RISC_V_Pipeline_rst_tb/DUT/CORE/HDU/mult_stall_1
add wave -noupdate /RISC_V_Pipeline_rst_tb/DUT/CORE/HDU/mult_stall_2
add wave -noupdate -divider FU
add wave -noupdate /RISC_V_Pipeline_rst_tb/DUT/CORE/FU/AForward
add wave -noupdate /RISC_V_Pipeline_rst_tb/DUT/CORE/FU/BForward
add wave -noupdate /RISC_V_Pipeline_rst_tb/DUT/CORE/FU/mem_forward
add wave -noupdate /RISC_V_Pipeline_rst_tb/DUT/CORE/FU/wb_forward
add wave -noupdate /RISC_V_Pipeline_rst_tb/DUT/CORE/FU/wb_forward_alu
add wave -noupdate /RISC_V_Pipeline_rst_tb/DUT/CORE/FU/wb_forward_mul
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {210317 ps} 0}
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
WaveRestoreZoom {194562 ps} {223438 ps}
