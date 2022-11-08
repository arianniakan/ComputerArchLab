module ControlUnit (input S_in,
                    input [1:0] mode,
                    input [3:0] Op_code, 
                    output [3:0] Execute_Command,
                    output mem_read, mem_write, 
                    WB_enable, B, S_out);

                    localparam [3:0] = ;
always @(Op_code, mode) begin
    case (mode)
        2'b00: 
        case (Op_mode)
            4'b0001:
            4'b1111: 
            4'b0100: 
            4'b0101: 
            4'b0010: 
            4'b0110: 
            4'b0000: 
            4'b: 
            4'b: 
            4'b: 
 
            default: 
        endcase
        2'b01: 
        2'b10: 
        2'b11:
        default: 
    endcase
    
end

endmodule