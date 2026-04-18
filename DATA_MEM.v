module DATA_MEM(
	input [63:0] ADDR,
	input [63:0] WR_DATA,
	input CTRL_MEM_RD,
	input CTRL_MEM_WR,
	output reg [63:0] RD_DATA
);
	
	// Create 32 64-bit memory
	reg [63:0] MEM_DATA[31:0];
	
	// Fill all memory with 0
	integer c;
	initial begin
		for (c = 0; c < 32; c = c+1) begin
			MEM_DATA[c] = 0;
		end
	end
	
	// On any input change
	always @(ADDR, WR_DATA, CTRL_MEM_RD, CTRL_MEM_WR) begin
		// If MemWrite is enabled, write to mem
		if (CTRL_MEM_WR == 1) begin
			MEM_DATA[ADDR] = WR_DATA;
		end
		
		// If MemRead is enabled, read mem data
		if (CTRL_MEM_RD == 1) begin
			RD_DATA = MEM_DATA[ADDR];
		end
	end
	
endmodule