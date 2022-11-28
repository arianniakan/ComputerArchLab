module ID_stage (
    input clk, rst,
    input [31:0] PC,
    input [31:0] Instruction,
    input [3:0] status,
    input wire [3:0] Dest_wb,
    input wire [31:0] Result_WB,
    input wire writeBackEn,
    

    output WB_EN,
    output MEM_R_EN,
    output MEM_W_EN,
    output [3:0] EXE_CMD,
    output B, 
    output S,
    output [31:0] Val_RN,
    output [31:0] Val_RM
);
//instantiation of Condition Check and its assosiated wires
wire CondFlag;
wire Z1, C1, N1, V1;
assign {Z1, C1, N1, V1} = status;
ConditionCheck Cond_check_inst (.Cond(Instruction[31:28]),
                      .Z(Z1), .C(C1) , .N(N1), .V(V1),
                      .CondFlag(CondFlag));

//end of Condition Check


//controlUnit instance and its assosiate wires
wire [3:0] Execute_Command;
wire mem_read, mem_write, WB_enable, B_out, S_out;


ControlUnit CU (.S_in(Instruction[20]),
                    .mode(Instruction[27:26]),
                    .Op_code(Instruction[24:21]), 
                    .Execute_Command(Execute_Command),
                    .mem_read(mem_read), .mem_write(mem_write), 
                    .WB_enable(WB_enable), .B(B_out), .S_out(S_out));

assign WB_EN =      CondFlag? WB_enable : 1'b0;
assign MEM_R_EN  =  CondFlag? mem_read : 1'b0;
assign MEM_W_EN =   CondFlag? mem_write : 1'b0;
assign EXE_CMD =    CondFlag? Execute_Command : 4'b0;
assign B =          CondFlag? B_out : 1'b0; 
assign S =          CondFlag? S_out : 1'b0;

//end of controlUnit instance


//register file instance and it's wires
wire [3:0] src2 = mem_write ? (Instruction[15:12]):(Instruction[3:0]);

RegisterFile RF (.clk(clk), .rst(rst), 
                     .src1(Instruction[19:16]), .src2(src2), .Dest_wb(Dest_wb), 
                     .Result_WB(Result_WB), 
                     .writeBackEn(writeBackEn), 
                     .reg1(Val_RN), .reg2(Val_RM));




    
endmodule