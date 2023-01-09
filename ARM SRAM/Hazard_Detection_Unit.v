module Hazard_Detection_Unit (
    src1,
    src2,
    EXE_Dest,
    MEM_Dest,
    Two_src,
    EXE_WB_EN,
    MEM_WB_EN,
    EXE_MEM_R_EN,
    withForwarding,

    Hazard
);

    input [3:0] src1;
    input [3:0] src2;
    input [3:0] EXE_Dest;
    input [3:0] MEM_Dest;
    input Two_src;
    input EXE_WB_EN;
    input MEM_WB_EN;
    input withForwarding;
    input EXE_MEM_R_EN;

    output reg Hazard;

    always @(*)
    begin
      Hazard = 1'b0;
      if(~withForwarding)begin
        if ((src1 == EXE_Dest) && (EXE_WB_EN == 1'b1))
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

      else if(withForwarding)begin
        if ((src1 == EXE_Dest) && EXE_MEM_R_EN)
            Hazard = 1'b1;
        else
        if ((src2 == EXE_Dest) && (Two_src == 1'b1) && EXE_MEM_R_EN)
            Hazard = 1'b1;
        else
            Hazard = 1'b0;
      end
      else
        Hazard=1'b0;
    end

endmodule
