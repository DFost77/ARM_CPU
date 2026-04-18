module REG_FILE(
	input [4:0] RD_REG1,
	input [4:0] RD_REG2,
	input [4:0] WR_REG,
	input [63:0] WR_DATA,
	input CTRL_REG_WR,
	output reg [63:0] RD_DATA1,
	output reg [63:0] RD_DATA2
);
	// Create 32 64-bit registers
	reg [63:0] REG_DATA[31:0];
	
	// Fill all regs with 0
	integer c;
	initial begin
		for (c = 0; c < 32; c = c+1) begin
			REG_DATA[c] = 0;
		end
	end
	
	// On any input change
	always @(RD_REG1, RD_REG2, WR_REG, WR_DATA, CTRL_REG_WR) begin
		// Read register data
		RD_DATA1 = REG_DATA[RD_REG1];
		RD_DATA2 = REG_DATA[RD_REG2];
		
		// If RegWrite is enabled, write to reg
		if (CTRL_REG_WR == 1) begin
			REG_DATA[WR_REG] = WR_DATA;
		end
	end
	
endmodule
