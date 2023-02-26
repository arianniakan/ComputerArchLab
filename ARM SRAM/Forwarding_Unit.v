module Forwarding_Unit(
  src1,
  src2,
  WB_WB_EN,
  MEM_WB_EN,
  MEM_Dest,
  WB_Dest,
  Sel_src1,
  Sel_src2
  );

  input[3:0] src1,src2,MEM_Dest,WB_Dest;
  input WB_WB_EN,MEM_WB_EN;

  output reg[1:0] Sel_src1, Sel_src2;

  always@(*)begin
    if(src1 == MEM_Dest && MEM_WB_EN)
      Sel_src1=2'd1;
    else if(src1 == WB_Dest && WB_WB_EN)
      Sel_src1=2'd2;
    else
      Sel_src1=2'd0;
  end

  always@(*)begin
    if(src2 == MEM_Dest && MEM_WB_EN)
      Sel_src2=2'd1;
    else if(src2 == WB_Dest && WB_WB_EN)
      Sel_src2=2'd2;
    else
      Sel_src2=2'd0;
  end

endmodule
