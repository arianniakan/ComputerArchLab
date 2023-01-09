module Hazard_Detection_Unit (
    src1,
    src2,
    EXE_Dest,
    MEM_Dest,
    Two_src,
    EXE_WB_EN,
    MEM_WB_EN,

    Hazard,
    sort_cycle_count,
);

    input [3:0] src1;
    input [3:0] src2;
    input [3:0] EXE_Dest;
    input [3:0] MEM_Dest;
    input Two_src;
    input EXE_WB_EN;
    input MEM_WB_EN;
    input sort_cycle_count;
    output reg Hazard;

    always @(*)
    begin
      Hazard = 1'b0;
      if (sort_cycle_count) Hazard = 1'b1;
      else if ((src1 == EXE_Dest) && (EXE_WB_EN == 1'b1))
        Hazard = 1'b1;
      else if ((src1 == MEM_Dest) && (MEM_WB_EN == 1'b1))
        Hazard = 1'b1;
      else if ((src2 == EXE_Dest) && (EXE_WB_EN == 1'b1) && (Two_src == 1'b1))
        Hazard = 1'b1;
      else if ((src2 == MEM_Dest) && (MEM_WB_EN == 1'b1) && (Two_src == 1'b1))
        Hazard = 1'b1;
      else
        Hazard = 1'b0;
    end

endmodule
