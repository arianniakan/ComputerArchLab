module WB_Stage(
  input[31:0] ALU_result, MEM_result,
  input MEM_R_en,
  output[31:0] out
);
  assign out= MEM_R_en ? MEM_result : ALU_result;
endmodule
