module cache_controller(
  clk,
  rst,

  address,
  wdata,
  MEM_R_EN,
  MEM_W_EN,

  rdata,
  ready,

  sram_rdata,
  sram_ready,

  sram_address,
  sram_wdata,
  sram_w_en,
  sram_r_en,

  hit,
  cache_rdata,

  cache_w_en,
  cache_wdata,
  cache_address,
  change_LRU,
  invalidate
  );

  input clk;
  input rst;

  //memory stage unit
  input[31:0] address;
  input[31:0] wdata;
  input MEM_R_EN;
  input MEM_W_EN;

  output[31:0] rdata;
  output ready;

  //SRAM controller
  input[31:0] sram_rdata;
  input sram_ready;

  output[31:0] sram_address;
  output[31:0] sram_wdata;
  output sram_w_en;
  output reg sram_r_en;

  //Cache
  input hit;
  input[31:0] cache_rdata;

  output reg cache_w_en;
  output[31:0] cache_wdata;
  output[18:0] cache_address;
  output reg change_LRU;
  output reg invalidate;

  reg[2:0] ps,ns;
  localparam  idle=0, state1=1, state2=2, state3=3, state4=4;
  reg other_address;

  assign ready= (hit | sram_ready) && ~(ps==state1 | ps==state2 | ps==state3);
  assign rdata= (hit) ? cache_rdata : sram_rdata;
  assign sram_address=address^({29'b0,other_address,2'b00});

  assign sram_w_en = MEM_W_EN;
  assign sram_wdata = (MEM_W_EN) ? wdata : 32'bz;
  assign cache_wdata=sram_rdata;
  assign cache_address=(address-32'd1024)^({29'b0,other_address,2'b00});

  always@(posedge clk, posedge rst)begin
    if(rst)
      ps<=idle;
    else
      ps<=ns;
  end

  always@(*)begin
    case(ps)
      idle: ns = (MEM_R_EN & ~hit) ? state1 :
                 (MEM_W_EN)        ? state4 :   
                  idle;
      state1: ns = sram_ready ? state2 : state1;
      state2: ns=state3;
      state3: ns=sram_ready ? idle : state3;
      state4: ns=(sram_ready) ? idle : state4;
      default: ns=idle;
    endcase
  end

  always@(ns)begin
    sram_r_en=1'b0; other_address=1'b0; cache_w_en=1'b0; invalidate=1'b0; change_LRU=1'b0;
    case({ps,ns})
      {3'd0,3'd1}: begin sram_r_en=1'b1; other_address=1'b1; end
      {3'd1,3'd2}: begin cache_w_en=1'b1; end
      {3'd2,3'd3}: begin sram_r_en=1'b1; change_LRU=11'b1; end
      {3'd3,3'd0}: begin cache_w_en=1'b1; end
      {3'd0,3'd4}: invalidate=1'b1;
    endcase
  end

endmodule
