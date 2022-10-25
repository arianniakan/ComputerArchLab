module ARM_DP.v(input clk, rst);


wire [31:0] PC_IF, Instruction_IF;
wire [31:0] PC_ID, Instruction_ID;
wire [31:0] PC_EX, Instruction_EX;
wire [31:0] PC_MEM, Instruction_MEM;
wire [31:0] PC_WB, Instruction_WB;

IF_Stage IF_inst (
    .clk(clk), .rst(rst), .freeze(1'b0), .Branch_taken(1'b0), 
    .BranchAddr(32'b0),
    .PC(PC_IF), .Instruction(Instruction_IF)
);

IF_stage_Reg    IF_regs     (.clk(clk), .rst(rst), .freeze(1'b0), .flush(1'b0),
                             .PC_in(PC_IF), .Instruction(Instruction_IF), .PC(PC_ID), .Instruction(Instruction_ID)
                            );
ID_stage_Reg    ID_regs     (.clk(clk), .rst(rst), .PC_in(PC_ID), .PC(PC_EX));
EX_stage_Reg    EX_regs     (.clk(clk), .rst(rst), .PC_in(PC_EX), .PC(PC_MEM));
MEM_stage_Reg   Mem_regs    (.clk(clk), .rst(rst), .PC_in(PC_MEM), .PC(PC_WB));


endmodule