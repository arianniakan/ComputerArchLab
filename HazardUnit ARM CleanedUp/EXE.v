module EXE_Stage(
  input clk,
  input[3:0] EXE_CMD,
  input MEM_R_EN, MEM_W_EN,
  input[31:0] PC,
  input[31:0] Val_Rn, Val_Rm,
  input imm,
  input[11:0] Shift_operand,
  input[23:0] Signed_imm_24,
  input[3:0] SR,

  output[31:0] ALU_result, Branch_Address,
  output[3:0] status
);

  wire[31:0] Val2;

  ALU alu(
    .EXE_CMD(EXE_CMD),
    .Val1(Val_Rn),
    .Val2(Val2),
    .SR(SR),
    .status(status),
    .ALU_result(ALU_result)
  );

  Val2_Generator val2gen(
    .Val_Rm(Val_Rm),
    .Shift_operand(Shift_operand),
    .imm(imm),
    .mem_acc(MEM_R_EN|MEM_W_EN),

    .Val2(Val2)
  );

  assign Branch_Address= {{ {8{Signed_imm_24[23]}} , Signed_imm_24 }<<2} + PC;

endmodule
