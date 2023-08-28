onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -divider {RISC-V I/O}
add wave -noupdate /RISC_V_Single_Cycle_tb/clk
add wave -noupdate /RISC_V_Single_Cycle_tb/rst
add wave -noupdate /RISC_V_Single_Cycle_tb/DUT/gpio_port_in
add wave -noupdate /RISC_V_Single_Cycle_tb/DUT/gpio_port_out
add wave -noupdate /RISC_V_Single_Cycle_tb/DUT/rx
add wave -noupdate /RISC_V_Single_Cycle_tb/DUT/tx
add wave -noupdate /RISC_V_Single_Cycle_tb/clk_out
add wave -noupdate -divider {Core Signals}
add wave -noupdate /RISC_V_Single_Cycle_tb/Rx_state_out
add wave -noupdate /RISC_V_Single_Cycle_tb/Tx_state_out
add wave -noupdate /RISC_V_Single_Cycle_tb/DUT/clk
add wave -noupdate /RISC_V_Single_Cycle_tb/DUT/CORE/PC
add wave -noupdate -divider {Instruction and Data}
add wave -noupdate /RISC_V_Single_Cycle_tb/DUT/CORE/InstrData
add wave -noupdate -divider {Reg File}
add wave -noupdate /RISC_V_Single_Cycle_tb/DUT/CORE/WD3
add wave -noupdate /RISC_V_Single_Cycle_tb/DUT/CORE/RD1
add wave -noupdate /RISC_V_Single_Cycle_tb/DUT/CORE/WriteData
add wave -noupdate -divider ALU
add wave -noupdate /RISC_V_Single_Cycle_tb/DUT/CORE/SrcA
add wave -noupdate /RISC_V_Single_Cycle_tb/DUT/CORE/SrcB
add wave -noupdate /RISC_V_Single_Cycle_tb/DUT/CORE/RWAddress
add wave -noupdate -divider {PC Branch}
add wave -noupdate /RISC_V_Single_Cycle_tb/DUT/CORE/PCE/PCWrite
add wave -noupdate /RISC_V_Single_Cycle_tb/DUT/CORE/PCE/Branch
add wave -noupdate /RISC_V_Single_Cycle_tb/DUT/CORE/PCE/Zero
add wave -noupdate /RISC_V_Single_Cycle_tb/DUT/CORE/PCE/XorZero
add wave -noupdate /RISC_V_Single_Cycle_tb/DUT/CORE/PCE/PCEn
add wave -noupdate -divider {ROM / RAM / Regs}
add wave -noupdate /RISC_V_Single_Cycle_tb/DUT/CORE/MemData
add wave -noupdate /RISC_V_Single_Cycle_tb/DUT/ROM/A
add wave -noupdate /RISC_V_Single_Cycle_tb/DUT/ROM/RD
add wave -noupdate -expand /RISC_V_Single_Cycle_tb/DUT/CORE/REGFILE/registers
add wave -noupdate /RISC_V_Single_Cycle_tb/DUT/RAM/ram
add wave -noupdate -divider {Mem Controler}
add wave -noupdate /RISC_V_Single_Cycle_tb/DUT/MM/re
add wave -noupdate /RISC_V_Single_Cycle_tb/DUT/MM/we
add wave -noupdate /RISC_V_Single_Cycle_tb/DUT/MM/WD
add wave -noupdate /RISC_V_Single_Cycle_tb/DUT/MM/A
add wave -noupdate /RISC_V_Single_Cycle_tb/DUT/MM/RD
add wave -noupdate /RISC_V_Single_Cycle_tb/DUT/MM/data
add wave -noupdate /RISC_V_Single_Cycle_tb/DUT/MM/mem
add wave -noupdate /RISC_V_Single_Cycle_tb/DUT/MM/weRAM
add wave -noupdate /RISC_V_Single_Cycle_tb/DUT/MM/ReadRAM
add wave -noupdate /RISC_V_Single_Cycle_tb/DUT/MM/AddrRAM
add wave -noupdate /RISC_V_Single_Cycle_tb/DUT/MM/DataRAM
add wave -noupdate /RISC_V_Single_Cycle_tb/DUT/MM/gpio
add wave -noupdate /RISC_V_Single_Cycle_tb/DUT/MM/weGPIO
add wave -noupdate /RISC_V_Single_Cycle_tb/DUT/MM/ReadGPIO
add wave -noupdate /RISC_V_Single_Cycle_tb/DUT/MM/DataGPIO
add wave -noupdate /RISC_V_Single_Cycle_tb/DUT/MM/uart
add wave -noupdate /RISC_V_Single_Cycle_tb/DUT/MM/in_save_data_bits_w
add wave -noupdate /RISC_V_Single_Cycle_tb/DUT/MM/tx_fsm_in_STOP_S
add wave -noupdate /RISC_V_Single_Cycle_tb/DUT/MM/ReadUART
add wave -noupdate /RISC_V_Single_Cycle_tb/DUT/MM/Rx_Data
add wave -noupdate /RISC_V_Single_Cycle_tb/DUT/MM/Tx_Data_w
add wave -noupdate /RISC_V_Single_Cycle_tb/DUT/MM/rx_data
add wave -noupdate /RISC_V_Single_Cycle_tb/DUT/MM/tx_send_en
add wave -noupdate /RISC_V_Single_Cycle_tb/DUT/MM/tx_data_en
add wave -noupdate /RISC_V_Single_Cycle_tb/DUT/MM/tx_send
add wave -noupdate /RISC_V_Single_Cycle_tb/DUT/MM/rx_ready
add wave -noupdate /RISC_V_Single_Cycle_tb/DUT/MM/tx_send_read
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {230852000 ps} 0}
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
WaveRestoreZoom {0 ps} {603863400 ps}
