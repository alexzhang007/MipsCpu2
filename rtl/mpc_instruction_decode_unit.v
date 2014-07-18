//Author     : Alex Zhang(cgzhangwei@gmail.com)
//Date       : Jul.12.2014
//Desciption : instruction decode unit; instruction format see Figure 2.26
module InstructionDecodeUnit(
clk,
resetn,
iValidInstruction,
iFetchInstruction,
oOperation,
oFunctor,
oRFormat,
oRs,
oRt,
oRd,
oIFormat,
oImmediate,
oJFormat,
oTargetAddr,
oSFPInstruction, //Single Floating-Point Instruction
oDFPInstruction  //Double Floating-Point Instruction
);
input  clk;
input  resetn;
input  iValidInstruction;
input  iFetchInstruction;
output oOperation;
output oFunctor;
output oRFormat;
output oRs;
output oRt;
output oRd;
output oIFormat;
output oImmediate;
output oJFormat;
output oTargetAddr;
output oSFPInstruction; 
output oDFPInstruction;
wire                                 iValidInstruction;
wire [`INSTRUCTION_WIDTH-1:0]        iFetchInstruction;
reg  [`INSTRUCTION_OP_WIDTH-1:0]     oOperation;
reg  [`INSTRUCTION_FU_WIDTH-1:0]     oFunctor;
reg                                  oRFormat;
reg  [`INTERNAL_REGISTER_WIDTH-1:0]  oRs;
reg  [`INTERNAL_REGISTER_WIDTH-1:0]  oRt;
reg  [`INTERNAL_REGISTER_WIDTH-1:0]  oRd;
reg                                  oIFormat;
reg  [`IMMEDIATE_WIDTH-1:0]          oImmediate;
reg                                  oJFormat;
reg  [`TARGET_ADDR_WIDTH-1:0]        oTargetAddr;
reg                                  oSFPInstruction; 
reg                                  oDFPInstruction;
wire                                 wRFormat;
wire                                 wJFormat;
wire                                 wIFormat;
wire  [`INSTRUCTION_FU_WIDTH-1:0]    wFunctor;
wire  [`TARGET_ADDR_WIDTH-1:0]       wTargetAddr;
wire  [`IMMEDIATE_WIDTH-1:0]         wImmediate;
wire  [`INSTRUCTION_OP_WIDTH-1:0]    wOperation;
wire  [`INTERNAL_REGISTER_WIDTH-1:0] wRs;
wire  [`INTERNAL_REGISTER_WIDTH-1:0] wRt;
wire  [`INTERNAL_REGISTER_WIDTH-1:0] wRd;
reg                                  wSFPInstruction; 
reg                                  wDFPInstruction;

always @(*) begin 
    case (iFetchInstruction[`INSTRUCTION_WIDTH-1: `INSTRUCTION_WIDTH-`INSTRUCTION_OP_WIDTH-1])
        `OP_RFMT      : wRFormat =iValidInstruction ?  1'b1 : 1'b0;
        `OP_J, `OP_JAL: wJFormat =iValidInstruction ?  1'b1 : 1'b0;
         default      : wIFormat =iValidInstruction ?  1'b1 : 1'b0;
    endcase
end 
assign wOperation  = iValidInstruction ? iFetchInstruction[`INSTRUCTION_WIDTH-1: `INSTRUCTION_WIDTH-`INSTRUCTION_OP_WIDTH] : `INSTRUTION_OP_WIDTH'b0;
assign wFunctor    = iValidInstruction ? iFetchInstruction[`INSTRUCTION_FU_WIDTH-1:0] : `INSTRUCTION_FU_WIDTH'b0;
assign wTargetAddr = iValidInstruction ? iFetchInstruction[`TARGET_ADDR_WIDTH-1:0] : `TARGET_ADDR_WIDTH'b0;
assign wImmediate  = iValidInstruction ? iFetchInstruction[`IMMEDIATE_WIDTH-1:0] : `IMMEDIATE_WIDTH'b0;
assign wRs         = iValidInstruction ? iFetchInstruction[`INSTRUCTION_WIDTH-`INSTRUCTION_OP_WIDTH-1:`INSTRUCTION_WIDTH-`INSTRUCTION_OP_WIDTH-`INTERNAL_REGISTER_WIDTH] : `INTERNAL_REGISTER_WIDTH'b0; 
assign wRt         = iValidInstruction ? iFetchInstruction[`INSTRUCTION_WIDTH-`INSTRUCTION_OP_WIDTH-`INTERNAL_REGISTER_WIDTH-1:`INSTRUCTION_WIDTH-`INSTRUCTION_OP_WIDTH-`INTERNAL_REGISTER_WIDTH*2]: `INTERNAL_REGISTER_WIDTH'b0; 
assign wRd         = iValidInstruction ? iFetchInstruction[`INSTRUCTION_WIDTH-`INSTRUCTION_OP_WIDTH-`INTERNAL_REGISTER_WIDTH*2-1:`INSTRUCTION_WIDTH-`INSTRUCTION_OP_WIDTH-`INTERNAL_REGISTER_WIDTH*3]: `INTERNAL_REGISTER_WIDTH'b0;
assign wSFPInstruction = (wOperation == `OP_FLPT) & (wRs==`RS_SFP) ;
assign wDFPInstruction = (wOperation == `OP_FLPT) & (wRs==`RS_DFP) ;

always @(posedge clk or negedge resetn) begin 
    if (~resetn) begin 
        oRFormat        <= 1'b0;
        oIFormat        <= 1'b0;
        oJFormat        <= 1'b0;
        oFunctor        <= `INSTRUCTION_FU_WIDTH'b0;
        oTargetAddr     <= `TARGET_ADDR_WIDTH'b0;
        oImmediate      <= `IMMEDIATE_WIDTH'b0;
        oOperation      <= `INSTRUCTION_OP_WIDTH'b0;
        wRs             <= `INTERNAL_REGISTER_WIDTH'b0;
        wRt             <= `INTERNAL_REGISTER_WIDTH'b0;
        wRd             <= `INTERNAL_REGISTER_WIDTH'b0;
        oSFPInstruction <= 1'b0;
        oDFPInstruction <= 1'b0;
    end else begin 
        oRFormat        <= wRFormat;
        oIFormat        <= wIFormat;
        oJFormat        <= wJFormat;
        oFunctor        <= wFunctor;
        oTargetAddr     <= wTargetAddr;
        oImmediate      <= wImmediate;
        oOperation      <= wOperation;
        oRs             <= wRs;
        oRt             <= wRt;
        oRd             <= wRd;
        oSFPInstruction <= wSFPInstruction;
        oDFPInstruction <= wDFPInstruction;
    end 
endmodule 
