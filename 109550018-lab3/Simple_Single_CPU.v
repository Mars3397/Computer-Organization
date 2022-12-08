// 109550018
`timescale 1ns/1ps
module Simple_Single_CPU(
        clk_i,
        rst_i,
        pc,
        pc_pre,
        pc_next0,
        pc_next1,
        instruction,
        writeReg1,
        rsData, rtData,
        regWrite, branch, ALUsrc, MemRead, MemWrite,
        MemtoReg, BranchType, Jump, regDst,
        ALUop,
        signExtended, leftShifted,
        ALUcontrol, MUX_ALUsrc, ALUresult,
        zero, ReadData, toReg, jump_out, mux4_o
        );
		
//I/O port
input         clk_i;
input         rst_i;

//Internal Signles
// PC
output wire [32-1:0] pc_pre, pc, pc_next0, pc_next1;
// Instruction memory
output wire [32-1:0] instruction;
// Register File
output wire [5-1:0] writeReg1;
output wire [32-1:0] rsData, rtData;
wire [32-1:0] writeData;
// Decoder
output wire regWrite, branch, ALUsrc, MemRead, MemWrite;
output wire [2-1:0] MemtoReg, BranchType, Jump, regDst;
output wire [3-1:0] ALUop;
// sign extension
output wire [32-1:0] signExtended;
// shift left
output wire [32-1:0] leftShifted;
// ALU control
output wire [4-1:0] ALUcontrol;
// ALU
output wire [32-1:0] MUX_ALUsrc, ALUresult;
output wire zero;
// Data Memory 
output wire [32-1:0] ReadData;
// MUX for register
output wire [32-1:0] toReg;
// MUX for jump
output wire [32-1:0] jump_out;
// 4 MUX for branch
output wire mux4_o;

//Greate componentes
ProgramCounter PC(
        .clk_i(clk_i),      
        .rst_i(rst_i),     
        .pc_in_i(pc_pre),   
        .pc_out_o(pc) 
        );
	
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
MUX_3to1 #(.size(5)) Mux_Write_Reg(
        .data0_i(instruction[20:16]),
        .data1_i(instruction[15:11]),
        .data2_i(5'd31), //
        .select_i(regDst),
        .data_o(writeReg1)
        );	
		
Reg_File Registers(
        .clk_i(clk_i),      
        .rst_i(rst_i),     
        .RSaddr_i(instruction[25:21]),  
        .RTaddr_i(instruction[20:16]),  
        .RDaddr_i(writeReg1),
        .RDdata_i(toReg), 
        .RegWrite_i(regWrite),
        .RSdata_o(rsData), 
        .RTdata_o(rtData)     
        );
	
Decoder Decoder(
        .instr_op_i(instruction[31:26]), 
        .function_i(instruction[5:0]), ///
        .RegWrite_o(regWrite), 
        .ALU_op_o(ALUop),   
        .ALUSrc_o(ALUsrc),   
        .RegDst_o(regDst),   
        .Branch_o(branch),
        .Jump_o(Jump),
        .MemRead_o(MemRead),
        .MemWrite_o(MemWrite),
        .MemtoReg_o(MemtoReg),
        .BranchType_o(BranchType)
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
	
Data_Memory Data_Memory(
	.clk_i(clk_i),
	.addr_i(ALUresult),
	.data_i(rtData),
	.MemRead_i(MemRead),
	.MemWrite_i(MemWrite),
	.data_o(ReadData)
	);

// address adder for pc
Adder Adder2(
        .src1_i(pc_next0),     
        .src2_i(leftShifted),     
        .sum_o(pc_next1)      
        );
		
Shift_Left_Two_32 Shifter(
        .data_i(signExtended),
        .data_o(leftShifted)
        ); 		
		
MUX_3to1 #(.size(32)) Mux_PC_Source(
        .data0_i({pc_next0[31:28], instruction[25:0], 2'b00}),
        .data1_i(jump_out),
        .data2_i(rsData), //
        .select_i(Jump),
        .data_o(pc_pre)
        );	

MUX_4to1 #(.size(32)) MUX_reg (
        .data0_i(ALUresult),
        .data1_i(ReadData),
        .data2_i(signExtended),
        .data3_i(pc_next0), //
        .select_i(MemtoReg),
        .data_o(toReg)
);

MUX_2to1 #(.size(32)) MUX_jump (
        .data0_i(pc_next0),
        .data1_i(pc_next1),
        .select_i(branch & mux4_o),
        .data_o(jump_out)
);

MUX_4to1 #(.size(1)) MUX_4 (
        .data0_i(zero),
        .data1_i(~(ALUresult[31] | zero)),
        .data2_i(~ALUresult[31]),
        .data3_i(~zero),
        .select_i(BranchType),
        .data_o(mux4_o)
);

endmodule
		  


