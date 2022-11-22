module ID_stage (
    input [31:0] PC,
    input [31:0] Instruction,
    input [31:0] status,

);
//instantiation of Condition Check and its assosiated wires
wire CondFlag;

ConditionCheck Cond_check_inst (Instruction[31:28],
                      status[30], status[29], status[31], status[28],
                      CondFlag);
//end of Condition Check


//controlUnit inst and its assosiate wires
wire Execute_Command


ControlUnit (.S_in(Instruction[20]),
                    .mode(Instruction[27:26]),
                    .Op_code(Instruction[24:21]), 
                    output reg [3:0] Execute_Command,
                    output reg mem_read, mem_write, 
                    WB_enable, B, S_out);






    
endmodule