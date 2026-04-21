transcript on
if {[file exists work]} {
	vdel -lib work -all
}


vlib work
vmap work work

vlog -work work ALU64.v
vlog -work work ALU_CTRL.v
vlog -work work CTRL_UNIT.v
vlog -work work REG_FILE.v
vlog -work work INSTRUCT_MEM.v
vlog -work work DATA_MEM.v
vlog -work work ARM_CPU.v
vlog -work work cpu_tb.v

vsim -voptargs=+acc work.cpu_tb

add wave -noupdate -divider "System Clock"
add wave -noupdate -radix binary /cpu_tb/CLK

add wave -noupdate -divider "Program Counter & Instruction"
add wave -noupdate -radix unsigned /cpu_tb/PC
add wave -noupdate -radix hexadecimal /cpu_tb/INSTRUCT_MEM_OUT

add wave -noupdate -divider "Control Unit"
add wave -noupdate -radix binary /cpu_tb/core/main_ctrl/opcode
add wave -noupdate -radix binary /cpu_tb/CTRL_REGWRITE
add wave -noupdate -radix binary /cpu_tb/CTRL_MEMREAD
add wave -noupdate -radix binary /cpu_tb/CTRL_MEMWRITE

add wave -noupdate -divider "Register File"
add wave -noupdate -radix unsigned /cpu_tb/RD_REG1
add wave -noupdate -radix unsigned /cpu_tb/RD_REG2
add wave -noupdate -radix unsigned /cpu_tb/WR_REG
add wave -noupdate -radix decimal /cpu_tb/RD_DATA1
add wave -noupdate -radix decimal /cpu_tb/RD_DATA2
add wave -noupdate -radix decimal /cpu_tb/DMEM_WR_Back

add wave -noupdate -divider "Data Memory"
add wave -noupdate -radix decimal /cpu_tb/DMEM_Addr
add wave -noupdate -radix decimal /cpu_tb/DMEM_WR_DATA
add wave -noupdate -radix decimal /cpu_tb/DMEM_RD_DATA

TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ns} 0}
configure wave -namecolwidth 250
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2

run 200 ns