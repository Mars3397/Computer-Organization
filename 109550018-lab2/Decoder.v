//// 109550018
////Subject:     CO project 2 - Decoder
////--------------------------------------------------------------------------------
////Version:     1
////--------------------------------------------------------------------------------
////Writer:      Luke
////----------------------------------------------
////Date:        
////----------------------------------------------
////Description: 
////--------------------------------------------------------------------------------
`timescale 1ns/1ps
module Decoder(
    instr_op_i,
	RegWrite_o,
	ALU_op_o,
	ALUSrc_o,
	RegDst_o,
	Branch_o
	);
     
//I/O ports
input  [6-1:0] instr_op_i;

output         RegWrite_o;
output [3-1:0] ALU_op_o;
output         ALUSrc_o;
output         RegDst_o;
output         Branch_o;
 
//Internal Signals
reg    [3-1:0] ALU_op_o;
reg            ALUSrc_o;
reg            RegWrite_o;
reg            RegDst_o;
reg            Branch_o;

//Main function
always @ (*) begin
    case (instr_op_i)
        // r-formats : add, sub, and, or, slt
        6'b000000: { ALU_op_o, RegWrite_o, ALUSrc_o, RegDst_o, Branch_o } <= 7'b0101010;
        // addi
        6'b001000: { ALU_op_o, RegWrite_o, ALUSrc_o, RegDst_o, Branch_o } <= 7'b0001100;
        // beq
        6'b000100: { ALU_op_o, RegWrite_o, ALUSrc_o, RegDst_o, Branch_o } <= 7'b0010001;
        // slti
        6'b001010: { ALU_op_o, RegWrite_o, ALUSrc_o, RegDst_o, Branch_o } <= 7'b0111100;
        // default
        default: { ALU_op_o, RegWrite_o, ALUSrc_o, RegDst_o, Branch_o } <= 7'bxxxxxxx;
    endcase
end

endmodule