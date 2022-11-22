module Val2gen (
                    input m,
                    input signed [31:0] Val_RM,
                    input [11:0] imm,
                    input [11:0] shift_operand
                    output reg [31:0] Val2
);
    always @(m, Val_RM, imm, shift_operand) begin
        if(m)begin
            case(imm[11:8])
            4'd0: Val2 = {24'd0, imm[7:0]};
            4'd1: Val2 = {imm[1:0], 24'd0, imm[7:2]};
            4'd2: Val2 = {imm[3:0], 24'd0, imm[7:4]};
            4'd3: Val2 = {imm[5:0], 24'd0, imm[7:6]};
            4'd4: Val2 = {imm[7:0], 24'd0};
            4'd5: Val2 = {2'd0, imm[7:0], 22'd0};
            4'd6: Val2 = {4'd0, imm[7:0], 20'd0};
            4'd7: Val2 = {6'd0,imm[7:0], 18'd0};
            4'd8: Val2 = {8'd0, imm[7:0], 16'd0};
            4'd9: Val2 = {10'd0, imm[7:0], 14'd0};
            4'd10: Val2 = {12'd0, imm[7:0], 12'd0};
            4'd11: Val2 = {14'd0, imm[7:0], 10'd0};
            4'd12: Val2 = {16'd0, imm[7:0], 8'd0};
            4'd13: Val2 = {18'd0, imm[7:0], 6'd0};
            4'd14: Val2 = {20'd0, imm[7:0], 4'd0};
            4'd15: Val2 = {22'd0, imm[7:0], 2'd0};
            endcase
         end
        else begin 
            case (shift_operand[6:0])
                2'b00: Val2 = Val_RM << shift_operand[11:7];
                2'b01: Val2 = Val_RM >> shift_operand[11:7];
                2'b10: Val2 = Val_RM >>> shift_operand[11:7];
                2'b11: Val2 = Val_RM >> shift_operand[11:7] | Val_RM << ~shift_operand[11:7];
                default: 
            endcase
        end
    end
endmodule