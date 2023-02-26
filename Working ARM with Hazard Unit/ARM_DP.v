module ARM_DP(input clk, rst);


wire [31:0] PC_IF, Instruction_IF;
wire [31:0] PC_ID, Instruction_ID;
wire [31:0] PC_EX, Instruction_EX;
wire [31:0] PC_MEM, Instruction_MEM;
wire [31:0] PC_WB, Instruction_WB;

wire Hazard;

wire        EX_B;
wire [31:0] EX_BranchAd;

// instruction fetch stage instance 
IF_Stage IF_inst (
                  .clk(clk), 
                  .rst(rst), 
                  .freeze(Hazard), 
                  .Branch_taken(EX_B), 
                  .BranchAddr(EX_BranchAd),
                  .PC(PC_IF),
                  .Instruction(Instruction_IF)
                 );

IF_stage_Reg IF_regs (
                     .clk(clk),
                     .rst(rst), 
                     .freeze(Hazard), 
                     .flush(EX_B),
                     .PC_in(PC_IF), 
                     .Instruction_in(Instruction_IF), 
                     .PC(PC_ID),
                     .Instruction(Instruction_ID)
                    );
//end of intruction fetch stage instance


// instruction decode stage instance 
reg [3:0] status;


wire ID_WB_EN;
wire ID_MEM_R_EN;
wire ID_MEM_W_EN;
wire [3:0] ID_EXE_CMD;
wire ID_S;
wire ID_B;
wire [31:0] ID_Val_RN;
wire [31:0] ID_Val_RM;

wire [3:0] Dest_wb;
wire [31:0] Result_WB;
wire writeBackEn;


wire        EX_WB_EN;
wire        EX_MEM_R_EN;
wire        EX_MEM_W_EN;
wire        EX_S;
wire [31:0] EX_Val_RN;
wire [31:0] EX_Val_RM;
wire [11:0] EX_imm;
wire [11:0] EX_shift_operand;
wire [23:0] EX_signed_immed_24;
wire [3:0]  EX_WB_Dest;
wire [3:0]  EX_status;
wire [3:0]  EX_EXE_CMD;

wire [3:0] src2;
wire has_src2;
 ID_stage ID_inst(
                .clk(clk), 
                .rst(rst),
                .PC(PC_ID),
                .Instruction(Instruction_ID),
                .status(status),
                .Dest_wb(Dest_wb),
                .Result_WB(Result_WB),
                .writeBackEn(writeBackEn),
                .Hazard(Hazard),

                .WB_EN   (ID_WB_EN),
                .MEM_R_EN(ID_MEM_R_EN),
                .MEM_W_EN(ID_MEM_W_EN),
                .EXE_CMD (ID_EXE_CMD),
                .B       (ID_B), 
                .S       (ID_S),
                .Val_RN  (ID_Val_RN),
                .Val_RM  (ID_Val_RM),
                .src2(src2),
                .has_src2(has_src2)
                );
wire EX_I;
ID_stage_Reg ID_regs(.clk(clk), 
                    .rst(rst), 
                    .flush(EX_B),
                    .PC_IN(PC_ID), 
                    .WB_EN_IN(ID_WB_EN),
                    .MEM_R_EN_IN(ID_MEM_R_EN),
                    .MEM_W_EN_IN(ID_MEM_W_EN),
                    .EXE_CMD_IN(ID_EXE_CMD),
                    .B_IN(ID_B), 
                    .S_IN(ID_S),
                    .I_IN(Instruction_ID[25]),
                    .Val_RN_IN(ID_Val_RN),
                    .Val_RM_IN(ID_Val_RM),
                    .imm_IN(Instruction_ID[11:0]),
                    .shift_operand_IN(Instruction_ID[11:0]),
                    .signed_immed_24_IN(Instruction_ID[23:0]),
                    .WB_Dest_IN(Instruction_ID[15:12]),
                    .flush_IN(flush),
                    .status_IN(status),

                    .PC(PC_EX),
                    .WB_EN(EX_WB_EN),
                    .MEM_R_EN(EX_MEM_R_EN),
                    .MEM_W_EN(EX_MEM_W_EN),
                    .B(EX_B), 
                    .S(EX_S),
                    .I(EX_I),
                    .Val_RN(EX_Val_RN),
                    .Val_RM(EX_Val_RM),
                    .imm            (EX_imm),
                    .shift_operand  (EX_shift_operand),
                    .signed_immed_24(EX_signed_immed_24),
                    .status         (EX_status),
                    .WB_Dest        (EX_WB_Dest),
                    .EXE_CMD        (EX_EXE_CMD)

                    );




//end of instruction decode stage instance

// Execution Stage Instance 


wire [3:0]  EX_status_out;
wire [31:0] EX_ALU_out;

wire [31:0] MEM_ALU_out;
wire [31:0] MEM_Val_RM;
wire [3:0]  MEM_WB_Dest;

always @(posedge clk, posedge rst) begin
    if(rst) status = 4'b0;
    else if (clk) begin
        if(EX_S) status = EX_status_out;
    end
    
end

EX_stage EX_inst(
                .PC(PC_EX),
                .MEM_R_EN(EX_MEM_R_EN),
                .MEM_W_EN(EX_MEM_W_EN),
                .EXE_CMD (EX_EXE_CMD),
                .S(EX_S),
                .I(EX_I),
                .Val_RN(EX_Val_RN),
                .Val_RM(EX_Val_RM),
                .imm             (EX_imm),
                .shift_operand   (EX_shift_operand),
                .signed_immed_24 (EX_signed_immed_24),
                .status          (EX_status),
           
           
                .BranchAddr (EX_BranchAd),
                .status_out (EX_status_out),
                .ALU_out    (EX_ALU_out)
                );


wire        MEM_WB_EN;
wire        MEM_MEM_R_EN;
wire        MEM_MEM_W_EN;
EX_stage_Reg EX_reg(.clk(clk), 
                    .rst(rst),
                    .WB_EN_IN   (EX_WB_EN),
                    .MEM_R_EN_IN(EX_MEM_R_EN),
                    .MEM_W_EN_IN(EX_MEM_W_EN),
                    .ALU_Res_IN(EX_ALU_out),
                    .Val_RM_IN(EX_Val_RM),
                    .WB_Dest_IN(EX_WB_Dest),

                    .WB_EN   (MEM_WB_EN),
                    .MEM_R_EN(MEM_MEM_R_EN),
                    .MEM_W_EN(MEM_MEM_W_EN),
                    .ALU_Res(MEM_ALU_out),
                    .Val_RM(MEM_Val_RM),
                    .WB_Dest(MEM_WB_Dest)
                    );


// end of Execution Stage Instance 

// Memory Stage Instance


wire [31:0] Mem_out;
MEM_stage MEM_inst (
                    .clk(clk),
                    .WB_EN   (MEM_WB_EN),
                    .MEM_R_EN(MEM_MEM_R_EN),
                    .MEM_W_EN(MEM_MEM_W_EN),
                    .ALU_Res(MEM_ALU_out),
                    .Val_RM(MEM_Val_RM),
                    .WB_Dest(MEM_WB_Dest),

                    .Mem_out(Mem_out)

);

wire        WB_WB_EN;
wire        WB_MEM_R_EN;
wire [3:0]  WB_WB_Dest;
wire [31:0] WB_ALU_out;
wire [31:0] WB_Mem_out;


MEM_stage_Reg Mem_regs(
                    .clk(clk), 
                    .rst(rst), 
                    .WB_EN_IN   (MEM_WB_EN),
                    .MEM_R_EN_IN(MEM_MEM_R_EN),
                    .ALU_Res_IN(MEM_ALU_out),
                    .MEMdata_IN(Mem_out),
                    .WB_Dest_IN(MEM_WB_Dest),

                    .WB_EN   (WB_WB_EN),
                    .MEM_R_EN(WB_MEM_R_EN),
                    .ALU_Res(WB_ALU_out),
                    .MEMdata(WB_Mem_out),
                    .WB_Dest(WB_WB_Dest)
                    );

//end of Memory Stage Instance

// Write Back stage instance 


assign writeBackEn = WB_WB_EN;
assign Result_WB = WB_MEM_R_EN?WB_Mem_out:WB_ALU_out;
assign Dest_wb = WB_WB_Dest;

//end of Write Back stage instance



//Hazard Detection Unit instance


HazardDetection HD (
    .src1(Instruction_ID[19:16]),
    .src2(src2),
    .EXE_dest(EX_WB_Dest),
    .MEM_dest(MEM_WB_Dest),
    .EXE_WB_en(EX_WB_EN),
    .MEM_WB_en(MEM_WB_EN),
    .has_src2(has_src2),
    .Hazard(Hazard)
);

//   Hazard_Detection_Unit hazarddetector (
//       .src1(Instruction_ID[19:16]),
//       .src2(src2),
//       .EXE_Dest(EX_WB_Dest),
//       .MEM_Dest(MEM_WB_Dest),
//       .Two_src(has_src2),
//       .EXE_WB_EN(EX_WB_EN),
//       .MEM_WB_EN(MEM_WB_EN),

//       .Hazard(Hazard)
//   );
//end of Hazard Detection Unit instance
endmodule