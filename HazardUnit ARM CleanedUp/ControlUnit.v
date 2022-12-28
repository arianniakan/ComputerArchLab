module ControlUnit(input[3:0]op_code,
                   input [1:0]mode,
                   input S,
                   output reg SS,
                   B,
                   MEM_R_EN,
                   MEM_W_EN,
                   WB_EN,
                   output reg [3:0] EXE_CMD);

localparam [3:0] MOV = 4'b1101, MVN = 4'b1111, ADD = 4'b0100, 
                 ADC = 4'b0101, SUB = 4'b0010, SBC = 4'b0110,
                 AND = 4'b0000, ORR = 4'b1100, EOR = 4'b0001, 
                 CMP = 4'b1010, TST = 4'b1000, LDR = 4'b0100,
                 STR = 4'b0100, NOP = 4'b0000;

    always@(op_code,mode,S)begin
    EXE_CMD = 4'b0; MEM_R_EN = 0; WB_EN = 0; MEM_W_EN = 0; B = 0;  SS = 0;
    case (mode)
      2'b00:
        case (op_code)
          MOV: begin EXE_CMD = 4'b0001; MEM_R_EN = 0;  WB_EN = 1; MEM_W_EN = 0;B = 0;  SS = S; end
          MVN: begin EXE_CMD = 4'b1001; MEM_R_EN = 0; WB_EN = 1; MEM_W_EN = 0; B = 0;  SS = S; end
          ADD: begin EXE_CMD = 4'b0010; MEM_R_EN = 0; WB_EN = 1; MEM_W_EN = 0; B = 0; SS = S;  end
          ADC: begin EXE_CMD = 4'b0011; MEM_R_EN = 0; WB_EN = 1; MEM_W_EN = 0; B = 0;  SS = S; end
          SUB: begin EXE_CMD = 4'b0100; MEM_R_EN = 0; WB_EN = 1; MEM_W_EN = 0; B = 0;  SS = S; end
          SBC: begin EXE_CMD = 4'b0101; MEM_R_EN = 0; WB_EN = 1; MEM_W_EN = 0; B = 0;  SS = S; end
          AND: begin EXE_CMD = 4'b0110; MEM_R_EN = 0; WB_EN = 1; MEM_W_EN = 0; B = 0;  SS = S; end
          ORR: begin EXE_CMD = 4'b0111; MEM_R_EN = 0; WB_EN = 1; MEM_W_EN = 0; B = 0;  SS = S; end
          EOR: begin EXE_CMD = 4'b1000; MEM_R_EN = 0; WB_EN = 1; MEM_W_EN = 0; B = 0;  SS = S; end
          CMP: begin EXE_CMD = 4'b0100; MEM_R_EN = 0; WB_EN = 0; MEM_W_EN = 0; B = 0;  SS = S; end
          TST: begin EXE_CMD = 4'b0110; MEM_R_EN = 0; WB_EN = 0; MEM_W_EN = 0; B = 0; SS = S;  end
          default: begin EXE_CMD = 4'b0; MEM_R_EN = 0; WB_EN = 0; MEM_W_EN = 0; B = 0;  SS = 0;end
        endcase
      2'b01:
        if(op_code == STR)begin
          if(S == 1'b1)begin EXE_CMD = 4'b0010; MEM_R_EN = 1; WB_EN = 1; MEM_W_EN = 0; B = 0;  SS = 1; end //LDR
          else begin EXE_CMD = 4'b0010; MEM_R_EN = 0; WB_EN = 0; MEM_W_EN = 1; B = 0; SS = 0; end//STR
        end
      2'b10: begin EXE_CMD = 4'bx; B = 1; MEM_R_EN = 0; WB_EN = 0; MEM_W_EN = 0;  SS = 0; end//B
      2'b11: begin EXE_CMD = 4'b0; MEM_R_EN = 0; WB_EN = 0; MEM_W_EN = 0; B = 0;  SS = 0; end//NOP
      default: begin EXE_CMD = 4'b0; MEM_R_EN = 0; WB_EN = 0; MEM_W_EN = 0; B = 0;  SS = 0; end//NOP;
    endcase
  end

endmodule
