module ALU_CTRL (
	input [10:0] opcode,
	input [1:0] ALUOp,
	output reg [3:0] ALU_Ctrl_Out
);

	always @(opcode, ALUOp) begin
		ALU_Ctrl_Out = 4'b0010;
		casex(ALUOp)
			2'b00 : ALU_Ctrl_Out = 4'b0010;
			2'bX1 : ALU_Ctrl_Out = 4'b0111;
			2'b1X : begin
				case (opcode) 
					11'b10001011000 : ALU_Ctrl_Out = 4'b0010;
					11'b11001011000 : ALU_Ctrl_Out = 4'b0110;
					11'b10001010000 : ALU_Ctrl_Out = 4'b0000;
					11'b10101010000 : ALU_Ctrl_Out = 4'b0001;
					default : ALU_Ctrl_Out = 4'b0010;
				endcase
			end
			default : ALU_Ctrl_Out = 4'b0010;
		endcase
	end
endmodule