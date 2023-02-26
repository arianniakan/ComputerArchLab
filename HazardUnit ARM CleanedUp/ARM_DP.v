module ARM_DP(
  input clk,rst
);
  wire[31:0] IF_PC, IF_Reg_PC, IF_Ins, IF_Reg_Ins;

  wire[31:0] ID_Val_Rn, ID_Val_Rm;
  wire[23:0] ID_Signed_imm_24;
  wire[11:0] ID_Shift_operand;
  wire[3:0] ID_EXE_CMD, ID_Dest, ID_src1, ID_src2;
  wire ID_WB_EN, ID_MEM_R_EN, ID_MEM_W_EN, ID_B, ID_S;
  wire ID_Two_src, ID_imm;
  wire[31:0] ID_PC, ID_Reg_PC, ID_Reg_Val_Rn, ID_Reg_Val_Rm;
  wire[23:0] ID_Reg_Signed_imm_24;
  wire[11:0] ID_Reg_Shift_operand;
  wire[3:0] ID_Reg_EXE_CMD, ID_Reg_SR, ID_Reg_Dest;
  wire ID_Reg_MEM_R_EN, ID_Reg_MEM_W_EN, ID_Reg_imm , ID_Reg_WB_en;
  wire ID_Reg_S, ID_Reg_B;

  wire[31:0] Exe_ALU_result, Exe_Branch_Address;
  wire[3:0] Exe_status;
  wire[31:0] Exe_Reg_ALU_result, Exe_Reg_Val_Rm;
  wire[3:0] Exe_Reg_Dest;
  wire Exe_Reg_WB_en, Exe_Reg_MEM_R_EN, Exe_Reg_MEM_W_EN;


  wire[31:0] MEM_result;
  wire MEM_Reg_WB_EN, MEM_Reg_MEM_R_EN;
  wire[31:0] MEM_Reg_ALU_result, MEM_Reg_MEM_result;
  wire[3:0] MEM_Reg_Dest;

  wire[31:0] WB_Value;

  wire[31:0] Mem_PC, Mem_Reg_PC;
  wire[31:0] WB_PC;

  wire[3:0] Status_Register_Out;

  wire Hazard;

  IF_Stage ifstage(
    .clk(clk),
    .rst(rst),
    .freeze(Hazard),
    .Branch_taken(ID_Reg_B),
    .BranchAddr(Exe_Branch_Address),
    .PC(IF_PC),
    .Instruction(IF_Ins)
  );

  IF_Stage_Reg ifstagereg(
    .clk(clk),
    .rst(rst),
    .freeze(Hazard),
    .flush(ID_Reg_B),
    .PC_in(IF_PC),
    .Instruction_in(IF_Ins),
    .PC(IF_Reg_PC),
    .Instruction(IF_Reg_Ins)
  );

  ID_Stage idstage(
    .clk(clk) ,
    .rst(rst),
    .Instruction(IF_Reg_Ins),
    .Result_WB(WB_Value),
    .writeBackEn(MEM_Reg_WB_EN),
    .Dest_wb(MEM_Reg_Dest),
    .SR(Status_Register_Out),
    .hazard(Hazard),

    .WB_EN(ID_WB_EN),
    .MEM_R_EN(ID_MEM_R_EN),
    .MEM_W_EN(ID_MEM_W_EN),
    .B(ID_B),
    .S(ID_S),
    .Val_Rn(ID_Val_Rn),
    .Val_Rm(ID_Val_Rm),
    .imm(ID_imm),
    .Shift_operand(ID_Shift_operand),
    .Signed_imm_24(ID_Signed_imm_24),
    .EXE_CMD(ID_EXE_CMD),
    .Dest(ID_Dest),
    .Two_src(ID_Two_src),
    .src1(ID_src1),
    .src2(ID_src2)
  );

  ID_Stage_Reg idstagereg(
    .clk(clk),
    .rst(rst),
    .PC_IN(IF_Reg_PC),
    .PC(ID_Reg_PC),
    .flush(ID_Reg_B),
    .WB_EN_IN(ID_WB_EN),
    .MEM_R_EN_IN(ID_MEM_R_EN),
    .MEM_W_EN_IN(ID_MEM_W_EN),
    .B_IN(ID_B),
    .S_IN(ID_S),
    .EXE_CMD_IN(ID_EXE_CMD),
    .Val_Rn_IN(ID_Val_Rn),
    .Val_Rm_IN(ID_Val_Rm),
    .imm_IN(ID_imm),
    .Shift_operand_IN(ID_Shift_operand),
    .Signed_imm_24_IN(ID_Signed_imm_24),
    .Dest_IN(ID_Dest),
    .Status_in(Status_Register_Out),

    .WB_EN(ID_Reg_WB_en),
    .MEM_R_EN(ID_Reg_MEM_R_EN),
    .MEM_W_EN(ID_Reg_MEM_W_EN),
    .B(ID_Reg_B),
    .S(ID_Reg_S),
    .EXE_CMD(ID_Reg_EXE_CMD),
    .Val_Rn(ID_Reg_Val_Rn),
    .Val_Rm(ID_Reg_Val_Rm),
    .imm(ID_Reg_imm),
    .Shift_operand(ID_Reg_Shift_operand),
    .Signed_imm_24(ID_Reg_Signed_imm_24),
    .Dest(ID_Reg_Dest),
    .Status(ID_Reg_SR)
  );

  EXE_Stage exestage(
    .clk(clk),
    .EXE_CMD(ID_Reg_EXE_CMD),
    .MEM_R_EN(ID_Reg_MEM_R_EN),
    .MEM_W_EN(ID_Reg_MEM_W_EN),
    .PC(ID_Reg_PC),
    .Val_Rn(ID_Reg_Val_Rn),
    .Val_Rm(ID_Reg_Val_Rm),
    .imm(ID_Reg_imm),
    .Shift_operand(ID_Reg_Shift_operand),
    .Signed_imm_24(ID_Reg_Signed_imm_24),
    .SR(ID_Reg_SR),

    .ALU_result(Exe_ALU_result),
    .Branch_Address(Exe_Branch_Address),
    .status(Exe_status)
  );

  EXE_Stage_Reg exestagereg(
    .clk(clk),
    .rst(rst),
    .WB_en_in(ID_Reg_WB_en),
    .MEM_R_EN_in(ID_Reg_MEM_R_EN),
    .MEM_W_EN_in(ID_Reg_MEM_W_EN),
    .ALU_result_in(Exe_ALU_result),
    .Val_Rm_in(ID_Reg_Val_Rm),
    .Dest_in(ID_Reg_Dest),

    .WB_en(Exe_Reg_WB_en),
    .MEM_R_EN(Exe_Reg_MEM_R_EN),
    .MEM_W_EN(Exe_Reg_MEM_W_EN),
    .ALU_result(Exe_Reg_ALU_result),
    .Val_Rm(Exe_Reg_Val_Rm),
    .Dest(Exe_Reg_Dest)
  );

  MEM_Stage memstage(
    .clk(clk),
    .rst(rst),
    .Val_Rm(Exe_Reg_Val_Rm),
    .ALU_Res(Exe_Reg_ALU_result),
    .MEM_W_EN(Exe_Reg_MEM_W_EN),
    .MEM_R_EN(Exe_Reg_MEM_R_EN),
    .MEM_result(MEM_result)
  );

  MEM_Stage_Reg memstagereg(
    .clk(clk),
    .rst(rst),
    .WB_EN_in(Exe_Reg_WB_en),
    .MEM_R_EN_in(Exe_Reg_MEM_R_EN),
    .ALU_result_in(Exe_Reg_ALU_result),
    .MEM_result_in(MEM_result),
    .Dest_in(Exe_Reg_Dest),

    .WB_EN(MEM_Reg_WB_EN),
    .MEM_R_EN(MEM_Reg_MEM_R_EN),
    .ALU_result(MEM_Reg_ALU_result),
    .MEM_result(MEM_Reg_MEM_result),
    .Dest(MEM_Reg_Dest)
  );

  WB_Stage wbstage(
    .ALU_result(MEM_Reg_ALU_result),
    .MEM_result(MEM_Reg_MEM_result),
    .MEM_R_en(MEM_Reg_MEM_R_EN),

    .out(WB_Value)
  );

  Status_Register statusregister(
    .clk(clk),
    .S(ID_Reg_S),
    .Status_in(Exe_status),
    .Status(Status_Register_Out)
  );

  Hazard_Detection_Unit hazarddetector (
      .src1(ID_src1),
      .src2(ID_src2),
      .EXE_Dest(ID_Reg_Dest),
      .MEM_Dest(Exe_Reg_Dest),
      .Two_src(ID_Two_src),
      .EXE_WB_EN(ID_Reg_WB_en),
      .MEM_WB_EN(Exe_Reg_WB_en),

      .Hazard(Hazard)
  );
endmodule
