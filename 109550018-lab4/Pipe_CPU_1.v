// 109550018 郭昀

`timescale 1ns / 1ps

module Pipe_CPU_1(
    clk_i,
    rst_i,
    // pc_pre, pc, pc_next0, instruction, branch_select,
    // pc_next0_s2, instruction_s2, rsData, rtData, signExtended, 
    // MemtoReg, regDst, regWrite, branch, ALUsrc, Jump, MemRead, MemWrite, 
    // BranchType, ALUop, pc_next0_s3, leftShifted, pc_next1_s3, 
    // rsData_s3, rtData_s3, MUX_ALUsrc, ALUresult, 
    // zero, signExtended_s3, ALUcontrol, Instruction_s3, writeReg1, 
    // MemtoReg_s3, regDst_s3, regWrite_s3, branch_s3, ALUsrc_s3, MemRead_s3, MemWrite_s3,
    // ALUop_s3, pc_next1_s4, zero_s4,  ALUresult_s4, ReadData,
    // writeReg1_s4, MemtoReg_s4, regWrite_s4, branch_s4, MemRead_s4, MemWrite_s4, 
    // ReadData_s5, ALUresult_s5, toReg, writeReg1_s5,
    // MemtoReg_s5, regWrite_s5,
    // pc_stall,ID_stall,MemtoReg_s2, regDst_s2, regWrite_s2, branch_s2, ALUsrc_s2, MemRead_s2, MemWrite_s2,
    // ALUop_s2, MemtoReg_s33, regWrite_s33, branch_s33, MemRead_s33, MemWrite_s33, ForwardA, ForwardB, 
    // ALU_rs, ALU_rt, ALU_rt_s4, instruction_s4, Branch_new, BranchType_s2, BranchType_s3, BranchType_s33, BranchType_s4,
    // Branch_new_s4, IF_flush, ID_flush, EX_flush, branch_select
    );
    
/****************************************
I/O ports
****************************************/
input clk_i;
input rst_i;

/****************************************
Internal signal
****************************************/
/**** IF stage ****/
// output 
wire [32-1:0] pc_pre, pc, pc_next0;
// output 
wire [32-1:0] instruction;

//control signal
// output 
wire branch_select;

/**** ID stage ****/
// output 
wire [32-1:0] pc_next0_s2, instruction_s2, rsData, rtData, signExtended;

//control signal
// output 
wire MemtoReg, regDst, regWrite, branch, ALUsrc, Jump, MemRead, MemWrite;
// output 
wire [2-1:0] BranchType;
// output 
wire [3-1:0] ALUop;

/**** EX stage ****/
// output 
wire [32-1:0] pc_next0_s3, leftShifted, pc_next1_s3;
// output 
wire [32-1:0] rsData_s3, rtData_s3, MUX_ALUsrc, ALUresult;
// output 
wire zero;
// output 
wire [32-1:0] signExtended_s3;
// output 
wire [4-1:0] ALUcontrol;
// output 
wire [32-1:0] Instruction_s3;
// output 
wire [5-1:0] writeReg1;

//control signal
// output 
wire MemtoReg_s3, regDst_s3, regWrite_s3, branch_s3, ALUsrc_s3, MemRead_s3, MemWrite_s3;
// output 
wire [3-1:0] ALUop_s3;

/**** MEM stage ****/
// output 
wire [32-1:0] pc_next1_s4;
// output 
wire zero_s4;
// output 
wire [32-1:0] ALUresult_s4, ReadData;
// output 
wire [5-1:0] writeReg1_s4;

//control signal
// output 
wire MemtoReg_s4, regWrite_s4, branch_s4, MemRead_s4, MemWrite_s4;

/**** WB stage ****/
// output 
wire [32-1:0] ReadData_s5, ALUresult_s5, toReg;
// output 
wire [5-1:0] writeReg1_s5;

//control signal
// output 
wire MemtoReg_s5, regWrite_s5;

// New Add
// output 
wire pc_stall, ID_stall; 
// output 
wire MemtoReg_s2, regDst_s2, regWrite_s2, branch_s2, ALUsrc_s2, MemRead_s2, MemWrite_s2;
// output 
wire [3-1:0] ALUop_s2;
// output 
wire MemtoReg_s33, regWrite_s33, branch_s33, MemRead_s33, MemWrite_s33;
// output 
wire [2-1:0] ForwardA, ForwardB;
// output 
wire [32-1:0] ALU_rs, ALU_rt, ALU_rt_s4;
// output 
wire [32-1:0] instruction_s4;
// output 
wire Branch_new;
// output 
wire Branch_new_s4;
// output 
wire [2-1:0] BranchType_s2, BranchType_s3, BranchType_s33, BranchType_s4;
// output 
wire IF_flush, ID_flush, EX_flush;

/****************************************
Instantiate modules
****************************************/
//Instantiate the components in IF stage
MUX_2to1 #(.size(32)) Mux0(
    .data0_i(pc_next0),
    .data1_i(pc_next1_s4),
    .select_i(branch_select),
    .data_o(pc_pre)
);

ProgramCounter PC(
    .clk_i(clk_i),      
    .rst_i(rst_i),     
    .keep_i(pc_stall),
    .pc_in_i(pc_pre),   
    .pc_out_o(pc) 
);

Instruction_Memory IM(
    .addr_i(pc),
    .instr_o(instruction)
);
			
Adder Add_pc(
    .src1_i(pc),     
    .src2_i(32'd4),     
    .sum_o(pc_next0)    
);

// IF/ID registers
Pipe_Reg #(.size(32 + 32)) IF_ID(       //N is the total length of input/output
    .clk_i(clk_i),
    .rst_i(rst_i),
    .keep_i(ID_stall),
    .flush_i(IF_flush),
    .data_i({ pc_next0, instruction }),
    .data_o({ pc_next0_s2, instruction_s2 })
);


//Instantiate the components in ID stage
Reg_File RF(
    .clk_i(clk_i),      
    .rst_i(rst_i),     
    .RSaddr_i(instruction_s2[25:21]),  
    .RTaddr_i(instruction_s2[20:16]),  
    .RDaddr_i(writeReg1_s5),
    .RDdata_i(toReg), 
    .RegWrite_i(regWrite_s5),
    .RSdata_o(rsData), 
    .RTdata_o(rtData)     
);

Decoder Control(
    .instr_op_i(instruction_s2[31:26]), 
    .function_i(instruction_s2[5:0]),
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

Sign_Extend Sign_Extend(
    .data_i(instruction_s2[15:0]),
    .data_o(signExtended)
);	

MUX_2to1 #(.size(12)) Mux_flush_s2(
    .data0_i({ MemtoReg, regWrite, MemRead, branch, MemWrite, ALUsrc, ALUop, regDst, BranchType }),
    .data1_i(12'b0),
    .select_i(ID_flush),
    .data_o({ MemtoReg_s2, regWrite_s2, MemRead_s2, branch_s2, MemWrite_s2, ALUsrc_s2, ALUop_s2, regDst_s2, BranchType_s2 })
);

Hazard Hazard_detection (
    .MemRead_s3(MemRead_s3), 
    .RegisterRs(instruction_s2[25:21]), 
    .RegisterRt(instruction_s2[20:16]), 
    .RegisterRt_s3(Instruction_s3[20:16]),
    .branch(branch_select), 
	.pc_stall(pc_stall), 
	.ID_stall(ID_stall), 
	.IF_flush(IF_flush), 
	.ID_flush(ID_flush), 
	.EX_flush(EX_flush)
);

// ID/EX registers
Pipe_Reg #(.size(7 * 1 + 3 + 5 * 32 + 2)) ID_EX(
    .clk_i(clk_i),
    .rst_i(rst_i),
    .keep_i(1'b0),
    .flush_i(1'b0),
    .data_i({ MemtoReg_s2, regWrite_s2, MemRead_s2, branch_s2, MemWrite_s2, ALUsrc_s2, ALUop_s2, 
        regDst_s2, pc_next0_s2, rsData, rtData, signExtended, instruction_s2, BranchType_s2 }),
    .data_o({ MemtoReg_s3, regWrite_s3, MemRead_s3, branch_s3, MemWrite_s3, ALUsrc_s3, ALUop_s3, 
        regDst_s3, pc_next0_s3, rsData_s3, rtData_s3, signExtended_s3, Instruction_s3, BranchType_s3 })
);

//Instantiate the components in EX stage	   
Shift_Left_Two_32 Shifter(
    .data_i(signExtended_s3),
    .data_o(leftShifted)
);

ALU ALU(
    .src1_i(ALU_rs),
    .src2_i(MUX_ALUsrc),
    .ctrl_i(ALUcontrol),
    .result_o(ALUresult),
    .zero_o(zero)
);
		
ALU_Ctrl ALU_Control(
    .funct_i(Instruction_s3[5:0]),   
    .ALUOp_i(ALUop_s3),
    .ALUCtrl_o(ALUcontrol) 
);

MUX_2to1 #(.size(32)) Mux1(
    .data0_i(ALU_rt),
    .data1_i(signExtended_s3),
    .select_i(ALUsrc_s3),
    .data_o(MUX_ALUsrc)
);
		
MUX_2to1 #(.size(5)) Mux2(
    .data0_i(Instruction_s3[20:16]),
    .data1_i(Instruction_s3[15:11]),
    .select_i(regDst_s3),
    .data_o(writeReg1)
);

Adder Add_pc_branch(
    .src1_i(pc_next0_s3),     
    .src2_i(leftShifted),     
    .sum_o(pc_next1_s3)  
);

MUX_2to1 #(.size(7)) Mux_flush_s3(
    .data0_i({ MemtoReg_s3, regWrite_s3, branch_s3, MemRead_s3, MemWrite_s3, BranchType_s3 }),
    .data1_i(7'b0),
    .select_i(EX_flush),
    .data_o({ MemtoReg_s33, regWrite_s33, branch_s33, MemRead_s33, MemWrite_s33, BranchType_s33 })
);

MUX_3to1 #(.size(32)) Mux_ALU_RS(
    .data0_i(rsData_s3),
    .data1_i(ALUresult_s4),
    .data2_i(toReg),
    .select_i(ForwardA),
    .data_o(ALU_rs)
);

MUX_3to1 #(.size(32)) Mux_ALU_RT(
    .data0_i(rtData_s3),
    .data1_i(ALUresult_s4),
    .data2_i(toReg),
    .select_i(ForwardB),
    .data_o(ALU_rt)
);

Forwarding Forwarding_unit(
    .RegisterRs_s3(Instruction_s3[25:21]), 
    .RegisterRt_s3(Instruction_s3[20:16]), 
    .writeReg1_s4(writeReg1_s4),
    .writeReg1_s5(writeReg1_s5),
    .regWrite_s4(regWrite_s4), 
    .regWrite_s5(regWrite_s5),
	.ForwardA_o(ForwardA),
	.ForwardB_o(ForwardB)
);

// EX/MEM registers
Pipe_Reg #(.size(142)) EX_MEM(
    .clk_i(clk_i),
    .rst_i(rst_i),
    .keep_i(1'b0),
    .flush_i(EX_flush),
    .data_i({ MemtoReg_s3, regWrite_s3, branch_s3, MemRead_s3, Instruction_s3,
        MemWrite_s3, pc_next1_s3, zero, ALUresult, ALU_rt, writeReg1, BranchType_s3, Branch_new }),
    .data_o({ MemtoReg_s4, regWrite_s4, branch_s4, MemRead_s4, instruction_s4,
        MemWrite_s4, pc_next1_s4, zero_s4, ALUresult_s4, ALU_rt_s4, writeReg1_s4, BranchType_s4, Branch_new_s4 })
);

//Instantiate the components in MEM stage
Data_Memory DM(
    .clk_i(clk_i),
    .addr_i(ALUresult_s4),
    .data_i(ALU_rt_s4),
    .MemRead_i(MemRead_s4),
    .MemWrite_i(MemWrite_s4),
    .data_o(ReadData)
);

MUX_4to1 #(.size(1)) Mux_branch(
    .data0_i(ALU_rs == MUX_ALUsrc),
    .data1_i(ALU_rs >= MUX_ALUsrc),
    .data2_i(ALU_rs > MUX_ALUsrc),
    .data3_i(ALU_rs != MUX_ALUsrc),
    .select_i(BranchType_s3),
    .data_o(Branch_new)
);

// assign branch_select = branch & Branch_new;
assign branch_select = branch_s4 & Branch_new_s4;

// MEM/WB registers
Pipe_Reg #(.size(2 * 1 + 2 * 32 + 5)) MEM_WB(
    .clk_i(clk_i),
    .rst_i(rst_i),
    .keep_i(1'b0),
    .flush_i(1'b0),
    .data_i({ MemtoReg_s4, regWrite_s4, ReadData, ALUresult_s4, writeReg1_s4 }),
    .data_o({ MemtoReg_s5, regWrite_s5, ReadData_s5, ALUresult_s5, writeReg1_s5 })
);

//Instantiate the components in WB stage
MUX_2to1 #(.size(32)) Mux3(
    .data0_i(ALUresult_s5),
    .data1_i(ReadData_s5),
    .select_i(MemtoReg_s5),
    .data_o(toReg)
);

/****************************************
signal assignment
****************************************/

endmodule
