module Val2_Generator(
  input[31:0] Val_Rm,
  input[11:0] Shift_operand,
  input imm,
  input mem_acc,

  output reg[31:0] Val2
);

reg [63:0] tmp;

always @(Val_Rm, Shift_operand, imm, mem_acc) begin
  Val2 = 32'b0;
  tmp = 0;
  if (mem_acc == 1'b0) begin
    if (imm == 1'b1) begin
      Val2 = {24'b0 ,Shift_operand[7:0]};
      tmp = {Val2, Val2} >> (({{2'b0},Shift_operand[11:8]}) << 1);
      Val2 = tmp[31:0];
    end
    else if(imm == 1'b0 && Shift_operand[4] == 0) begin
      case(Shift_operand[6:5])
        2'b00 : begin
          Val2 = Val_Rm << Shift_operand[11:7];
        end
        2'b01 : begin
          Val2 = Val_Rm >> Shift_operand[11:7];
        end
        2'b10 : begin
          Val2 = Val_Rm >>> Shift_operand[11:7];
        end
        2'b11 : begin
          tmp = {Val_Rm, Val_Rm} >> (Shift_operand[11:7]);
          Val2 = tmp[31:0];
        end
      endcase
    end
  end
  else //is mem_command
    begin
      Val2 = { {20{Shift_operand[11]}} , Shift_operand[11:0]};
    end
 end

endmodule
