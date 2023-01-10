
module ARM_TB;
  parameter clock_period = 10;

  reg clk;
  reg rst;
  reg enableForwarding;


  ARM_DP CPU(
    .clk(clk),
    .rst(rst)
  );

  initial begin
    clk = 0;
    forever clk = #clock_period ~clk;
  end

  initial begin
    enableForwarding = 1;
    rst = 1;
    # (clock_period / 2);
    rst = 0;
    # (1000*clock_period);
    $stop;
  end
endmodule