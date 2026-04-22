module arm_cpu (
	input CLK,
	// CPU to Instruction mem
	output reg [63:0] PC,
	
	// Instruction mem to CPU
	input [31:0] INSTRUCT_MEM_OUT,
	
	// CPU to Register outputs 
	output CTRL_REGWRITE,
	output [4:0] RD_REG1,
	output [4:0] RD_REG2,
	output [4:0] WR_REG,
	output [63:0] DMEM_WR_Back,

	// Register to CPU inputs
	input [63:0] RD_DATA1,
	input [63:0] RD_DATA2,
	
	// CPU to Data Memory outputs
	output [63:0] DMEM_Addr,
	output [63:0] DMEM_WR_DATA,
	output CTRL_MEMREAD,
	output CTRL_MEMWRITE,
	
	// DMEM to CPU inputs
	input [63:0] DMEM_RD_DATA

);
	// Control wires/buses
	wire CTRL_REG2LOGIC;
	wire CTRL_UNCOND_BRANCH;
	wire CTRL_BRANCH;
	wire CTRL_JUMP;
	wire CTRL_MEM2REG;
	wire [1:0] CTRL_ALU_OP;
	wire CTRL_ALU_SRC;
	wire branch_zero;

	// Pc buses
	wire [63:0] PC_ALU_out;
	wire [63:0] temp_pc;
	wire [63:0] PC_to_INSTRUCT_MEM;
	wire [63:0] PC_plus4;
	
	// Sign ext and shift bus
	wire [63:0] INSTRUCT_SIGN_EXT;
	wire [63:0] immd_shifted;
	
	// Register to ALU buses
	wire [63:0] ALU_ARG1;
	wire [63:0] ALU_tempARG2;
	wire [63:0] ALU_ARG2;
	
	// ALU wire/buses
	wire ALU_zero_flag;
	wire [3:0] ALU_CTRL_OUT;
	wire [63:0] ALU_RESULT;

	
	
	// Main controls
	CTRL_UNIT main_ctrl(
		.opcode(INSTRUCT_MEM_OUT[31:21]),
		.CONTROL_REG2LOGIC(CTRL_REG2LOGIC),
		.CONTROL_UNCOND_BRANCH(CTRL_UNCOND_BRANCH),
		.CONTROL_BRANCH(CTRL_BRANCH),
		.CONTROL_MEMREAD(CTRL_MEMREAD),
		.CONTROL_MEM2REG(CTRL_MEM2REG),
		.CONTROL_ALU_OP(CTRL_ALU_OP),
		.CONTROL_MEMWRITE(CTRL_MEMWRITE),
		.CONTROL_ALU_SRC(CTRL_ALU_SRC),
		.CONTROL_REGWRITE(CTRL_REGWRITE)
	);
	
	// ALU Control Unit
    ALU_CTRL alu_controller (
        .ALUOp(CTRL_ALU_OP),                   
        .opcode(INSTRUCT_MEM_OUT[31:21]),      
        .ALU_Ctrl_Out(ALU_CTRL_OUT)          
    );
	
	
	// Mux for read register 2 input
	mux_5 Reg2Mux(
		.in_1(INSTRUCT_MEM_OUT[20:16]),
		.in_2(INSTRUCT_MEM_OUT[4:0]),
		.ctrl(CTRL_REG2LOGIC),
		.out(RD_REG2)
	);
	
	// Extend immediate module
	sign_ext immd_ext(
		.instruction(INSTRUCT_MEM_OUT),
		.ext_out(INSTRUCT_SIGN_EXT)
	);
	
	// Shift immediate left 2 module
	sll_2 immd_shift(
		.in(INSTRUCT_SIGN_EXT),
		.out(immd_shifted)
	);
	
	// Mux for ALU argument 2
	mux_64 ALUMux(
		.in_1(RD_DATA2),
		.in_2(INSTRUCT_SIGN_EXT),
		.ctrl(CTRL_ALU_SRC),
		.out(ALU_ARG2)
	);
	
	// Main ALU
	ALU64 mainALU(
		.ARG1(RD_DATA1),
		.ARG2(ALU_ARG2),
		.CTRL_ALU_OP(ALU_CTRL_OUT),
		.CTRL_ALU_ZERO(ALU_zero_flag),
		.OUT(ALU_RESULT)
	);
	
	// Adder for next PC
	ALU64 PC4_Adder(
		.ARG1(PC_to_INSTRUCT_MEM),
		.ARG2(64'd4),
		.CTRL_ALU_OP(4'b0010),
		.CTRL_ALU_ZERO(),
		.OUT(PC_plus4)
	);
	
	// Adder for new PC address
	ALU64 PCaddr_Adder(
		.ARG1(PC_to_INSTRUCT_MEM),
		.ARG2(immd_shifted),
		.CTRL_ALU_OP(4'b0010),
		.CTRL_ALU_ZERO(),
		.OUT(PC_ALU_out)
	);
	
	// Mux for select PC Src
	mux_64 PCMux(
		.in_1(PC_plus4),
		.in_2(PC_ALU_out),
		.ctrl(CTRL_JUMP),
		.out(temp_pc)
	);
	
	// Mux for write back
	mux_64 WriteRegMux(
		.in_1(ALU_RESULT),
		.in_2(DMEM_RD_DATA),
		.ctrl(CTRL_MEM2REG),
		.out(DMEM_WR_Back)
	);
	
	assign DMEM_Addr = ALU_RESULT;
	assign DMEM_WR_DATA = RD_DATA2;
	assign PC_to_INSTRUCT_MEM = PC;
	assign RD_REG1 = INSTRUCT_MEM_OUT[9:5];
	assign WR_REG  = INSTRUCT_MEM_OUT[4:0];
	assign branch_zero =  (ALU_zero_flag & CTRL_BRANCH);
	assign CTRL_JUMP = (CTRL_UNCOND_BRANCH | branch_zero);
	
	initial begin
		PC = 64'b0;
	end
	
	always @(posedge CLK) begin
		PC <= temp_pc;
	end
	

endmodule

module mux_64 (
	input [63:0] in_1,
	input [63:0] in_2,
	input ctrl,
	output reg [63:0] out
);
	always @* begin
		if (ctrl == 0) begin
			out = in_1;
		end else begin
			out = in_2;
		end
	end

endmodule

module mux_5 (
	input [4:0] in_1,
	input [4:0] in_2,
	input ctrl,
	output reg [4:0] out
); 
	always @* begin
		if (ctrl == 0) begin
			out = in_1;
		end else begin
			out = in_2;
		end
	end

endmodule

module sign_ext(
	input [31:0] instruction,
	output reg [63:0] ext_out
);

	always @* begin
		// B format (Opcode: 000101)
		if (instruction[31:26] == 6'b000101) begin 
			ext_out = {{38{instruction[25]}}, instruction[25:0]};
		end
		// CBZ format (Opcode: 10110100)
		else if (instruction[31:24] == 8'b10110100) begin
			ext_out = {{45{instruction[23]}}, instruction[23:5]};
		end
		// LDUR/STUR format (Opcodes: 11111000010 or 11111000000)
		else if (instruction[31:21] == 11'b11111000010 || instruction[31:21] == 11'b11111000000) begin
			ext_out = {{55{instruction[20]}}, instruction[20:12]};
		end 
		// Default fallback
		else begin
			ext_out = 64'b0;
		end
	end
	
endmodule

module sll_2(
	input [63:0] in,
	output reg [63:0] out
);

	always @(in) begin
		out = in << 2;
	end
endmodule