//  109550018 郭昀

`timescale 1ns / 1ps

module Pipe_Reg(
    clk_i,
    rst_i,
    data_i,
    keep_i,
    flush_i,
    data_o
    );
					
parameter size = 0;

input   clk_i;		  
input   rst_i;
input   keep_i;
input   flush_i;
input   [size-1:0] data_i;
output reg  [size-1:0] data_o;
	  
always@(posedge clk_i) begin
    if(~rst_i)
        data_o <= 0;
    else if (keep_i)
        data_o <= data_o;
    else if (flush_i)
        data_o <= 0;
    else
        data_o <= data_i;
end

endmodule	