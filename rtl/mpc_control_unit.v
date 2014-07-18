//Author     : Alex Zhang(cgzhangwei@gmail.com)
//Date       : Jul.12.2014
//Desciption : cpu control unit, pipeline delay will be here
module ControlUnit(
clk,
resetn,
iOperation,
iOverflow,
oRegDestination,
oRegWrite,
oMemtoReg,
oALUSrc,
oBranch,
oMemRead,
oMemWrite
);
input  clk;
input  resetn;
input  iOperation;
input  iOverflow;
output oRegDestination;
output oRegWrite;
output oMemtoReg;
output oALUSrc;
output oBranch;
output oMemRead;
output oMemWrite;
wire [`INSTRUCTION_OP_WIDTH-1:0] iOperation;
wire                             iOverflow;
reg                              oRegDestination;
reg                              oRegWrite;
reg                              oMemtoReg;
reg                              oALUSrc;
reg                              oBranch;
reg                              oMemRead;
reg                              oMemWrite;

parameter S_CU_NOP = 8'h00 ,
          S_CU_LW  = 8'h01 ,
          S_CU_SW  = 8'h02 ,
          S_CU_RFMT= 8'h03 ,
          S_CU_BEQ = 8'h04 ,
          S_CU_J   = 8'h05 ; 
          
reg [7:0] state; 

//Each cycle controls each instruction
always @(posedge clk or resetn) begin 
    if (~resetn) begin 
        state <= S_CU_NOP;
    end else begin 
        casex (iOperation)
            `OP_LW    :  state <= S_CU_LW;
            `OP_SW    :  state <= S_CU_SW;
            `OP_RFMT  :  state <= S_CU_RFMT;
            `OP_J     :  state <= S_CU_J;
            `OP_BEQ   :  state <= S_CU_BEQ;
            default   :  state <= S_CU_NOP;
        endcase 
    end 
end 


endmodule 
