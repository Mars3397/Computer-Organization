// 109550018 郭昀

module Sign_Extend(
    data_i,
    data_o
    );
               
//I/O ports
input   [16-1:0] data_i;
output  [32-1:0] data_o;

//Internal Signals
reg     [32-1:0] data_o;
integer i;

//Sign extended
always @(*) begin
    data_o[15:0] = data_i[15:0];
    for (i = 16; i < 32; i = i + 1)
        data_o[i] = data_i[15];
end

endmodule      
     