module SORT_counter(input clk, rst, input [3:0] opcode, output reg counter);
    always @(posedge clk, posedge rst) begin
        if (rst)
            counter <= 0;
        else begin
            if (opcode == 4'b0011) begin
                counter <= ~counter;
            end
            else
              counter <= 0;
        end     
    end
endmodule
