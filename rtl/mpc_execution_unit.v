//Author     : Alex Zhang(cgzhangwei@gmail.com)
//Date       : Jul.13.2014
//Desciption : ALU execution unit
module ExecutionUnit (
clk,
resetn,
iValid,
iA,
iB,
iALUOperation,
oALUOut,
oReady
);
input  clk;
input  resetn;
input  iValid;
input  iA;
input  iB;
input  iALUOperation;
output oALUOut;
output oReady;
wire                     iValid;
wire [`DATA_WIDTH-1:0]   iA;
wire [`DATA_WIDTH-1:0]   iB;
wire [`ALU_OP_WIDTH-1:0] iALUOperation;
reg  [`DATA_WIDTH-1:0]   oALUOut;
reg                      oReady;

//Internal register, can only be accessed with mflo or mchi
reg  [`DATA_WIDTH-1:0]   rLo;
reg  [`DATA_WIDTH-1:0]   rHi;

always @(*) begin 
    case (iALUOperation)
        `ALU_INT_ADD : begin 
                           rIntegerAddValid = 1'b1;
                           rIntegerSubValid = 1'b0;
                           rIntegerMulValid = 1'b0;
                           rIntegerDivValid = 1'b0;
                           rSFP_AddValid    = 1'b0;
                           rSFP_SubValid    = 1'b0;
                           rSFP_MulValid    = 1'b0;
                           rSFP_DivValid    = 1'b0;
                       end 
        `ALU_INT_SUB : begin 
                           rIntegerAddValid = 1'b0;
                           rIntegerSubValid = 1'b1;
                           rIntegerMulValid = 1'b0;
                           rIntegerDivValid = 1'b0;
                           rSFP_AddValid    = 1'b0;
                           rSFP_SubValid    = 1'b0;
                           rSFP_MulValid    = 1'b0;
                           rSFP_DivValid    = 1'b0;
                       end 
        `ALU_INT_MUL : begin 
                           rIntegerAddValid = 1'b0;
                           rIntegerSubValid = 1'b0;
                           rIntegerMulValid = 1'b1;
                           rIntegerDivValid = 1'b0;
                           rSFP_AddValid    = 1'b0;
                           rSFP_SubValid    = 1'b0;
                           rSFP_MulValid    = 1'b0;
                           rSFP_DivValid    = 1'b0;
                       end 
        `ALU_INT_DIV : begin 
                           rIntegerAddValid = 1'b0;
                           rIntegerSubValid = 1'b0;
                           rIntegerMulValid = 1'b0;
                           rIntegerDivValid = 1'b1;
                           rSFP_AddValid    = 1'b0;
                           rSFP_SubValid    = 1'b0;
                           rSFP_MulValid    = 1'b0;
                           rSFP_DivValid    = 1'b0;
                       end 
        `ALU_SFP_ADD : begin 
                           rIntegerAddValid = 1'b0;
                           rIntegerSubValid = 1'b0;
                           rIntegerMulValid = 1'b0;
                           rIntegerDivValid = 1'b0;
                           rSFP_AddValid    = 1'b1;
                           rSFP_SubValid    = 1'b0;
                           rSFP_MulValid    = 1'b0;
                           rSFP_DivValid    = 1'b0;
                       end 
        `ALU_SFP_SUB : begin 
                           rIntegerAddValid = 1'b0;
                           rIntegerSubValid = 1'b0;
                           rIntegerMulValid = 1'b0;
                           rIntegerDivValid = 1'b0;
                           rSFP_AddValid    = 1'b0;
                           rSFP_SubValid    = 1'b1;
                           rSFP_MulValid    = 1'b0;
                           rSFP_DivValid    = 1'b0;
                       end 
        `ALU_SFP_MUL : begin 
                           rIntegerAddValid = 1'b0;
                           rIntegerSubValid = 1'b0;
                           rIntegerMulValid = 1'b0;
                           rIntegerDivValid = 1'b0;
                           rSFP_AddValid    = 1'b0;
                           rSFP_SubValid    = 1'b0;
                           rSFP_MulValid    = 1'b1;
                           rSFP_DivValid    = 1'b0;
                       end 
        `ALU_SFP_DIV : begin 
                           rIntegerAddValid = 1'b0;
                           rIntegerSubValid = 1'b0;
                           rIntegerMulValid = 1'b0;
                           rIntegerDivValid = 1'b0;
                           rSFP_AddValid    = 1'b0;
                           rSFP_SubValid    = 1'b0;
                           rSFP_MulValid    = 1'b0;
                           rSFP_DivValid    = 1'b1;
                       end 
        default      : begin 
                           rIntegerAddValid = 1'b0;
                           rIntegerSubValid = 1'b0;
                           rIntegerMulValid = 1'b0;
                           rIntegerDivValid = 1'b0;
                           rSFP_AddValid    = 1'b0;
                           rSFP_SubValid    = 1'b0;
                           rSFP_MulValid    = 1'b0;
                           rSFP_DivValid    = 1'b0;
                       end 
    endcase 
end 
//Needs 2cycles
IntegerAdd iAdd (
  .clk(clk),
  .resetn(resetn),
  .iValid(rIntegerAddValid),
  .iA(iA),
  .iB(iB),
  .iSign(iSign),
  .oAdd(wIntegerAddOut),
  .oReady(wIntegerAddReady),
  .oOverflow(wIntegerOverflow)
);
//Needs 2cycles
IntegerSub iSub (
  .iValid(rIntegerSubValid),
  .iA(iA),
  .iB(iB),
  .iSign(iSign),
  .oSub(wIntegerSubOut),
  .oReady(wIntegerSubReady),
  .oUnderflow(wIntegerUnderflow)
);
//Needs
IntegerMul iMul (
  .iValid (rIntegerMulValid),
  .iA(iA),
  .iB(iB),
  .iSign(iSign),
  .oMul(wIntegerMulOut),
  .oReady(wIntegerMulReady),
);
IntegerDiv iDiv (
  .iValid(rIntegerDivValid),
  .iA(iA),
  .iB(iB),
  .iSign(iSign),
  .oDiv(wIntegerDivOut),
  .oReady(wIntegerDivReady)
);

SingleFloatingPointAdd sfpAdd (
  .iValid (rSFP_AddValid),
  .iA(iA),
  .iB(iB),
  .oAdd(wSFP_AddOut),
  .oReady(wSFP_AddReady),
);
SingleFloatingPointSub sfpSub (
  .iValid (rSFP_SubValid),
  .iA(iA),
  .iB(iB),
  .oSub(wSFP_SubOut),
  .oReady(wSFP_SubReady),
);
SingleFloatingPointMul sfpMul (
  .iValid (rSFP_MulValid),
  .iA(iA),
  .iB(iB),
  .oMul(wSFP_MulOut),
  .oReady(wSFP_MulReady),
);
SingleFloatingPointDiv sfpDiv (
  .iValid (rSFP_DivValid),
  .iA(iA),
  .iB(iB),
  .oDiv(wSFP_DivOut),
  .oReady(wSFP_DivReady),
);

endmodule 
