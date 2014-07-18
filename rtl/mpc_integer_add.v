//Author     : Alex Zhang(cgzhangwei@gmail.com)
//Date       : Jul.13.2014
//Desciption : ALU - Integer Add Implementation. The clock is 1ns, the delay of the aoi gate is 100ps. The AND logic is 50ps. 
//             FourAdd logic has 250ps latency. Each cycle just has 2-4 FourAdd. 
//             Adder reference : http://www.aoki.ecei.tohoku.ac.jp/arith/mg/algorithm.html#fsa_pfx
module IntegerAdd (
clk,
resetn,
iValid,
iA,
iB,
iSign,
oAdd,
oReady,
oOverflow
);
input  clk;
input  resetn;
input  iValid;
input  iA;
input  iB;
input  iSign;
output oAdd;
output oReady;
output oOverflow;

wire [`DATA_WIDTH-1:0] iA;
wire [`DATA_WIDTH-1:0] iB;
wire                   iSign;
reg  [`DATA_WIDTH-1:0] oAdd;
reg                    oReady;
reg                    oOverflow;
wire                   wSignA;
wire                   wSignB;


UnsignedIntegerAddSub UIAS (
  .clk(clk),
  .resetn(resetn),
  .iValid(iValid),
  .iA(iA),
  .iB(iB),
  .iSub(1'b0),
  .oAdd(wAdd),
  .oReady(wReady),
  .oOverflow(wOverflow)
);
always @(*) begin 
     oAdd = wAdd;
     oReady = wReady;
     oOverflow = iSign ? 1'b0 : wOverflow; 
end 

endmodule 

module IntegerSub (
clk,
resetn,
iValid,
iA,
iB,
iSign,
oSub,
oReady,
oUnderflow
);
input  clk;
input  resetn;
input  iValid;
input  iA;
input  iB;
input  iSign;
output oSub;
output oReady;
output oUnderflow;

wire [`DATA_WIDTH-1:0] iA;
wire [`DATA_WIDTH-1:0] iB;
wire                   iSign;
reg  [`DATA_WIDTH-1:0] oSub;
reg                    oReady;
reg                    oUnderflow;
wire                   wSignA;
wire                   wSignB;
wire [`DATA_WIDTH-1:0] wA;
wire [`DATA_WIDTH-1:0] wB;
wire                   wSub;
wire [`DATA_WIDTH-1:0] wSubOut;
wire                   pp1Sign;
wire                   pp2Sign;
wire                   wSignA;
wire                   wSignB;

assign wSignA = iA[31];
assign wSignB = iB[31];

always @(*) begin 
    casex ({iSign, wSignA, wSignB})
        3'b100 : begin //iA - iB 
                    wA = iA;
                    wB = iB;
                    wSub = 1'b1;
                end 
        3'b101 : begin //iA- (-iB)
                    wA = iA;
                    wB = ~iB+1;
                    wSub = 1'b0;
                end 
        3'b110 : begin //-iA-iB
                    wA = iA;
                    wB = ~iB+1;
                    wSub = 1'b0;
                end 
        3'b111 : begin  //-iA- (-iB)
                    wA = iA;
                    wB = ~iB +1;
                    wSub = 1'b0;
                end 
        3'b0?? : begin 
                    wA = iA;
                    wB = iB;
                    wSub = 1'b1;
                end 
    endcase 
end 
UnsignedIntegerAddSub UIAS (
  .clk(clk),
  .resetn(resetn),
  .iValid(iValid),
  .iA(wA),
  .iB(wB),
  .iSub(wSub),
  .oAdd(wSubOut),
  .oReady(wReady),
  .oOverflow(wOverflow)
);
FFD_PosedgeAsyncReset #(1) FFD_Delay1 (
  .clk(clk),
  .resetn(resetn),
  .D(iValid&iSign),
  .Q(pp1Sign)
);
FFD_PosedgeAsyncReset #(1) FFD_Delay2 (
  .clk(clk),
  .resetn(resetn),
  .D(pp1Sign),
  .Q(pp2Sign)
);
always @(*) begin 
    oSub = wSubOut;
    oReady = wReady;
    oUnderflow =pp2Sign ? ~wSubOut[31] : wOverflow;
end
endmodule 

//The first cycle, calculate the low 16bits. 
//The second cycle, calculate the high 16bits.
//The third cycle, ouput the result. 
module UnsignIntegerAddSub (
clk,
resetn,
iValid,
iA,
iB,
iSub,
oAdd,
oReady,
oOverflow
);
input  clk;
input  resetn;
input  iValid;
input  iA;
input  iB;
input  iSub;
output oAdd;
output oReady;
output oOverflow;

wire [`DATA_WIDTH-1:0] iA;
wire [`DATA_WIDTH-1:0] iB;
reg  [`DATA_WIDTH-1:0] oAdd;
reg                    oReady;
reg                    oOverflow;

wire [`DATA_WIDTH-1:0] wB;
wire [3:0]             wSum0;
wire [3:0]             wSum1;
wire [3:0]             wSum2;
wire [3:0]             wSum3;
wire [3:0]             wSum4;
wire [3:0]             wSum5;
wire [3:0]             wSum6;
wire [3:0]             wSum7;
wire                   wCout0;
wire                   wCout1;
wire                   wCout2;
wire                   wCout3;
wire                   wCout4;
wire                   wCout5;
wire                   wCout6;
wire                   wCout7;
reg  [3:0 ]            pp1Sum0;
reg  [3:0 ]            pp1Sum1;
reg  [3:0 ]            pp1Sum2;
reg  [3:0 ]            pp1Sum3;
reg                    rCout3;
wire                   wValidDelay1;
wire                   wCin;
FFD_PosedgeAsyncReset #(1) FFD_Delay1 (
  .clk(clk),
  .resetn(resetn),
  .D(iValid),
  .Q(wValidDelay1)
);

assign wCin = iSub ? 1'b1 : 1'b0;
assign wB   = iSub ? ~iB  : iB;

FourBitAdd add0 (.iA(iA[3 :0 ]), .iB(wB[3 :0 ]), iCin(wCin),   oSum(wSum0), oCout(wCout0));
FourBitAdd add1 (.iA(iA[7 :4 ]), .iB(wB[4 :7 ]), iCin(wCout0), oSum(wSum1), oCout(wCout1));
FourBitAdd add2 (.iA(iA[11:8 ]), .iB(wB[11:8 ]), iCin(wCout1), oSum(wSum2), oCout(wCout2));
FourBitAdd add3 (.iA(iA[15:12]), .iB(wB[15:12]), iCin(wCout2), oSum(wSum3), oCout(wCout3));
FourBitAdd add4 (.iA(iA[19:16]), .iB(wB[19:16]), iCin(rCout3), oSum(wSum4), oCout(wCout4));
FourBitAdd add5 (.iA(iA[23:20]), .iB(wB[23:20]), iCin(wCout4), oSum(wSum5), oCout(wCout5));
FourBitAdd add6 (.iA(iA[27:24]), .iB(wB[27:24]), iCin(wCout5), oSum(wSum6), oCout(wCout6));
FourBitAdd add7 (.iA(iA[31:28]), .iB(wB[31:28]), iCin(wCout6), oSum(wSum7), oCout(wCout7));

always @(posedge clk or negedge resetn) begin 
    if (~resetn) begin 
        rCout    <= 1'b0;
        rSum0    <= 4'b0;
        rSum1    <= 4'b0;
        rSum2    <= 4'b0;
        rSum3    <= 4'b0;
        oReady   <= 1'b0;
        oOverflow<= 1'b0;
        oAddr    <= `DATA_WIDTH'b0;
    end else begin 
        rCout3    <= iValid& wCout3;
        pp1Sum0     <= wSum0;
        pp1Sum1     <= wSum1;
        pp1Sum2     <= wSum2;
        pp1Sum3     <= wSum3;
        oOverflow <= wValidDelay1 & wCout7; 
        oAddr     <= {wSum7, wSum6, wSum5, wSum4, pp1Sum3, pp1Sum2, pp1Sum1, pp1Sum0};
        oReady    <= wValidDelay1 ;
    end 
end 
endmodule 

