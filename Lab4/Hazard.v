// 109550018 郭昀

module Hazard(
	MemRead_s3, 
    RegisterRs, 
    RegisterRt, 
    RegisterRt_s3,
	branch, 
	pc_stall, 
	ID_stall, 
	IF_flush, 
	ID_flush, 
	EX_flush
);

// I/O ports
input [4:0] RegisterRs, RegisterRt, RegisterRt_s3;
input MemRead_s3, branch;
output reg pc_stall, ID_stall, IF_flush, ID_flush, EX_flush;

// Main function
always @(*) begin
	{ pc_stall, ID_stall, IF_flush, ID_flush, EX_flush } = 5'b00000;

	if (MemRead_s3 && ((RegisterRt_s3 == RegisterRs) || (RegisterRt_s3 == RegisterRt))) 
		{ pc_stall, ID_stall, ID_flush } = 3'b111;
	
		
	if (branch)
		{ IF_flush, ID_flush, EX_flush } = 3'b111;
end

endmodule