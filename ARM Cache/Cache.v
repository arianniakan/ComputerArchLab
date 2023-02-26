module cache(
  clk,
  rst,
  address,
  wdata,
  cache_w_en,
  invalidate,
  change_LRU,

  hit_or_miss,
  rdata
  );

  input clk,rst;
  input[18:0] address;
  input[31:0] wdata;
  input cache_w_en;
  input invalidate;
  input change_LRU;

  output hit_or_miss;
  output[31:0] rdata;

  reg[31:0] datablk[0:63][0:3];



  reg[9:0] tag [0:63][0:1];

  reg valid [0:63][0:1];

  reg LRU [0:63];

  wire hit_or_miss0, hit_or_miss1;
  wire[9:0] tag_in;
  wire[5:0] index;
  wire LSB_or_MSB;

  assign tag_in=address[18:9];
  assign index=address[8:3];
  assign LSB_or_MSB=address[2];

  assign hit_or_miss0=((tag[index][0] == tag_in) && valid[index][0]);
  assign hit_or_miss1=((tag[index][1] == tag_in) && valid[index][1]);
  assign hit_or_miss=(hit_or_miss0 | hit_or_miss1);

  assign rdata=datablk[index][{hit_or_miss1,LSB_or_MSB}];


  always@(posedge clk)begin
    if(invalidate)
      valid[index][hit_or_miss1]<=1'b0;
    else if(cache_w_en)begin
      valid[index][LRU[index]]<=1'b1;
      datablk[index][{LRU[index],LSB_or_MSB}]<=wdata;
      if(change_LRU)
        LRU[index]<=~LRU[index];

    end
  end

  integer i;
  initial begin
    for(i=0;i<64;i=i+1)begin
      valid[i][0]=1'b0;
      valid[i][1]=1'b0;
      tag[i][0]=10'b0;
      tag[i][1]=10'b0;
      LRU[i]=1'b0;
    end
  end

endmodule
