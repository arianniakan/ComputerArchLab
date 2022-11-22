module ConditionCheck(input [3:0] Cond,
                      input Z, C , N, V,
                      output reg CondFlag);

parameter [3:0] EQ = 4'b0000,NE=4'b0001,CS_HS=4'b0010,CC_LO=4'b0011,MI=4'b0100,PL=4'b0101,VS=4'b0110,
                VC=4'b0111 , HI=4'b1000,LS=4'b1001,GE=4'b1010,LT=4'b1011,GT=4'b1100,LE=4'b1101,AL=4'b1110, 
                NOP=4'b1111;

 always @(Cond,Z,C,N,V) begin
    case (Cond)
        EQ: CondFlag = Z ? 1'b1 : 1'b0;
        NE: CondFlag = ~Z ? 1'b1 : 1'b0;
        CS_HS: CondFlag = C ? 1'b1 : 1'b0;
        CC_LO: CondFlag = ~C ? 1'b1 : 1'b0;
        MI: CondFlag = N ? 1'b1 : 1'b0;
        PL: CondFlag = ~N ? 1'b1 : 1'b0;
        VS: CondFlag = V ? 1'b1 : 1'b0;
        VC: CondFlag= ~V ? 1'b1 : 1'b0;
        HI: CondFlag= (C&~Z) ? 1'b1 : 1'b0;
        LS: CondFlag= (~C|Z) ? 1'b1 : 1'b0;
        GE: CondFlag= ((N&V)|(~N&~V)) ? 1'b1 : 1'b0;
        LT: CondFlag= ((N&~V)|(~N&V)) ? 1'b1 : 1'b0;
        GT: CondFlag= ((~Z&(N|V))|(~N&~V)) ? 1'b1 : 1'b0;
        LE: CondFlag= ((Z|(N&~V))|(~N&V)) ? 1'b1 : 1'b0;
        AL: CondFlag=1'b1;
        NOP: CondFlag=1'b0;
        default:CondFlag=1'b0; 
    endcase
    
 end   





endmodule
