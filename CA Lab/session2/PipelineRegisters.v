module IF_stage_Reg(input clk, rst, freeze, flush,
input [31:0] PC_in, Instruction_in, output reg [31:0] PC, Instruction
);

always @(posedge clk, posedge rst) begin
    if(rst) begin
        PC <= 32'b0;
        Instruction <=32'b0;
    end
    else if(clk) begin
        PC<=PC_in;
        Instruction<=Instruction_in;
    end
end
endmodule

module ID_stage_Reg(input clk, rst, input)