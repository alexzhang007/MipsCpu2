//Author     : Alex Zhang(cgzhangwei@gmail.com)
//Date       : Jul.12.2014
//Desciption : instruction fetch unit
module InstructionFecthUnit (
clk,
resetn,
iEX_MEM_PC,
iPCSrc,
iIF_ID_PC,
oIF_ID_PC,
iPCWr,
oFetchInstruction,
oValidInstruction
);
input  clk;
input  resetn;
input  iEX_MEM_PC;
input  iPCSrc;
input  iIF_ID_PC;
input  oIF_ID_PC;
input  iPCWr;
output oFetchInstruction;
output oValidInstruction;
wire [`INSTRUCTION_WIDTH-1:0]  iEX_MEM_PC;
wire                           iPCSrc;
wire [`INSTRUCTION_WIDTH-1:0]  iIF_ID_PC;
wire                           iPCWr;
reg  [`INSTRUCTION_WIDTH-1:0]  oFetchInstruction;
reg                            oValidInstruction;
reg  [`INSTRUCTION_WIDTH-1:0]  oIF_ID_PC;

reg  [`INSTRUCTION_WIDTH-1:0]  iMem[0 : `INSTRUCTION_SIZE-1];
reg  [`INSTRUCTION_WIDTH-1:0]  rPC;


always @(posedge clk or negedge resetn) begin 
    if (~resetn) begin 
         rPC               <= `INSTRUCTION_WIDTH'b0;
         oIF_ID_PC         <= `INSTRUCTION_WIDTH'b0;
         oValidInstruction <= 1'b0;
    end else begin 
         rPC               <= iPCSrc ?  iEX_MEM_PC  : 
                              iPCWr  ?  rPC - 32'h8 : rPC + 32'h4; 
         oIF_ID_PC         <= iPCWr  ?  iIF_ID_PC   : rPC;
         oValidInstruction <= 1'b1;
    end 
end 

always @(*) begin 
     oFetchInstruction = iMem[rPC];
end 

endmodule 
