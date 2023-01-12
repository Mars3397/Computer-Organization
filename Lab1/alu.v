// 109550018
`timescale 1ns/1ps

//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date:    15:15:11 08/18/2013
// Design Name:
// Module Name:    alu
// Project Name:
// Target Devices:
// Tool versions:
// Description:
//
// Dependencies:
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////////////

module alu(
           clk,           // system clock              (input)
           rst_n,         // negative reset            (input)
           src1,          // 32 bits source 1          (input)
           src2,          // 32 bits source 2          (input)
           ALU_control,   // 4 bits ALU control input  (input)
           result,        // 32 bits result            (output)
           zero,          // 1 bit when the output is 0, zero must be set (output)
           cout,          // 1 bit carry out           (output)
           overflow       // 1 bit overflow            (output)
           );

input           clk;
input           rst_n;
input  [32-1:0] src1;
input  [32-1:0] src2;
input   [4-1:0] ALU_control;

output [32-1:0] result;
output          zero;
output          cout;
output          overflow;

reg    [32-1:0] result;
reg             zero;
reg             cout;
reg             overflow;

// carry out array -> store carry out of each ALU
wire [32-1:0] carry_out;
// 31th bit of the result of A - B = 1 -> set = 1, else -> set = 0
wire set;
assign set = (src1[31] ^ (~src2[31]) ^ carry_out[30]);
// store the temp result
wire [32-1:0] temp_result;

// ALU for bit 0
alu_top alu_0 (
    .src1(src1[0]),
    .src2(src2[0]),
    .less(set),  // lsb less = msb set
    .A_invert(ALU_control[3]), // convert A to ~A when ALU_control[3]=1 -> operation = nor
    .B_invert(ALU_control[2]), // convert B to ~B when ALU_control[2]=1 -> operation = sub, nor, slt
    .cin(ALU_control[3:2] == 2'b01), // carry in of the ALU in lsb = 1 only when the operation = sub -> ALU_control = 01_ _
    .operation(ALU_control[1:0]), 
    .result(temp_result[0]),
    .cout(carry_out[0])
);
        
 // generate ALU for all the other bits
 generate
    genvar i; // declare a iterator
    for (i = 1; i < 32; i = i + 1) begin
        alu_top alu_i(
            .src1(src1[i]),
            .src2(src2[i]),
            .less(1'b0),  // less = 0 for bits != bit 0
            .A_invert(ALU_control[3]), // convert A to ~A when ALU_control[3]=1 -> operation = nor
            .B_invert(ALU_control[2]), // convert B to ~B when ALU_control[2]=1 -> operation = sub, nor, slt
            .cin(carry_out[i-1]), // carry in = carry out of previous bit
            .operation(ALU_control[1:0]), 
            .result(temp_result[i]),
            .cout(carry_out[i])
        );
    end
 endgenerate

always@( posedge clk or negedge rst_n ) 
begin
	if(!rst_n) begin
	   // reset the output
        cout = 0;
        zero = 0;
        overflow = 0;
        result = 0;
	end
	else begin 
	    // reset the output
	    cout = 0;
	    zero = 0;
        overflow = 0;
        // assign the temp result value to output result
        result = temp_result;
        
        // handle carry out and overflow : only when the operation is add or sub
        if (ALU_control[1:0] == 2'b10) begin
             // 32-bit ALU carry out = msb carry out
            cout = carry_out[31];
            
             // add : two src are same sign and the sign of result are opposite to the src
             if (~ALU_control[2] && src1[31] == src2[31] && src1[31] != result[31])
                overflow = 1;
              // sub : two src are opposite sign and the sign of result are opposite to the src1
             else if (ALU_control[2] && src1[31] != src2[31] && src1[31] != result[31])
                overflow = 1;
        end
        
        // handle zero
        if (result == 0)
            zero = 1;
        else
            zero = 0; 
	end
end

endmodule
