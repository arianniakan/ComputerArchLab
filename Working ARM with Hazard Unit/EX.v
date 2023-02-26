module EX_stage(input [31:0] PC,
                input MEM_R_EN,
                input MEM_W_EN,
                input [3:0] EXE_CMD,
                input S,
                input I,
                input [31:0] Val_RN,
                input [31:0] Val_RM,
                input [11:0] imm,
                input [11:0] shift_operand,
                input signed [23:0] signed_immed_24,
                input [3:0] status,
                
                
                output wire [31:0] BranchAddr,
                output [3:0] status_out,
                output wire [31:0] ALU_out
                );
// creating the val2 generator instance 
wire [31:0] Val2;
  Val2_Generator val2gen(
    .Val_Rm(Val_RM),
    .Shift_operand(shift_operand),
    .imm(I),
    .mem_acc(MEM_R_EN|MEM_W_EN),

    .Val2(Val2)
  );
//end of the val2 generator instance 

//branch address generation
assign BranchAddr = {{ {8{signed_immed_24[23]}} , signed_immed_24 }<<2} + PC;


//end of branch address generation







// creating the ALU instance 
            ALU alu_instance(
                             .ALU_Comnd(EXE_CMD),
                             .Val1(Val_RN), 
                             .Val2(Val2),
                             .C(status[2]),
                             .ALU_out(ALU_out),
                             .SR(status_out)
                            );

// wnd of the ALU instance 




endmodule