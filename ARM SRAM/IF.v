module IF_Stage(
  input clk, rst,
  freeze,
  Branch_taken,
  input[31:0] BranchAddr,
  output[31:0] PC,
  output [31:0] Instruction
);

  wire[31:0] nextPC, MUXout;
  reg[31:0]PCreg=0;
  always@(posedge clk, posedge rst)begin
    if(rst)
      PCreg<=0;
    else if(~freeze)
      PCreg<=MUXout;
  end
  assign PC=nextPC;
  assign nextPC=PCreg+4;
  assign MUXout=Branch_taken ? BranchAddr : nextPC;
  InstMem IM (clk, PCreg,  Instruction);


endmodule

