`timescale 1ns/1ns
module SRAM(
  CLK,
  RST,
  SRAM_WE_N,
  SRAM_ADDR,
  SRAM_DQ
  );

  input CLK,RST,SRAM_WE_N;
  input[16:0] SRAM_ADDR;

  inout[31:0] SRAM_DQ;

  reg[31:0] memory[0:511];

  assign #30 SRAM_DQ = SRAM_WE_N ? memory[SRAM_ADDR] : 32'bz;

  always@(posedge CLK)begin
    if(~SRAM_WE_N)
      memory[SRAM_ADDR] = SRAM_DQ;
  end

  endmodule
