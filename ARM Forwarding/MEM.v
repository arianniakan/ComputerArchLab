module MEM_Stage(
  clk,
  rst,
  Val_Rm,
  ALU_Res,
  MEM_W_EN,
  MEM_R_EN,
  MEM_result
);
  input clk;
  input rst;
  input[31:0] Val_Rm;
  input[31:0] ALU_Res;
  input MEM_W_EN;
  input MEM_R_EN;

  output[31:0] MEM_result;

  reg[31:0] memory[0:63];
  wire[31:0] address;

  assign address= (ALU_Res-32'd1024) >> 2;
  
  assign MEM_result = MEM_R_EN ? memory[address] : 32'b0;

  always@(posedge clk)begin//write
    if(MEM_W_EN)
      memory[address] = Val_Rm;
  end

endmodule
