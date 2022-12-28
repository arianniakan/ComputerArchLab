module ALU(
  input[3:0] EXE_CMD,
  input[31:0] Val1, Val2,
  input[3:0] SR,
  output[3:0] status,
  output reg[31:0] ALU_result
);


  wire Nin,Zin,Cin,Vin;
  wire N,Z;
  reg C,V;

  assign {Nin,Zin,Cin,Vin}=SR;
  assign status={N,Z,C,V};
  assign N=ALU_result[31];
  assign Z=(ALU_result==0) ? 1'b1 : 1'b0;
  parameter [3:0] MOV=4'b0001,MVN=4'b1001,ADD=4'b0010,ADC=4'b0011,
                SUB=4'b0100,AND=4'b0110,SBC=4'b0101,
                ORR=4'b0111,EOR=4'b1000,CMP=4'b0100,
                TST=4'b0110,LDR=4'b0010,STR=4'b0010;
  always@(*)
  begin
    case(EXE_CMD)
      MOV: begin ALU_result=Val2; C=0; V=0; end
      MVN: begin ALU_result=~Val2; C=0; V=0; end
      ADD: begin
        {C,ALU_result}=Val1+Val2;
        V=((Val1[31] == Val2[31]) & (ALU_result[31] != Val1[31]));
      end
      ADC: begin
        {C,ALU_result}=Val1+Val2+{31'b0,Cin};
        V=((Val1[31] == Val2[31]) & (ALU_result[31] != Val1[31]));
      end
      SUB: begin
        {C,ALU_result}=Val1-Val2;
        V=((Val1[31] == ~Val2[31]) & (ALU_result[31] != Val1[31]));
      end
      SBC: begin
        {C,ALU_result}=Val1-Val2-{31'b0,~Cin};
        V=((Val1[31] == ~Val2[31]) & (ALU_result[31] != Val1[31]));
      end
      AND: begin ALU_result=Val1 & Val2; C=0; V=0; end
      ORR: begin ALU_result=Val1 | Val2; C=0; V=0; end
      EOR: begin ALU_result=Val1 ^ Val2; C=0; V=0; end
      default: begin ALU_result=0; C=0; V=0; end
    endcase
  end

endmodule
