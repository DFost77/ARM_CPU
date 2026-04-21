`timescale 1ns/1ps

module cpu_tb;
	
	reg CLK;
	
	// CPU <-> Instruction buses
	wire [63:0] PC;
	wire [31:0] INSTRUCT_MEM_OUT;
	
	// CPU <-> Register buses
	wire CTRL_REGWRITE;
	wire [4:0] RD_REG1;
	wire [4:0] RD_REG2;
	wire [4:0] WR_REG;
	wire [63:0] DMEM_WR_Back;
	wire [63:0] RD_DATA1;
	wire [63:0] RD_DATA2;
	
	// CPU <-> DMEM buses
	wire CTRL_MEMREAD;
	wire CTRL_MEMWRITE;
	wire [63:0] DMEM_Addr;
	wire [63:0] DMEM_WR_DATA;
	wire [63:0] DMEM_RD_DATA;
	
	
	// Instantiate instruction memory
	INSTRUCT_MEM instruct_memory(
		.PC_IN(PC),
		.INSTRUCT_OUT(INSTRUCT_MEM_OUT)
	);	
	
	//Instantiate register file
	REG_FILE registers(
		.CLK(CLK),
		.RD_REG1(RD_REG1),
		.RD_REG2(RD_REG2),
		.WR_REG(WR_REG),
		.WR_DATA(DMEM_WR_Back),
		.CTRL_REG_WR(CTRL_REGWRITE),
		.RD_DATA1(RD_DATA1),
		.RD_DATA2(RD_DATA2)
	);
	
	// Instantiate data memory 
	DATA_MEM dmem(
		.CLK(CLK),
		.ADDR(DMEM_Addr),
		.WR_DATA(DMEM_WR_DATA),
		.CTRL_MEM_RD(CTRL_MEMREAD),
		.CTRL_MEM_WR(CTRL_MEMWRITE),
		.RD_DATA(DMEM_RD_DATA)
	);
	
	// Instantiate datapath
	arm_cpu core(
		.CLK(CLK),
		.PC(PC),
		.INSTRUCT_MEM_OUT(INSTRUCT_MEM_OUT),
		.CTRL_REGWRITE(CTRL_REGWRITE),
		.RD_REG1(RD_REG1),
		.RD_REG2(RD_REG2),
		.WR_REG(WR_REG),
		.DMEM_WR_Back(DMEM_WR_Back),
		.RD_DATA1(RD_DATA1),
		.RD_DATA2(RD_DATA2),
		.DMEM_Addr(DMEM_Addr),
		.DMEM_WR_DATA(DMEM_WR_DATA),
		.CTRL_MEMREAD(CTRL_MEMREAD),
		.CTRL_MEMWRITE(CTRL_MEMWRITE),
		.DMEM_RD_DATA(DMEM_RD_DATA)
	);
	
	/* Setup the clock */
	initial begin
		CLK = 1'b0;
		#200 $finish;
	end

  /* Toggle the clock */
  always #5 CLK = ~CLK;
	
endmodule

