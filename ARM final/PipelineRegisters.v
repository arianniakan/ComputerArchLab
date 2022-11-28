module IF_stage_Reg(input clk, rst, freeze, flush,
input [31:0] PC_in, Instruction_in, output reg [31:0] PC, Instruction
);

always @(posedge clk, posedge rst) begin
    if(rst) begin
        PC <= 32'b0;
        Instruction <=32'b0;
    end
    else if(clk) begin
        if(~freeze) begin
            PC<=PC_in;
            Instruction<=Instruction_in;
        end
    end
end
endmodule



module ID_stage_Reg(input clk, rst, 
                    input [31:0] PC_IN, 
                    input WB_EN_IN,
                    input MEM_R_EN_IN,
                    input MEM_W_EN_IN,
                    input [3:0] EXE_CMD_IN,
                    input B_IN, 
                    input S_IN,
                    input [31:0] Val_RN_IN,
                    input [31:0] Val_RM_IN,
                    input [11:0] imm_IN,
                    input [11:0] shift_operand_IN,
                    input [23:0] signed_immed_24_IN,
                    input [3:0] WB_Dest_IN,
                    input flush_IN,
                    input [31:0] status_IN,



                    output reg [31:0] PC,
                    output reg WB_EN,
                    output reg MEM_R_EN,
                    output reg MEM_W_EN,
                    output reg B, 
                    output reg S,
                    output reg [31:0] Val_RN,
                    output reg [31:0] Val_RM,
                    output reg [11:0] imm,
                    output reg [11:0] shift_operand,
                    output reg [23:0] signed_immed_24,
                    output reg [3:0] WB_Dest,
                    output reg [31:0] status

                    );

                    always @(posedge clk, posedge rst) begin
                        if(rst) begin
                            PC <= 32'b0; 
                            WB_EN <= 0;
                            MEM_R_EN <= 0;
                            MEM_W_EN <= 0;
                            B <= 0;
                            S <= 0;
                            Val_RN <= 0;
                            Val_RM <= 0;
                            imm <= 0;
                            shift_operand <= 0;
                            signed_immed_24 <= 0;
                            WB_Dest <= 0;
                            status <= 0;
                        end
                        else if(clk) begin
                            PC<=PC_IN;
                            WB_EN <= WB_EN_IN;
                            MEM_R_EN <= MEM_R_EN_IN;
                            MEM_W_EN <= MEM_W_EN_IN;
                            B <= B_IN;
                            S <= S_IN;
                            Val_RN <= Val_RN_IN;
                            Val_RM <= Val_RM_IN;
                            imm <= imm_IN;
                            shift_operand <= shift_operand_IN;
                            signed_immed_24 <= signed_immed_24_IN;
                            WB_Dest <= WB_Dest_IN;
                            status <= status_IN;
                        end
                    end
endmodule



module EX_stage_Reg(input clk, rst,
                    input WB_EN_IN,
                    input MEM_R_EN_IN,
                    input MEM_W_EN_IN,
                    input [31:0] ALU_Res_IN,
                    input [31:0] Val_RM_IN,
                    input [3:0] WB_Dest_IN,

                    output reg WB_EN,
                    output reg MEM_R_EN,
                    output reg MEM_W_EN,
                    output reg [31:0] ALU_Res,
                    output reg [31:0] Val_RM,
                    output reg [3:0] WB_Dest
                    );
                    always @(posedge clk, posedge rst) begin
                        if(rst) begin
                            PC <= 32'b0;

                            WB_EN <= 0;
                            MEM_R_EN <= 0;
                            MEM_W_EN <= 0;
                            ALU_Res <= 0;
                            Val_RM <= 0;
                            WB_Dest <= 0;

                        end
                        else if(clk) begin
                            PC<=PC_in;

                            WB_EN <= WB_EN_IN;
                            MEM_R_EN <= MEM_R_EN_IN;
                            MEM_W_EN <= MEM_W_EN_IN;
                            ALU_Res <= ALU_Res_IN;
                            Val_RM <= Val_RM_IN;
                            WB_Dest <= WB_Dest_IN;

                        end
                    end
endmodule
module MEM_stage_Reg(
                    input clk, rst, 
                    input WB_EN_IN,
                    input MEM_R_EN_IN,
                    input [31:0] ALU_Res_IN,
                    input [31:0] MEMdata_IN,
                    input [3:0] WB_Dest_IN,

                    output reg WB_EN,
                    output reg MEM_R_EN,
                    output reg [31:0] ALU_Res,
                    output reg [31:0] MEMdata,
                    output reg [3:0] WB_Dest
                    );
                    always @(posedge clk, posedge rst) begin
                        if(rst) begin

                            WB_EN <= 0;
                            MEM_R_EN <= 0;
                            ALU_Res <= 0;
                            MEMdata <= 0;
                            WB_Dest <= 0;

                        end
                        else if(clk) begin

                            WB_EN <= WB_EN_IN;
                            MEM_R_EN <= MEM_R_EN_IN;
                            ALU_Res <= ALU_Res_IN;
                            MEMdata <= MEMdata_IN;
                            WB_Dest <= WB_Dest_IN;
                        end
                    end
endmodule

