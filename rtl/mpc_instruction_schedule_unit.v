//Author     : Alex Zhang(cgzhangwei@gmail.com)
//Date       : Jul.12.2014
//Desciption : instruction schedule unit 
//             schedule the general register into GR group
//             schedule the floating-point register into FPR group
module InstructionScheduleUnit(
clk,
resetn,
iValidInstruction,
iRs,
iRt,
iRd,
iImmediate,
iTargetAddr,
iSFPInstruction, //Single Floating-Point Instruction
iDFPInstruction,
oRt,
oRd,
oRsData,
oRtData,
oImmediate,
oTargetAddr,
oSFPInstruction,
oDFPInstruction
);
input  clk;
input  resetn;
input  iValidInstruction;
input  iRs;
input  iRt;
input  iRd;
input  iImmediate;
input  iTargetAddr;
output oRt;
output oRd;
output oRsData;
output oRtData;
output oImmediate;
output oTargetAddr;

wire                                  iValidInstruction;
wire  [`INTERNAL_REGISTER_WIDTH-1:0]  iRs;
wire  [`INTERNAL_REGISTER_WIDTH-1:0]  iRt;
wire  [`INTERNAL_REGISTER_WIDTH-1:0]  iRd;
wire  [`IMMEDIATE_WIDTH-1:0]          iImmediate;
wire  [`TARGET_ADDR_WIDTH-1:0]        iTargetAddr;
wire                                  iSFPInstruction; 
wire                                  iDFPInstruction;
reg   [`INTERNAL_REGISTER_WIDTH-1:0]  oRt;
reg   [`INTERNAL_REGISTER_WIDTH-1:0]  oRd;

reg   [`REGISTER_DATA_WIDTH-1:0]      grMem[0:`GENERAL_REGISTER_NUM-1];
reg   [`REGISTER_DATA_WIDTH-1:0]      fpMem[0:`FP_REGISTER_NUM-1];

MUX_2Select1 MuxRs (
  .iSel(iSFPInstruction),
  .iZeroBranch(grMem[iRs]),
  .iOneBrach(fpMem[iRs]),
  .oMuxOut(wRsData)
);
MUX_2Select1 MuxRt (
  .iSel(iSFPInstruction),
  .iZeroBranch(grMem[iRt]),
  .iOneBrach(fpMem[iRt]),
  .oMuxOut(wRtData)
);

always @(posedge clk or negedge resetn) begin 
    if (~resetn) begin 
        oRsData <= `DATA_WIDTH'b0;
        oRtData <= `DATA_WIDTH'b0;

    end else begin 
        oRsData <= wRsData;
        oRtData <= wRtData;
    end 
end 

endmodule 
