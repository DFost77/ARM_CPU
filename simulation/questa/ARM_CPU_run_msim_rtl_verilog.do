transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+C:/Users/Larry/projects/CompArch/CPU {C:/Users/Larry/projects/CompArch/CPU/ALU64.v}
vlog -vlog01compat -work work +incdir+C:/Users/Larry/projects/CompArch/CPU {C:/Users/Larry/projects/CompArch/CPU/CTRL_UNIT.v}
vlog -vlog01compat -work work +incdir+C:/Users/Larry/projects/CompArch/CPU {C:/Users/Larry/projects/CompArch/CPU/arm_cpu.v}
vlog -vlog01compat -work work +incdir+C:/Users/Larry/projects/CompArch/CPU {C:/Users/Larry/projects/CompArch/CPU/ALU_CTRL.v}

