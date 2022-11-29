module HazardDetection (
    input  [3:0] src1,
    input  [3:0] src2,
    input  [3:0] EXE_dest,
    input  [3:0] MEM_dest,
    input        EXE_WB_en,
    input        MEM_WB_en,
    input        has_src2,
    output reg   Hazard
);

always @(*) begin
	Hazard = 1'b0;
    if ((src1 == EXE_dest) && (EXE_WB_en == 1'b1)) begin
        Hazard = 1'b1;
    end
    else if ((src1 == MEM_dest) && (MEM_WB_en == 1'b1)) begin
        Hazard = 1'b1;
    end
    else if ((src2 == EXE_dest) && (EXE_WB_en == 1'b1) && (has_src2 == 1'b1)) begin
        Hazard = 1'b1;
    end
    else if ((src2 == MEM_dest) && (MEM_WB_en == 1'b1) && (has_src2 == 1'b1)) begin
        Hazard = 1'b1;
    end

end

endmodule
