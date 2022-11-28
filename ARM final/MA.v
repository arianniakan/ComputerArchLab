module MEM_stage (
    input clk,
    input WB_EN,
    input MEM_R_EN,
    input MEM_W_EN,
    input [31:0] ALU_Res,
    input [31:0] Val_RM,
    input [3:0] WB_Dest,

    output wire [31:0] Mem_out

);


Mem     (.clk(clk),
         .MemRead(MEM_R_EN),
         .MemWrite(MEM_W_EN),
         .in_address(ALU_Res),
         .WriteData(Val_RM),
         .ReadData(Mem_out)
         );


    
endmodule