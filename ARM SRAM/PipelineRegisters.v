module IF_Stage_Reg(
  input clk,rst,freeze,flush,
  input[31:0] PC_in, Instruction_in,
  output reg[31:0] PC,Instruction
);
  always@(posedge clk, posedge rst)begin
    if(rst)begin
      PC<=0;
      Instruction<=0;
    end
    else begin
      if(flush) begin
        PC<=0;
        Instruction<=0;
      end
      else if(~freeze) begin
        PC<=PC_in;
        Instruction<=Instruction_in;
      end
    end
  end
endmodule



module ID_Stage_Reg(input clk , rst,
                          flush,
                    input WB_EN_IN, MEM_R_EN_IN, MEM_W_EN_IN, B_IN,S_IN,
                    input [3:0] EXE_CMD_IN,
                    input [31:0] PC_IN,
                    input [31:0] Val_Rn_IN,Val_Rm_IN,
                    input imm_IN,
                    input [11:0] Shift_operand_IN,
                    input [23:0] Signed_imm_24_IN,
                    input [3:0] Dest_IN,
                    input [3:0] Status_in,

                    input[3:0] src1_in,src2_in,

                    output reg[3:0] src1, src2,

                    output reg WB_EN,MEM_R_EN,MEM_W_EN,B,S,
                    output reg [3:0] EXE_CMD,
                    output reg [31:0] PC,
                    output reg [31:0] Val_Rn,Val_Rm,
                    output reg imm,
                    output reg [11:0] Shift_operand,
                    output reg [23:0] Signed_imm_24,
                    output reg [3:0] Dest,
                    output reg [3:0] Status
                  );
  always @(posedge rst,posedge clk)
  begin
    if (rst) begin
      src1<=0; src2=0;
      WB_EN<=0;MEM_R_EN<=0;MEM_W_EN<=0;B<=0;S <= 0;
      EXE_CMD <= 4'b0;
      PC      <= 32'b0;
		  Val_Rn<=32'b0;
		  Val_Rm <= 32'b0;
      imm <= 0 ;
      Shift_operand <= 12'b0;
      Signed_imm_24 <= 24'b0;
      Dest    <=  4'b0;
      Status <= 4'b0;
	 end
	 else if(flush)begin
      src1<=0; src2<=0;
		  WB_EN<=0;MEM_R_EN<=0;MEM_W_EN<=0;B<=0;S <= 0;
      EXE_CMD <= 4'b0;
      PC      <= 32'b0;
		  Val_Rn<=32'b0;
		  Val_Rm <= 32'b0;
      imm <= 0 ;
      Shift_operand <= 12'b0;
      Signed_imm_24 <= 24'b0;
      Dest    <=  4'b0;
      Status <= 4'b0;
	 end
    else begin
      src1<=src1_in; src2<=src2_in;
      WB_EN    <=  WB_EN_IN ;
      MEM_R_EN <=  MEM_R_EN_IN;
      MEM_W_EN <=  MEM_W_EN_IN;
      B <= B_IN ;
      S <= S_IN;
      EXE_CMD <= EXE_CMD_IN;
      PC      <= PC_IN;
      Val_Rn <=Val_Rn_IN;
      Val_Rm <=Val_Rm_IN;
      imm <= imm_IN ;
      Shift_operand <= Shift_operand_IN;
      Signed_imm_24 <= Signed_imm_24_IN;
      Dest    <=  Dest_IN;
      Status <= Status_in;
    end
  end
endmodule


module EXE_Stage_Reg(
  input clk,rst, WB_en_in, MEM_R_EN_in, MEM_W_EN_in,
  input[31:0] ALU_result_in, Val_Rm_in,
  input[3:0] Dest_in,

  input freeze,

  output reg WB_en, MEM_R_EN, MEM_W_EN,
  output reg[31:0] ALU_result, Val_Rm,
  output reg[3:0] Dest
);
  always@(posedge clk, posedge rst)
  begin
    if(rst)begin
      WB_en=0; MEM_R_EN=0; MEM_W_EN=0;
      ALU_result=0; Val_Rm=0;
      Dest=0;
    end
    else if(~freeze) begin
      WB_en = WB_en_in;
      MEM_R_EN = MEM_R_EN_in;
      MEM_W_EN = MEM_W_EN_in;
      ALU_result = ALU_result_in;
      Val_Rm =  Val_Rm_in;
      Dest = Dest_in;
    end
  end
endmodule


module MEM_Stage_Reg(
  input clk,rst,
  input WB_EN_in, MEM_R_EN_in,
  input[31:0] ALU_result_in, MEM_result_in,
  input[3:0] Dest_in,

  input freeze,

  output reg WB_EN, MEM_R_EN,
  output reg[31:0] ALU_result, MEM_result,
  output reg[3:0] Dest
);
  always@(posedge clk, posedge rst)
    if(rst)begin
      WB_EN=1'b0;
      MEM_R_EN=1'b0;
      ALU_result=0;
      MEM_result=0;
      Dest=4'b0;
    end
    else if(~freeze)begin
      WB_EN=WB_EN_in;
      MEM_R_EN=MEM_R_EN_in;
      ALU_result=ALU_result_in;
      MEM_result=MEM_result_in;
      Dest=Dest_in;
    end
endmodule
