module Condition_Check(input [3:0] cond,input clk,input rst,
                       input [3:0] SR,output reg cond_out);
  always @(*)
  begin
    if (rst==1)
      begin
        cond_out=0;
      end else begin
        if (cond==4'b1110)
          cond_out=1;
        else begin
          case(cond)
            4'b0000 : cond_out =    SR[2] ? 1'b1 : 1'b0 ;
            4'b0001 : cond_out = (~SR[2]) ? 1'b1 : 1'b0 ;
            4'b0010 : cond_out =    SR[1] ? 1'b1 : 1'b0 ;
            4'b0011 : cond_out = (~SR[1]) ? 1'b1 : 1'b0 ;
            4'b0100 : cond_out =    SR[3] ? 1'b1 : 1'b0 ;
            4'b0101 : cond_out = (~SR[3]) ? 1'b1 : 1'b0 ;
            4'b0110 : cond_out =    SR[0] ? 1'b1 : 1'b0 ;
            4'b0111 : cond_out = (~SR[0]) ? 1'b1 : 1'b0 ;
            4'b1000 : cond_out = ((~SR[2]) &&  SR[1]) ? 1'b1 : 1'b0 ;
            4'b1001 : cond_out = ((~SR[1]) &&  SR[2]) ? 1'b1 : 1'b0 ;
            4'b1010 : cond_out =    (SR[3] ==  SR[0]) ? 1'b1 : 1'b0 ;
            4'b1011 : cond_out =    (SR[3] !=  SR[0]) ? 1'b1 : 1'b0 ;
            4'b1100 : cond_out =    ((~SR[2])&&(SR[3] ==  SR[0])) ? 1'b1 : 1'b0 ;
            4'b1101 : cond_out =    ( (SR[2])&&(SR[3] !=  SR[0])) ? 1'b1 : 1'b0 ;
				default : cond_out = 1'b0;
          endcase
        end
      end
    end
  endmodule
