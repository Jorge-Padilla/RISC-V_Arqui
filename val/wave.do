onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /RISC_V_tb/clk
add wave -noupdate /RISC_V_tb/rst
add wave -noupdate /RISC_V_tb/DUT/gpio_port_in
add wave -noupdate /RISC_V_tb/DUT/gpio_port_out
add wave -noupdate /RISC_V_tb/mem_data
add wave -noupdate /RISC_V_tb/CU_State
add wave -noupdate /RISC_V_tb/DUT/clk
add wave -noupdate /RISC_V_tb/DUT/CORE/PC
add wave -noupdate /RISC_V_tb/DUT/CORE/PCbra
add wave -noupdate /RISC_V_tb/DUT/CORE/MemData
add wave -noupdate /RISC_V_tb/DUT/CORE/Instr
add wave -noupdate /RISC_V_tb/DUT/CORE/Data
add wave -noupdate /RISC_V_tb/DUT/CORE/WD3
add wave -noupdate /RISC_V_tb/DUT/CORE/RD1
add wave -noupdate /RISC_V_tb/DUT/CORE/RD2
add wave -noupdate /RISC_V_tb/DUT/CORE/A
add wave -noupdate /RISC_V_tb/DUT/CORE/SrcA
add wave -noupdate /RISC_V_tb/DUT/CORE/SrcB
add wave -noupdate /RISC_V_tb/DUT/CORE/ALUResult
add wave -noupdate /RISC_V_tb/DUT/CORE/ALUOut
add wave -noupdate /RISC_V_tb/DUT/ROM/A
add wave -noupdate /RISC_V_tb/DUT/ROM/RD
add wave -noupdate -expand /RISC_V_tb/DUT/CORE/REGFILE/registers
add wave -noupdate /RISC_V_tb/DUT/RAM/ram
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {180000 ps} 0}
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
WaveRestoreZoom {2602500 ps} {3652500 ps}
