module Status_Register(
  input[3:0] Status_in,
  input clk,S,

  output reg[3:0] Status
  );
  initial Status=4'b0000;
  always@(negedge clk)
  begin
    if(S)
      Status<=Status_in;
  end
endmodule
