// 109550018 郭昀
module Forwarding(
	RegisterRs_s3, 
    RegisterRt_s3, 
    writeReg1_s4,
    writeReg1_s5,
    regWrite_s4, 
    regWrite_s5,
	ForwardA_o,
	ForwardB_o
);

// I/O ports
input [4:0] RegisterRs_s3, RegisterRt_s3, writeReg1_s4, writeReg1_s5;
input regWrite_s4, regWrite_s5;
output reg [1:0] ForwardA_o, ForwardB_o;

// s3 -> EX
// s4 -> MEM
// s5 -> WB

// Main function
always @(*) begin
    if (regWrite_s4 && (writeReg1_s4 != 0) && (writeReg1_s4 == RegisterRs_s3))
        ForwardA_o = 2'b01;
    else if (regWrite_s5 && (writeReg1_s5 != 0) && (writeReg1_s5 == RegisterRs_s3)) 
        ForwardA_o = 2'b10;
    else
        ForwardA_o = 2'b00;

    if (regWrite_s4 && (writeReg1_s4 != 0) && (writeReg1_s4 == RegisterRt_s3))
        ForwardB_o = 2'b01;
    else if (regWrite_s5 && (writeReg1_s5 != 0) && (writeReg1_s5 == RegisterRt_s3))
        ForwardB_o = 2'b10;
    else
        ForwardB_o = 2'b00;
end
endmodule