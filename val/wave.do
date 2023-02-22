onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /RISC_V_tb/clk
add wave -noupdate /RISC_V_tb/rst
add wave -noupdate /RISC_V_tb/mem_data
add wave -noupdate /RISC_V_tb/CU_State
add wave -noupdate /RISC_V_tb/DUT/clk
add wave -noupdate /RISC_V_tb/DUT/PC
add wave -noupdate /RISC_V_tb/DUT/PCbra
add wave -noupdate /RISC_V_tb/DUT/Adr
add wave -noupdate /RISC_V_tb/DUT/MemData
add wave -noupdate /RISC_V_tb/DUT/Instr
add wave -noupdate /RISC_V_tb/DUT/Data
add wave -noupdate /RISC_V_tb/DUT/WD3
add wave -noupdate /RISC_V_tb/DUT/RD1
add wave -noupdate /RISC_V_tb/DUT/RD2
add wave -noupdate /RISC_V_tb/DUT/A
add wave -noupdate /RISC_V_tb/DUT/B
add wave -noupdate /RISC_V_tb/DUT/SrcA
add wave -noupdate /RISC_V_tb/DUT/SrcB
add wave -noupdate /RISC_V_tb/DUT/ALUResult
add wave -noupdate /RISC_V_tb/DUT/ALUOut
add wave -noupdate /RISC_V_tb/DUT/MM/ROM/A
add wave -noupdate /RISC_V_tb/DUT/MM/ROM/RD
add wave -noupdate -expand /RISC_V_tb/DUT/REGFILE/registers
add wave -noupdate /RISC_V_tb/DUT/MM/RAM/ram
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
WaveRestoreZoom {0 ps} {1050 ns}
