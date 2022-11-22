module ControlUnit (input S_in,
                    input [1:0] mode,
                    input [3:0] Op_code, 
                    output reg [3:0] Execute_Command,
                    output reg mem_read, mem_write, 
                    WB_enable, B, S_out);

                    localparam [3:0] MOV = 4'b1101, MVN = 4'b1111, ADD = 4'b0100, 
                                     ADC = 4'b0101, SUB = 4'b0010, SBC = 4'b0110,
                                     AND = 4'b0000, ORR = 4'b1100, EOR = 4'b0001, 
                                     CMP = 4'b1010, TST = 4'b1000, LDR = 4'b0100,
                                     STR = 4'b0100, NOP = 4'b0000;
always @(Op_code, mode, S_in) begin
    {Execute_Command, mem_read, mem_write, 
    WB_enable, B} = 8'b0;
    S_out = S_in;
    case (mode)
        2'b00: begin
        case (Op_code)
            MOV: begin Execute_Command = 4'b0001; WB_enable = 1'b1; S_out = S_in;end 
            MVN: begin Execute_Command = 4'b1001; WB_enable = 1'b1; S_out = S_in;end 
            ADD: begin Execute_Command = 4'b0010; WB_enable = 1'b1; S_out = S_in;end 
            ADC: begin Execute_Command = 4'b0011; WB_enable = 1'b1; S_out = S_in;end 
            SUB: begin Execute_Command = 4'b0100; WB_enable = 1'b1; S_out = S_in;end 
            SBC: begin Execute_Command = 4'b0101; WB_enable = 1'b1; S_out = S_in;end 
            AND: begin Execute_Command = 4'b0110; WB_enable = 1'b1; S_out = S_in;end 
            ORR: begin Execute_Command = 4'b0111; WB_enable = 1'b1; S_out = S_in;end 
            EOR: begin Execute_Command = 4'b1000; WB_enable = 1'b1; S_out = S_in;end 
            CMP: begin Execute_Command = 4'b0100; S_out = 1'b1; end
            TST: begin Execute_Command = 4'b0110; S_out = 1'b1; end
            default: begin {Execute_Command, mem_read, mem_write, 
            WB_enable, B} = 8'b0;     S_out = S_in; end
        endcase
        end
        2'b01: begin
            case (Op_code)

            LDR: begin  mem_read = 1'b1; Execute_Command = 4'b0010; WB_enable = 1'b1; S_out = 1'b1; end 
            STR: begin  mem_write = 1'b1; Execute_Command = 4'b0010; S_out = 1'b0; end
            endcase
        end
        2'b10: begin
            B = 1'b1;
        end
    endcase
    
end

endmodule