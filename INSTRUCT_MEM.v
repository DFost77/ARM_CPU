module INSTRUCT_MEM (
	input [63:0] PC_IN,
	output reg [31:0] INSTRUCT_OUT
);
	// Reserve space for 13 instructions
	reg [7:0] instruct_mem[63:0];
	
	initial begin
		// LDUR R2, [R10]
		instruct_mem[0] = 8'h42;
		instruct_mem[1] = 8'h01;
		instruct_mem[2] = 8'h40;
		instruct_mem[3] = 8'hF8;
		
		// LDUR R2, [R10, #1]
		instruct_mem[4] = 8'h43;
		instruct_mem[5] = 8'h11;
		instruct_mem[6] = 8'h04;
		instruct_mem[7] = 8'hF8;
		
		// SUB R4, R3, R2
		instruct_mem[8] = 8'h64;
		instruct_mem[9] = 8'h00;
		instruct_mem[10] = 8'h02;
		instruct_mem[11] = 8'hCB;
		
		// ADD R5, R3, R2
		instruct_mem[12] = 8'h65;
		instruct_mem[13] = 8'h00;
		instruct_mem[14] = 8'h02;
		instruct_mem[15] = 8'h8B;
		
		// CBZ R1, #2
		instruct_mem[16] = 8'h41;
		instruct_mem[17] = 8'h00;
		instruct_mem[18] = 8'h00;
		instruct_mem[19] = 8'hB4;
		
		// CBZ R0, #2
		instruct_mem[20] = 8'h40;
		instruct_mem[21] = 8'h00;
		instruct_mem[22] = 8'h00;
		instruct_mem[23] = 8'hB4;
		
		// LDUR R2, [R10]
		instruct_mem[24] = 8'h42;
		instruct_mem[25] = 8'h01;
		instruct_mem[26] = 8'h40;
		instruct_mem[27] = 8'hF8;
		
		// ORR R6, R2, R3 
		instruct_mem[28] = 8'h46;
		instruct_mem[29] = 8'h00;
		instruct_mem[30] = 8'h03;
		instruct_mem[31] = 8'hAA;
		
		// AND R7, R2, R3
		instruct_mem[32] = 8'h47;
		instruct_mem[33] = 8'h00;
		instruct_mem[34] = 8'h03;
		instruct_mem[35] = 8'h8A;
		
		// STUR R4, [R7, #1]
		instruct_mem[36] = 8'hE4;
		instruct_mem[37] = 8'h10;
		instruct_mem[38] = 8'h00;
		instruct_mem[39] = 8'hF8;
		
		// B #2
		instruct_mem[40] = 8'h03;
		instruct_mem[41] = 8'h00;
		instruct_mem[42] = 8'h00;
		instruct_mem[43] = 8'h14;
		
		// LDUR R3, [R10, #1]
		instruct_mem[44] = 8'h43;
		instruct_mem[45] = 8'h11;
		instruct_mem[46] = 8'h40;
		instruct_mem[47] = 8'hF8;
		
		// ADD R8, R0, R1
		instruct_mem[48] = 8'h08;
		instruct_mem[49] = 8'h00;
		instruct_mem[50] = 8'h01;
		instruct_mem[51] = 8'h8B;
	end 
	
	// On PC_IN change
	always @(PC_IN) begin
		INSTRUCT_OUT[7:0] = instruct_mem[PC_IN];
		INSTRUCT_OUT[15:8] = instruct_mem[PC_IN+1];
		INSTRUCT_OUT[23:16] = instruct_mem[PC_IN+2];
		INSTRUCT_OUT[31:24] = instruct_mem[PC_IN+3];
	end
	
endmodule	