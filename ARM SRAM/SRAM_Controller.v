module SRAM_Controller(
  clk,
  rst,
  write_en,
  read_en,
  address,
  writeData,

  readData,

  ready,

  SRAM_DQ,
  SRAM_ADDR,
  SRAM_UB_N,
  SRAM_LB_N,
  SRAM_WE_N,
  SRAM_CE_N,
  SRAM_OE_N
  );

  input clk;
  input rst;
  input write_en;
  input read_en;
  input [31:0] address;
  input [31:0] writeData;

  output [31:0] readData;
  output reg ready;
  inout [31:0] SRAM_DQ;
  output [16:0] SRAM_ADDR;
  output SRAM_UB_N;
  output SRAM_LB_N;
  output SRAM_WE_N;
  output SRAM_CE_N;
  output SRAM_OE_N;

  reg[2:0] clk_counter;
  initial clk_counter=3'b0;
  reg cnt_en, cnt_rst;
  initial begin cnt_en=1'b0; cnt_rst=1'b0; end

  reg ps,ns;

  localparam  idle = 0, w_r_wait = 1;
  assign SRAM_UB_N=1'b1;
  assign SRAM_LB_N=1'b1;
  assign SRAM_CE_N=1'b1;
  assign SRAM_OE_N=1'b1;
  assign SRAM_WE_N = ~write_en;
  assign SRAM_DQ = (write_en) ? writeData : 32'bz;
  assign readData = (read_en) ? SRAM_DQ : 32'bz;
  assign SRAM_ADDR = ((address-32'd1024) >> 2);


  always@(*)begin
    ready=1'b1;
    if(ns==w_r_wait)
      ready=1'b0;
  end

  always@(posedge clk, posedge rst) begin
    if(rst)
      ps<=1'b0;
    else
      ps<=ns;
  end

  always@(*)begin
    case(ps)
      idle: ns=(read_en | write_en) ? w_r_wait : idle;
      w_r_wait: ns=(clk_counter<3'd4) ? w_r_wait : idle;
    endcase
  end

  always@(ps)begin
    cnt_en=1'b0; cnt_rst=1'b0;
    case (ps)
      idle: cnt_rst=1'b1;
      w_r_wait: cnt_en=1'b1;
      default:begin cnt_en=1'b0; cnt_rst=1'b0; end
    endcase

  end

  always@(posedge clk, posedge cnt_rst, posedge rst)begin
    if(rst)
      clk_counter<=3'b0;
    else if(cnt_rst)
      clk_counter<=3'b0;
    else
      clk_counter<=clk_counter+3'd1;
  end



endmodule
