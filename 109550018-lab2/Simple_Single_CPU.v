// 109550018
//Subject:     CO project 2 - Simple Single CPU
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Writer:      
//----------------------------------------------
//Date:        
//----------------------------------------------
//Description: 
//--------------------------------------------------------------------------------
`timescale 1ns/1ps
module Simple_Single_CPU(
        clk_i,
		rst_i
		);
		
//I/O port
input         clk_i;
input         rst_i;

//Internal Signles
// PC
wire [32-1:0] pc_pre, pc, pc_next0, pc_next1;
// Instruction memory
wire [32-1:0] instruction;
// Register File
wire [5-1:0] writeReg1;
wire [32-1:0] rsData, rtData, writeData;
// Decoder
wire regDst, regWrite, branch, ALUsrc;
wire [3-1:0] ALUop;
// sign extension
wire [32-1:0] signExtended;
// shift left
wire [32-1:0] leftShifted;
// ALU control
wire [4-1:0] ALUcontrol;
// ALU
wire [32-1:0] MUX_ALUsrc, ALUresult;
wire zero;


//Greate componentes
ProgramCounter PC(
        .clk_i(clk_i),      
	    .rst_i (rst_i),     
	    .pc_in_i(pc_pre) ,   
	    .pc_out_o(pc) 
	    );
	
// pc next adder
Adder Adder1(
        .src1_i(pc),     
	    .src2_i(32'd4),     
	    .sum_o(pc_next0)    
	    );
	
Instr_Memory IM(
        .pc_addr_i(pc),  
	    .instr_o(instruction)    
	    );

// MUX for write reg 1
MUX_2to1 #(.size(5)) Mux_Write_Reg(
        .data0_i(instruction[20:16]),
        .data1_i(instruction[15:11]),
        .select_i(regDst),
        .data_o(writeReg1)
        );	
		
Reg_File RF(
        .clk_i(clk_i),      
	    .rst_i(rst_i) ,     
        .RSaddr_i(instruction[25:21]) ,  
        .RTaddr_i(instruction[20:16]) ,  
        .RDaddr_i(writeReg1) ,  
        .RDdata_i(ALUresult), 
        .RegWrite_i(regWrite),
        .RSdata_o(rsData) ,  
        .RTdata_o(rtData)   
        );
	
Decoder Decoder(
        .instr_op_i(instruction[31:26]), 
	    .RegWrite_o(regWrite), 
	    .ALU_op_o(ALUop),   
	    .ALUSrc_o(ALUsrc),   
	    .RegDst_o(regDst),   
		.Branch_o(branch)   
	    );

ALU_Ctrl AC(
        .funct_i(instruction[5:0]),   
        .ALUOp_i(ALUop),   
        .ALUCtrl_o(ALUcontrol) 
        );
	
Sign_Extend SE(
        .data_i(instruction[15:0]),
        .data_o(signExtended)
        );

// MUX for ALU input
MUX_2to1 #(.size(32)) Mux_ALUSrc(
        .data0_i(rtData),
        .data1_i(signExtended),
        .select_i(ALUsrc),
        .data_o(MUX_ALUsrc)
        );	
		
ALU ALU(
        .src1_i(rsData),
	    .src2_i(MUX_ALUsrc),
	    .ctrl_i(ALUcontrol),
	    .result_o(ALUresult),
		.zero_o(zero)
	    );

// address adder for pc
Adder Adder2(
        .src1_i(leftShifted),     
	    .src2_i(pc_next0),     
	    .sum_o(pc_next1)      
	    );
		
Shift_Left_Two_32 Shifter(
        .data_i(signExtended),
        .data_o(leftShifted)
        ); 		

// MUX for pc sourse
MUX_2to1 #(.size(32)) Mux_PC_Source(
        .data0_i(pc_next0),
        .data1_i(pc_next1),
        .select_i(branch & zero),
        .data_o(pc_pre)
        );	

endmodule