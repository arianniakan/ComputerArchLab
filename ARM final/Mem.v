module Mem(input clk, MemRead, MemWrite, 
           input [31:0] in_address, WriteData, 
           output [31:0] ReadData
           );
           
reg[7:0] mem[0:63];
wire [5:0] address;
assign address = in_address - 32'd1024;
// initial $readmemb("DataMem.mem",mem,1000); 
always @(negedge clk) 
    if (MemWrite) {mem[address],mem[address+1],mem[address+2],mem[address+3]}=WriteData;
assign ReadData=MemRead?{mem[address],mem[address+1],mem[address+2],mem[address+3]}:32'b0;
endmodule
