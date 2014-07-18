//Author     : Alex Zhang(cgzhangwei@gmail.com)
//Date       : Jul.12.2014
//Desciption : graphics risc technology architecture see Figure 6.27
module RISC_CPU_Top(
clk,
resetn,
);
input clk;
input resetn;

///-------------------------------------------------
wire  [`INSTRUCTION_WIDTH-1:0] wFetchInstruction;
wire                           wValidInstruction;
InstructionFetchUnit IFU  (
  .clk(clk),
  .resetn(resetn),
  .iPCSrc (),
  .iIF_ID_PC(wIF_ID_PC1),
  .oIF_ID_PC(wIF_ID_PC2),
  .iPCWr(wPCWr),
  .oFetchInstruction(wFetchInstruction),
  .oValidInstruction(wValidInstruction)
);

///-------------------------------------------------
wire [`INSTRUCTION_OP_WIDTH-1:0]    wOperation;
wire [`INSTRUCTION_FU_WIDTH-1:0]    wFunctor;
wire [`INTERNAL_REGISTER_WIDTH-1:0] wRs;
wire [`INTERNAL_REGISTER_WIDTH-1:0] wRt;
wire [`INTERNAL_REGISTER_WIDTH-1:0] wRd;
wire                                wIFormat;
wire                                wJFormat;
wire                                wRFormat;
wire [`IMMEDIATE_WIDTH-1:0]         wOpImmediate;
wire [`TARGET_ADDR_WIDTH-1:0]       wTargetAddr;
wire                                wSFPInstruction;
wire                                wDFPInstruction;
wire                                wIDU_Ready;

InstructionDecodeUnit IDU (
  .clk(clk),
  .resetn(resetn),
  .iValidInstruction(wValidInstruction),
  .iFetchInstruction(wFetchInstruction),
  .oOperation(wOperation),
  .oFunctor(wFunctor),
  .oRs(wRs),
  .oRt(wRt),
  .oRd(wRd),
  .oIFormat(wIFormat),
  .oJFormat(wJFormat),
  .oRFormat(wRFormat),
  .oImmediate(wOpImmediate),
  .oTargetAddr(wTargetAddr),
  .oSFPInstruction(wSFPInstruction),
  .oDFPInstruction(wDFPInstruction),
  .oValidInstruction(wIDU_Ready),
);

///-------------------------------------------------
wire [`ALU_OP_WIDTH-1:0] wALUOperation;
wire                     wAOD_Immediate;
wire                     wAOD_Sign;
InstructionScheduleUnit  ISU(
  .clk(clk),
  .resetn(resetn),
  .iValidInstruction(wIDU_Ready),
  .iRs(wRs),
  .iRt(wRt),
  .iRd(wRd),
  .iImmediate(wOpImmediate),
  .iTargetAddr(wTargetAddr),
  .iSFPInstruction(wSFPInstruction),
  .iDFPInstruction(wDFPInstruction),
  .oRt(wISU_Rt),
  .oRd(wISU_Rd),
  .oRsData(wRsData),
  .oRtData(wRtData),
  .oImmediate(wISU_Immediate),
  .oTargetAddr(wISU_TargetAddr),
  .oReady(wISU_Ready)
);

ALUOpDecode AOD(
  .iOperation(wOperation),
  .iFunctor(wFunctor),
  .oALUOperation(wALUOperation),
  .oImmediate(wAOD_Immediate),
  .oSign(wAOD_Sign)
)


///-------------------------------------------------
ExecutionUnit EU (
  .clk(clk),
  .resetn(resetn),
  .iValid(wISU_Ready),
  .iA(wRsData),
  .iB(wRtData),
  .iALUOperation(wALUOperation),
  .iSign(wAOD_Sign),
  .oALUOut(wEU_ALUOut),
  .oZero(wEU_Zero),
  .oOverflow(wEU_Overflow),
  .oUnderflow(wEU_Underflow),
  .oReady(wEU_Ready)
);


endmodule 
