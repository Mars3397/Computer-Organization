// 109550018 郭昀
`timescale 1ns/1ps

module Decoder(
    instr_op_i,
	function_i,
	RegWrite_o,
	ALU_op_o,
	ALUSrc_o,
	RegDst_o,
	Branch_o,
	Jump_o, 
	MemRead_o, 
	MemWrite_o,
	MemtoReg_o,
	BranchType_o
	);
     
//I/O ports
input  [6-1:0] instr_op_i;
input  [6-1:0] function_i;

output         RegWrite_o;
output [3-1:0] ALU_op_o;
output         ALUSrc_o;
output         RegDst_o;
output         Branch_o;
output		   MemRead_o, MemWrite_o, Jump_o, MemtoReg_o; //
output [2-1:0] BranchType_o; //
 
//Internal Signals
reg    [3-1:0] ALU_op_o;
reg            ALUSrc_o;
reg            RegWrite_o;
reg            RegDst_o;
reg            Branch_o;
reg 		       MemRead_o, MemWrite_o, Jump_o, MemtoReg_o; //
reg    [2-1:0] BranchType_o; // 

//Parameter

//Main function
always @(*) begin
	case(instr_op_i)
		// r-formats : add, sub, and, or, slt, jr
        6'b000000: begin
			{ ALU_op_o, RegWrite_o, ALUSrc_o, RegDst_o, Branch_o } <= 7'b0101010;
			case(function_i)
				6'b001000: begin // jr
					{ Jump_o, MemRead_o, MemWrite_o, MemtoReg_o, BranchType_o } <= 6'b0000000;
				end
				default: begin
					{ Jump_o, MemRead_o, MemWrite_o, MemtoReg_o, BranchType_o } <= 6'b100000;
				end
			endcase
		end
        // addi
        6'b001000: begin
			{ ALU_op_o, RegWrite_o, ALUSrc_o, RegDst_o, Branch_o } <= 7'b0001100;
			{ Jump_o, MemRead_o, MemWrite_o, MemtoReg_o, BranchType_o } <= 6'b100000;
		end
        // beq
        6'b000100: begin
			{ ALU_op_o, RegWrite_o, ALUSrc_o, RegDst_o, Branch_o } <= 7'b0010011;
			{ Jump_o, MemRead_o, MemWrite_o, MemtoReg_o, BranchType_o } <= 6'b100000; //
		end
		// bne
        6'b000101: begin
			{ ALU_op_o, RegWrite_o, ALUSrc_o, RegDst_o, Branch_o } <= 7'b0100011;
			{ Jump_o, MemRead_o, MemWrite_o, MemtoReg_o, BranchType_o } <= 6'b100011; //
		end
		// bge
        6'b000001: begin
			{ ALU_op_o, RegWrite_o, ALUSrc_o, RegDst_o, Branch_o } <= 7'b0100011;
			{ Jump_o, MemRead_o, MemWrite_o, MemtoReg_o, BranchType_o } <= 6'b100001; //
		end
		// bgt
        6'b000111: begin
			{ ALU_op_o, RegWrite_o, ALUSrc_o, RegDst_o, Branch_o } <= 7'b0100011;
			{ Jump_o, MemRead_o, MemWrite_o, MemtoReg_o, BranchType_o } <= 6'b100010; //
		end
        // slti
        6'b001010: begin 
			{ ALU_op_o, RegWrite_o, ALUSrc_o, RegDst_o, Branch_o } <= 7'b0111100;
			{ Jump_o, MemRead_o, MemWrite_o, MemtoReg_o, BranchType_o } <= 6'b100001;
		end
		// lw
		6'b100011: begin
			{ ALU_op_o, RegWrite_o, ALUSrc_o, RegDst_o, Branch_o } <= 7'b0001100;
			{ Jump_o, MemRead_o, MemWrite_o, MemtoReg_o, BranchType_o } <= 6'b110101;
		end
		// sw
		6'b101011: begin
			{ ALU_op_o, RegWrite_o, ALUSrc_o, RegDst_o, Branch_o } <= 7'b0000110;
			{ Jump_o, MemRead_o, MemWrite_o, MemtoReg_o, BranchType_o } <= 6'b101001;
		end
		// jump
		6'b000010: begin
			{ ALU_op_o, RegWrite_o, ALUSrc_o, RegDst_o, Branch_o } <= 7'b0000010; 
			{ Jump_o, MemRead_o, MemWrite_o, MemtoReg_o, BranchType_o } <= 6'b000001; 
		end
		// jal
		6'b000011: begin
			{ ALU_op_o, RegWrite_o, ALUSrc_o, RegDst_o, Branch_o } <= 7'b0001100; // RegDst ?
			{ Jump_o, MemRead_o, MemWrite_o, MemtoReg_o, BranchType_o } <= 6'b001101; //
		end
        // default
        default: begin
			{ ALU_op_o, RegWrite_o, ALUSrc_o, RegDst_o, Branch_o } <= 7'bxxxxxxx;
			{ Jump_o, MemRead_o, MemWrite_o, MemtoReg_o, BranchType_o } <= 6'bxxxxxx;
		end
	endcase
end

endmodule





                    
                    