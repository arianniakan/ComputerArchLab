module RegisterFile( input clk, rst, 
                     input [3:0] src1, src2, Dest_wb, 
                     input [31:0] Result_WB, 
                     input writeBackEn, 
                     output [31:0] reg1, reg2);
reg [31:0] REGS [0:14];

always @(negedge clk, posedge rst) begin
    if(rst) begin
        REGS[0] <= 32'b0;
        REGS[1] <= 32'd1;
        REGS[2] <= 32'd2;
        REGS[3] <= 32'd3;
        REGS[4] <= 32'd4;
        REGS[5] <= 32'd5;
        REGS[6] <= 32'd6;
        REGS[7] <= 32'd7;
        REGS[8] <= 32'd8;
        REGS[9] <= 32'd9;
        REGS[10] <= 32'd10;
        REGS[11] <= 32'd11;
        REGS[12] <= 32'd12;
        REGS[13] <= 32'd13;
        REGS[14] <= 32'd14;
    end
    else if (~clk) begin
        if (writeBackEn) REGS[Dest_wb] <= Result_WB;
    end
end
assign reg1 = REGS[src1];
assign reg2 = REGS[src2];
endmodule