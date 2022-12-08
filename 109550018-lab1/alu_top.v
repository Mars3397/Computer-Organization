// 109550018
`timescale 1ns/1ps

//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:58:01 10/10/2013
// Design Name: 
// Module Name:    alu_top 
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

module alu_top(
               src1,       //1 bit source 1 (input)
               src2,       //1 bit source 2 (input)
               less,       //1 bit less     (input) 
               A_invert,   //1 bit A_invert (input)
               B_invert,   //1 bit B_invert (input)
               cin,        //1 bit carry in (input)
               operation,  //operation      (input)
               result,     //1 bit result   (output)
               cout       //1 bit carry out(output)
               );

input         src1;
input         src2;
input         less;
input         A_invert;
input         B_invert;
input         cin;
input [2-1:0] operation;

output        result;
output        cout;

// output register
reg           result, cout;
// temp register
reg           src1_temp, src2_temp;
// temp variable
reg           temp;

always@(*) begin
    // deal with the invert of src 
    if (A_invert) 
        src1_temp = ~src1;
    else 
        src1_temp = src1;
    
    if (B_invert) 
        src2_temp = ~src2;
    else 
        src2_temp = src2; 
end

always@( * )
begin
    case(operation)
        2'b00: begin 
            // and -> A & B
            // nor -> ~A & ~B
            result = src1_temp & src2_temp; 
            cout = 0;
        end
        2'b01: begin 
            // or -> A | B
            result = src1_temp | src2_temp;
            cout = 0;
        end
        2'b10: begin 
            // add -> A + B + carry in
            // sub -> A + (~B) + 1 for lsb, A + (~B) + carry in for else bits
            { cout, result } = (src1_temp + src2_temp + cin);
        end
        2'b11: begin 
            // set less than
            result = less;
           { cout, temp } = (src1_temp + src2_temp + cin);
        end
    endcase
   
end

endmodule
