module EX_stage(input [31:0] PC,
                input MEM_R_EN,
                input MEM_W_EN,
                input [3:0] EXE_CMD,
                input S,
                input [31:0] Val_RN,
                input [31:0] Val_RM,
                input [11:0] imm,
                input [11:0] shift_operand,
                input [23:0] signed_immed_24,
                input [3:0] status,
                
                
                output wire [31:0] BranchAddr,
                output [3:0] status_out,
                output wire [31:0] ALU_out
                );
// creating the val2 generator instance 
wire [31:0] Val2;
            Val2gen val2gen_instance (
                                      .m(MEM_R_EN|MEM_W_EN),
                                      .Val_RM(Val_RM),
                                      .imm(imm),
                                      .shift_operand(shift_operand),
                                      .Val2(Val2)
                                     );
//end of the val2 generator instance 

//branch address generation

assign BranchAddr = PC + signed_immed_24;


//end of branch address generation







// creating the ALU instance 
            ALU alu_instance(
                             .ALU_Comnd(EXE_CMD),
                             .Val1(Val1), 
                             .Val2(Val2),
                             .C(status[2]),
                             .ALU_out(ALU_out),
                             .SR(status_out)
                            );

// wnd of the ALU instance 




endmodule