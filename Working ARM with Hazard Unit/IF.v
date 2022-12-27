module IF_Stage (
    input clk, rst, freeze, Branch_taken, 
    input [31:0] BranchAddr,
    output [31:0] PC, Instruction
);
wire [31:0] PC_in;
reg [31:0] PC_reg;
always @(posedge clk, posedge rst) begin
    if(rst) PC_reg <= 32'b0;
    else if(clk)begin
        if(~freeze) begin 
            PC_reg <= PC_in;
            end
        else begin
            PC_reg <= PC_reg;
        end
    end

end
assign PC = PC_reg+4;
assign PC_in = Branch_taken?BranchAddr:PC;
InstMem IM (clk, PC_reg, Instruction);
endmodule