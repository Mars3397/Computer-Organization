// 109550018
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
output [2-1:0] RegDst_o;
output         Branch_o;
output		   MemRead_o, MemWrite_o; //
output [2-1:0] Jump_o, MemtoReg_o, BranchType_o; //
 
//Internal Signals
reg    [3-1:0] ALU_op_o;
reg            ALUSrc_o;
reg            RegWrite_o;
reg    [2-1:0] RegDst_o;
reg            Branch_o;
reg 		   MemRead_o, MemWrite_o; //
reg    [2-1:0] Jump_o, MemtoReg_o, BranchType_o; // 

//Parameter

//Main function
always @(*) begin
	case(instr_op_i)
		// r-formats : add, sub, and, or, slt, jr
        6'b000000: begin
			{ ALU_op_o, RegWrite_o, ALUSrc_o, RegDst_o, Branch_o } <= 8'b01010010;
			case(function_i)
				6'b001000: begin // jr
					{ Jump_o, MemRead_o, MemWrite_o, MemtoReg_o, BranchType_o } <= 8'b10000000;
				end
				default: begin
					{ Jump_o, MemRead_o, MemWrite_o, MemtoReg_o, BranchType_o } <= 8'b01000000;
				end
			endcase
		end
        // addi
        6'b001000: begin
			{ ALU_op_o, RegWrite_o, ALUSrc_o, RegDst_o, Branch_o } <= 8'b00011000;
			{ Jump_o, MemRead_o, MemWrite_o, MemtoReg_o, BranchType_o } <= 8'b01000000;
		end
        // beq
        6'b000100: begin
			{ ALU_op_o, RegWrite_o, ALUSrc_o, RegDst_o, Branch_o } <= 8'b00100011;
			{ Jump_o, MemRead_o, MemWrite_o, MemtoReg_o, BranchType_o } <= 8'b01000000; //
		end
        // slti
        6'b001010: begin 
			{ ALU_op_o, RegWrite_o, ALUSrc_o, RegDst_o, Branch_o } <= 8'b01111000;
			{ Jump_o, MemRead_o, MemWrite_o, MemtoReg_o, BranchType_o } <= 8'b01000001;
		end
		// lw
		6'b100011: begin
			{ ALU_op_o, RegWrite_o, ALUSrc_o, RegDst_o, Branch_o } <= 8'b00011000;
			{ Jump_o, MemRead_o, MemWrite_o, MemtoReg_o, BranchType_o } <= 8'b01100101;
		end
		// sw
		6'b101011: begin
			{ ALU_op_o, RegWrite_o, ALUSrc_o, RegDst_o, Branch_o } <= 8'b00001010;
			{ Jump_o, MemRead_o, MemWrite_o, MemtoReg_o, BranchType_o } <= 8'b01010001;
		end
		// jump
		6'b000010: begin
			{ ALU_op_o, RegWrite_o, ALUSrc_o, RegDst_o, Branch_o } <= 8'b00000010; 
			{ Jump_o, MemRead_o, MemWrite_o, MemtoReg_o, BranchType_o } <= 8'b00000001; 
		end
		// jal
		6'b000011: begin
			{ ALU_op_o, RegWrite_o, ALUSrc_o, RegDst_o, Branch_o } <= 8'b00010100; // RegDst ?
			{ Jump_o, MemRead_o, MemWrite_o, MemtoReg_o, BranchType_o } <= 8'b00011101; //
		end
        // default
        default: begin
			{ ALU_op_o, RegWrite_o, ALUSrc_o, RegDst_o, Branch_o } <= 8'bxxxxxxxx;
			{ Jump_o, MemRead_o, MemWrite_o, MemtoReg_o, BranchType_o } <= 8'bxxxxxxxx;
		end
	endcase
end

endmodule





                    
                    