module ID_Stage(input clk , rst,
                input [31:0] Instruction,
                input [31:0] Result_WB,
                input writeBackEn,
                input [3:0] Dest_wb,
                input [3:0] SR,
                input hazard,

                output WB_EN,MEM_R_EN,MEM_W_EN,B,S,
                output [3:0] EXE_CMD,
                output [31:0] Val_Rn,Val_Rm,
                output imm,
                output [11:0] Shift_operand,
                output [23:0] Signed_imm_24,
                output [3:0] Dest,src1,src2,
                output Two_src,
                output sort_cycle_count
                  );

wire mux_sel;
wire cond_out,SS1,B1,MEM_R_EN1,MEM_W_EN1,WB_EN1;
wire [3:0] EXE_CMD1,src22;
RegisterFile R1 (
  .clk(clk),.rst(rst),
  .src1(Instruction[19:16]),.src2(src22),.Dest_wb(Dest_wb),
  .Result_WB(Result_WB),
  .WriteBackEn(writeBackEn),
  .reg1(Val_Rn),.reg2(Val_Rm)
  );

ControlUnit C1 (.op_code(Instruction[24:21]),.mode(Instruction[27:26]),.S(Instruction[20]),.SS(SS1),
              .B(B1),.MEM_R_EN(MEM_R_EN1),.MEM_W_EN(MEM_W_EN1),
              .WB_EN(WB_EN1),.EXE_CMD(EXE_CMD1),.sort_cycle_count(sort_cycle_count) );

Condition_Check C2(.cond(Instruction[31:28]),.clk(clk),.rst(rst),
                       .SR(SR),.cond_out(cond_out));

SORT_counter counter(clk, rst, Instruction[24:21], sort_cycle_count);

assign mux_sel      = ~((hazard)|(~cond_out));
assign S           = (mux_sel)? SS1 : 1'b0;
assign B            = (mux_sel)? B1 : 1'b0;
assign MEM_R_EN     = (mux_sel)? MEM_R_EN1    : 1'b0;
assign MEM_W_EN     = (mux_sel)? MEM_W_EN1    : 1'b0;
assign WB_EN        = (mux_sel)? WB_EN1       : 1'b0;
assign EXE_CMD  = (mux_sel)? EXE_CMD1 : 4'b0;
assign src22        = (MEM_W_EN)? Instruction[15:12] : Instruction[3:0] ;

assign imm                    = Instruction[25];
assign Shift_operand          = Instruction[11:0];
assign Signed_imm_24          = Instruction[23:0];
assign Dest                   = (sort_cycle_count == 1'b0) ? Instruction[15:12] : Instruction[19:16];
assign src1                   = Instruction[19:16];
assign src2                   = src22;

assign Two_src      =  ((MEM_W_EN)|(~Instruction[25]));

endmodule
