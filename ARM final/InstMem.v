// module InstMem(input clk, input [31:0] address, output [31:0] Inst);
// reg[7:0] mem[0:65535];
// initial begin
// $readmemb("InstMem.mem",mem);    
// end
// assign Inst={mem[address],mem[address+1],mem[address+2],mem[address+3]};
// endmodule


module InstMem(input clk, input [31:0] address, output reg [31:0] Inst);
always @(address) begin
    case(address)
        32'd0:  Inst = 32'b1110_00_1_1101_0_0000_0010_000100000011;
        32'd4:  Inst = 32'b1110_00_0_0100_1_0010_0011_000000000010;
        32'd8:  Inst = 32'b1110_01_0_0100_0_0000_0011_000000001000;
        // 32'd12: Inst = 32'b000000_00111_01000_00010_00000000000;
        // 32'd16: Inst = 32'b000000_00111_01000_00010_00000000000;
        // 32'd20: Inst = 32'b000000_01011_01100_00000_00000000000;
        // 32'd24: Inst = 32'b000000_01101_01110_00000_00000000000;
        default Inst = 32'b0;
    endcase
end
endmodule

// 32'b1110_00_1_1101_0_0000_0010_000100000011; //MOV		R2 ,#0xC0000000	//R2 = -1073741824
// 32'b1110_00_0_0100_1_0010_0011_000000000010; 