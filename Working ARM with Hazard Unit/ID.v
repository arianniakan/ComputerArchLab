module ID_stage (
    input clk, rst,
    input [31:0] PC,
    input [31:0] Instruction,
    input [3:0] status,
    input wire [3:0] Dest_wb,
    input wire [31:0] Result_WB,
    input wire writeBackEn,
    input Hazard,

    output WB_EN,
    output MEM_R_EN,
    output MEM_W_EN,
    output [3:0] EXE_CMD,
    output B, 
    output S,
    output [31:0] Val_RN,
    output [31:0] Val_RM,
    output wire [3:0] src2,
    output has_src2
);
//instantiation of Condition Check and its assosiated wires
wire CondFlag;
wire [3:0] SR;
wire Z1, C1, N1, V1;
assign {Z1, C1, N1, V1} = status;
assign SR ={N1,Z1,C1,V1};
Condition_Check C2(.cond(Instruction[31:28]),.clk(clk),.rst(rst),
                       .SR(SR),.cond_out(CondFlag));

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

assign WB_EN =      (Hazard | (~CondFlag)) ? 1'b0 :WB_enable        ;
assign MEM_R_EN  =  (Hazard | (~CondFlag)) ? 1'b0 :mem_read         ;
assign MEM_W_EN =   (Hazard | (~CondFlag)) ? 1'b0 :mem_write        ;
assign EXE_CMD =    (Hazard | (~CondFlag)) ? 4'b0 :Execute_Command  ;
assign B =          (Hazard | (~CondFlag)) ? 1'b0 :B_out            ; 
assign S =          (Hazard | (~CondFlag)) ? 1'b0 :S_out            ;

//end of controlUnit instance


//register file instance and it's wires
assign src2 = mem_write ? (Instruction[15:12]):(Instruction[3:0]);

RegisterFile RF (.clk(clk), .rst(rst), 
                     .src1(Instruction[19:16]), .src2(src2), .Dest_wb(Dest_wb), 
                     .Result_WB(Result_WB), 
                     .writeBackEn(writeBackEn), 
                     .reg1(Val_RN), .reg2(Val_RM));


assign has_src2 = (~Instruction[25]) | mem_write;


    
endmodule