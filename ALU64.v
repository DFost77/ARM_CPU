module ALU64 (
	input [63:0] ARG1,
	input [63:0] ARG2,
	input [3:0] CTRL_ALU_OP,
	output reg CTRL_ALU_ZERO,
	output reg [63:0] OUT
);
	// Update on input change
	always @(ARG1, ARG2, CTRL_ALU_OP) begin
	
		// Choose output based on ALU OP
		case (CTRL_ALU_OP)
			4'b0000 : OUT = ARG1 & ARG2;
			4'b0001 : OUT = ARG1 | ARG2;
			4'b0010 : OUT = ARG1 + ARG2;
			4'b0110 : OUT = ARG1 - ARG2;
			4'b0111 : OUT = ARG2;
			4'b1100 : OUT = ~(ARG1 | ARG2);
		endcase
		
		// Set zero flag on zero result 
		CTRL_ALU_ZERO = (OUT == 0) ? 1'b1 : 1'b0;
		
	end
endmodule