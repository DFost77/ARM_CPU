module ARM_CPU (
	input CLK,
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
	reg [63:0] PC_to_INSTRUCT_MEM;
	wire [63:0] PC_plus4;
	wire [31:0] INSTRUCT_MEM_OUT;
	wire [63:0] INSTRUCT_SIGN_EXT;
	wire [3:0] ALU_CONTROL_OUT;
	wire ALU_ZERO;
	
	

endmodule