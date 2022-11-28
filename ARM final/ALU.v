module ALU (input [3:0] ALU_Comnd,
            input [31:0] Val1,Val2,
            input C,
            output reg [31:0] ALU_out,
            output [3:0] SR);

reg V1, C1;
wire N1, Z1;


assign SR = {Z1, C1, N1, V1};

assign N1 = ALU_out[31];
assign Z1 = |ALU_out ? 0:1;
parameter [3:0] MOV=4'b0001,MVN=4'b1001,ADD=4'b0010,ADC=4'b0011,         SUB=4'b0100,AND=4'b0110,SBC=4'b0101,
                ORR=4'b0111,EOR=4'b1000,CMP=4'b0100,TST=4'b0110,LDR=4'b0010,STR=4'b0010;
always @(ALU_Comnd,Val1,Val2) begin
    case (ALU_Comnd)
    MOV:  ALU_out = Val2;
    MVN:  ALU_out = ~Val2;
    ADD:  begin {C1, ALU_out} = Val1+Val2;
                    V1 = (val1[31] ^ val2[31]) & (ALU_out[31] ^ val1[31]);

    end
    ADC:  begin {C1, ALU_out} = Val1+Val2+C; V1 = (val1[31] ^ val2[31]) & (ALU_out[31] ^ val1[31]);end
    SUB:  begin {C1, ALU_out} = Val1-Val2; V1 = (val1[31] ^ val2[31]) & (ALU_out[31] ^ val1[31]);end
    SBC:  begin {C1, ALU_out} = Val1-Val2-~C; V1 = (val1[31] ^ val2[31]) & (ALU_out[31] ^ val1[31]);end
    AND:  ALU_out = Val1&Val2;
    ORR:  ALU_out = Val1|Val2;
    EOR:  ALU_out = Val1^Val2;
    CMP:  begin {C1, ALU_out} = Val1-Val2; V1 = (val1[31] ^ val2[31]) &     (ALU_out[31] ^ val1[31]);end
    TST:  ALU_out = Val1&Val2;
    LDR:  ALU_out = Val1+Val2;
    STR:  ALU_out = Val1+Val2;
        default: ALU_out=32'b0;
    endcase 
end
endmodule