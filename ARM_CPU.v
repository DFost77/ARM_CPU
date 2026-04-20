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
	reg [63:0] PC_plus4;
	reg [31:0] INSTRUCT_MEM_OUT;
	reg [63:0] INSTRUCT_SIGN_EXT;
	reg [3:0] ALU_CONTROL_OUT;
	wire ALU_ZERO;
	

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