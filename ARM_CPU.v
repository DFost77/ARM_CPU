module ARM_CPU (
	input CLK,
	output reg [1:0] CONTROL_SIGNEXT
	output reg CONTROL_REG2LOGIC,
	output reg CONTROL_BRANCH,
	output reg CONTROL_MEMREAD,
	output reg CONTROL_MEM2REG,
	output reg CONTROL_ALU_OP,
	output reg CONTROL_MEMWRITE,
	output reg CONTROL_ALU_SRC,
	output reg CONTROL_REGWRITE,
	output reg [63:0] PC
);
	// Pc buses
	wire [63:0] temp_pc;
	wire [63:0] PC_to_INSTRUCT_MEM;
	reg [63:0] PC_plus4;
	wire [63:0] PC_ALU_Out;
	reg PC_CTRL;
	
	// Instruction to Register buses
	wire [31:0] INSTRUCT_MEM_OUT;
	wire [4:0] Reg2In;
	
	// Sign ext bus
	reg [63:0] INSTRUCT_SIGN_EXT;
	
	// Register to ALU buses
	wire [63:0] ALU_ARG1;
	reg [63:0] ALU_tempARG2;
	wire [63:0] ALU_ARG2;
	
	// ALU wire/buses
	wire ALU_CTRL_ZERO;
	reg [3:0] ALU_CTRL_OUT;
	reg [63:0] ALU_RESULT;
	
	// Data memory buses
	reg [63:0] DATAMEM_RD_Data;
	wire [63:0] DATAMEM_WR_Back;
	
	// Instantiate instruction memory
	INSTRUCT_MEM instruct_memory(
		.PC_IN(PC_to_INSTRUCT_MEM),
		.INSTRUCT_OUT(INSTRUCT_MEM_OUT)
	);	
	
	// Mux for read register 2 input
	mux_5 Reg2Mux(
		.in_1(INSTRUCT_MEM_OUT[20:16]),
		.in_2(INSTRUCT_MEM_OUT[4:0]),
		.ctrl(CONTROL_REG2LOGIC),
		.out(Reg2In)
	);
	
	//Instantiate register file
	REG_FILE registers(
		.RD_REG1(INSTRUCT_MEM_OUT[9:5]),
		.RD_REG2(Reg2In),
		.WR_REG(INSTRUCT_MEM_OUT[4:0]),
		.WR_DATA(WriteOut),
		.CTRL_REG_WR(CONTROL_REGWRITE),
		.RD_DATA1(ALU_ARG1),
		.RD_DATA2(ALU_ARG2)
	);
	
	// Mux for ALU argument 2
	mux_64 ALUMux(
		.in_1(ALU_ARG1),
		.in_2(ALU_ARG2),
		.ctrl(CONTROL_ALU_SRC),
		.out(ALU_ARG2)
	);
	
	// Main ALU
	ALU64 mainALU(
		.ARG1(),
		.ARG2(),
		.CTRL_ALU_OP(),
		.CTRL_ALU_ZERO(),
		.OUT()
	);
	
	// Adder for next PC
	ALU64 PC4_Adder(
		.ARG1(),
		.ARG2(),
		.CTRL_ALU_OP(),
		.CTRL_ALU_ZERO(),
		.OUT()
	);
	
	// Adder for new PC address
	ALU64 PCaddr_Adder(
		.ARG1(),
		.ARG2(),
		.CTRL_ALU_OP(),
		.CTRL_ALU_ZERO(),
		.OUT()
	);
	
	// Mux for select PC Src
	mux_64 PCMux(
		.in_1(PC_plus4),
		.in_2(PC_ALU_out),
		.ctrl(),
		.out(temp_pc)
	);
	
	// Mux for write back
	mux_64 WriteRegMux(
		.in_1(DATAMEM_RD_Data),
		.in_2(ALU_RESULT),
		.ctrl(CONTROL_MEM2REG),
		.out(DATAMEM_WR_Back)
	);
	

endmodule

module mux_64 (
	input [63:0] in_1,
	input [63:0] in_2,
	input ctrl,
	output [63:0] out
);
	// If control bit 0, pick first input
	assign out = (ctrl == 0) ? in_1 : in_2;

endmodule

module mux_5 (
	input [4:0] in_1,
	input [4:0] in_2,
	input ctrl,
	output [4:0] out
); 
	// If control bit 0, pick first input
	assign out = (ctrl == 0) ? in_1 : in_2;

endmodule

module sign_ext(
	input [31:0] instruction,
	input [1:0] ctrl,
	output [63:0] ext_out
);

	always @* begin
		case(ctrl)
			// B extend
			2'b00 : begin 
				ext_out = {40{instruction[23]}, instruction[23:0]};
			end
			// CBZ extend
			2'b01 : begin
				ext_out = {45{instruction[23]}, instruction[23:5]};
			end
			// LDUR STUR extend
			2'b1x : begin
				ext_out = {55{instruction[20]}, instruction[20:12]};
			end
		endcase
	end
endmodule