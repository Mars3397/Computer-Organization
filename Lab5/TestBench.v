// 109550018

`timescale 1ns / 1ps

`define CYCLE_TIME 10			

module TestBench;

//Internal Signals
reg         CLK;
reg         RST;
wire [32-1:0] pc_pre, pc, pc_next0;
wire [32-1:0] instruction;

//control signal
wire PCsrc;

/**** ID stage ****/
wire [32-1:0] pc_next0_s2, instruction_s2, rsData, rtData, signExtended;

//control signal
wire MemtoReg, regDst, regWrite, branch, ALUsrc, Jump, MemRead, MemWrite;
wire [2-1:0] BranchType;
wire [3-1:0] ALUop;

/**** EX stage ****/
wire [32-1:0] pc_next0_s3, leftShifted, pc_next1_s3;
wire [32-1:0] rsData_s3, rtData_s3, MUX_ALUsrc, ALUresult;
wire zero;
wire [32-1:0] signExtended_s3;
wire [4-1:0] ALUcontrol;
wire [32-1:0] Instruction_s3;
wire [5-1:0] writeReg1;

//control signal
wire MemtoReg_s3, regDst_s3, regWrite_s3, branch_s3, ALUsrc_s3, MemRead_s3, MemWrite_s3;
wire [3-1:0] ALUop_s3;

/**** MEM stage ****/
wire [32-1:0] pc_next1_s4;
wire zero_s4;
wire [32-1:0] ALUresult_s4, rtData_s4, ReadData;
wire [5-1:0] writeReg1_s4;

//control signal
wire MemtoReg_s4, regWrite_s4, branch_s4, MemRead_s4, MemWrite_s4;

/**** WB stage ****/
wire [32-1:0] ReadData_s5, ALUresult_s5, toReg;
wire [5-1:0] writeReg1_s5;

//control signal
wire MemtoReg_s5, regWrite_s5;
integer     count;
integer     i;
integer     handle;

//Greate tested modle  
Pipe_CPU_1 cpu(
    .clk_i(CLK),
    .rst_i(RST),
    .pc_pre(pc_pre), .pc(pc), .pc_next0(pc_next0), .instruction(instruction), .PCsrc(PCsrc),
    .pc_next0_s2(pc_next0_s2), .instruction_s2(instruction_s2), .rsData(rsData), .rtData(rtData), .signExtended(signExtended), 
    .MemtoReg(MemtoReg), .regDst(regDst), .regWrite(regWrite), .branch(branch), .ALUsrc(ALUsrc), .Jump(Jump), .MemRead(MemRead), .MemWrite(MemWrite), 
    .BranchType(BranchType), .ALUop(ALUop), .pc_next0_s3(pc_next0_s3), .leftShifted(leftShifted), .pc_next1_s3(pc_next1_s3), 
    .rsData_s3(rsData_s3), .rtData_s3(rtData_s3), .MUX_ALUsrc(MUX_ALUsrc), .ALUresult(ALUresult), 
    .zero(zero), .signExtended_s3(signExtended_s3), .ALUcontrol(ALUcontrol), .Instruction_s3(Instruction_s3), .writeReg1(writeReg1), 
    .MemtoReg_s3(MemtoReg_s3), .regDst_s3(regDst_s3), .regWrite_s3(regWrite_s3), .branch_s3(branch_s3), .ALUsrc_s3(ALUsrc_s3), .MemRead_s3(MemRead_s3), .MemWrite_s3(MemWrite_s3),
    .ALUop_s3(ALUop_s3), .pc_next1_s4(pc_next1_s4), .zero_s4(zero_s4), .ALUresult_s4(ALUresult_s4), .rtData_s4(rtData_s4), .ReadData(ReadData),
    .writeReg1_s4(writeReg1_s4), .MemtoReg_s4(MemtoReg_s4), .regWrite_s4(regWrite_s4), .branch_s4(branch_s4), .MemRead_s4(MemRead_s4), .MemWrite_s4(MemWrite_s4), 
    .ReadData_s5(ReadData_s5), .ALUresult_s5(ALUresult_s5), .toReg(toReg), .writeReg1_s5(writeReg1_s5),
    .MemtoReg_s5(MemtoReg_s5), .regWrite_s5(regWrite_s5)
    );
 
//Main function

always #(`CYCLE_TIME/2) CLK = ~CLK;	

initial begin
    //handle = $fopen("P4_Result.dat");
    CLK = 0;
    RST = 0;
    count = 0;
   
    // instruction memory
    for(i=0; i<32; i=i+1)
    begin
        cpu.IM.instruction_file[i] = 32'b0;
    end

    $readmemb("CO_P4_test_2.txt", cpu.IM.instruction_file);  //Read instruction from "CO_P4_test_1.txt"   
    
    // data memory
    for(i=0; i<128; i=i+1)
    begin
        cpu.DM.Mem[i] = 8'b0;
    end
    
    #(`CYCLE_TIME)      RST = 1;
    #(`CYCLE_TIME*20)   $stop;
    //#(`CYCLE_TIME*20)	$fclose(handle); $stop;
end

//Print result to "CO_P4_Result.dat"
always@(posedge CLK) begin
    count = count + 1;

    //print result to transcript 
    $display("Register===========================================================\n");
    $display("r0=%d, r1=%d, r2=%d, r3=%d, r4=%d, r5=%d, r6=%d, r7=%d\n",
    cpu.RF.Reg_File[0], cpu.RF.Reg_File[1], cpu.RF.Reg_File[2], cpu.RF.Reg_File[3], cpu.RF.Reg_File[4], 
    cpu.RF.Reg_File[5], cpu.RF.Reg_File[6], cpu.RF.Reg_File[7],
    );
    $display("r8=%d, r9=%d, r10=%d, r11=%d, r12=%d, r13=%d, r14=%d, r15=%d\n",
    cpu.RF.Reg_File[8], cpu.RF.Reg_File[9], cpu.RF.Reg_File[10], cpu.RF.Reg_File[11], cpu.RF.Reg_File[12], 
    cpu.RF.Reg_File[13], cpu.RF.Reg_File[14], cpu.RF.Reg_File[15],
    );
    $display("r16=%d, r17=%d, r18=%d, r19=%d, r20=%d, r21=%d, r22=%d, r23=%d\n",
    cpu.RF.Reg_File[16], cpu.RF.Reg_File[17], cpu.RF.Reg_File[18], cpu.RF.Reg_File[19], cpu.RF.Reg_File[20], 
    cpu.RF.Reg_File[21], cpu.RF.Reg_File[22], cpu.RF.Reg_File[23],
    );
    $display("r24=%d, r25=%d, r26=%d, r27=%d, r28=%d, r29=%d, r30=%d, r31=%d\n",
    cpu.RF.Reg_File[24], cpu.RF.Reg_File[25], cpu.RF.Reg_File[26], cpu.RF.Reg_File[27], cpu.RF.Reg_File[28], 
    cpu.RF.Reg_File[29], cpu.RF.Reg_File[30], cpu.RF.Reg_File[31],
    );

    $display("\nMemory===========================================================\n");
    $display("m0=%d, m1=%d, m2=%d, m3=%d, m4=%d, m5=%d, m6=%d, m7=%d\n\nm8=%d, m9=%d, m10=%d, m11=%d, m12=%d, m13=%d, m14=%d, m15=%d\n\nr16=%d, m17=%d, m18=%d, m19=%d, m20=%d, m21=%d, m22=%d, m23=%d\n\nm24=%d, m25=%d, m26=%d, m27=%d, m28=%d, m29=%d, m30=%d, m31=%d",							 
            cpu.DM.memory[0], cpu.DM.memory[1], cpu.DM.memory[2], cpu.DM.memory[3],
            cpu.DM.memory[4], cpu.DM.memory[5], cpu.DM.memory[6], cpu.DM.memory[7],
            cpu.DM.memory[8], cpu.DM.memory[9], cpu.DM.memory[10], cpu.DM.memory[11],
            cpu.DM.memory[12], cpu.DM.memory[13], cpu.DM.memory[14], cpu.DM.memory[15],
            cpu.DM.memory[16], cpu.DM.memory[17], cpu.DM.memory[18], cpu.DM.memory[19],
            cpu.DM.memory[20], cpu.DM.memory[21], cpu.DM.memory[22], cpu.DM.memory[23],
            cpu.DM.memory[24], cpu.DM.memory[25], cpu.DM.memory[26], cpu.DM.memory[27],
            cpu.DM.memory[28], cpu.DM.memory[29], cpu.DM.memory[30], cpu.DM.memory[31]
            );
	
end
  
endmodule

