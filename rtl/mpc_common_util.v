//Author     : Alex Zhang(cgzhangwei@gmail.com)
//Date       : Jul.12.2014
//Desciption : common module used in the MiPsCpu
module FFD_PosedgeAsyncReset#(parameter DW=`DATA_WIDTH) (
clk,
resetn,
D,
Q
);
input  clk;
input  resetn;
input  D;
output Q;
wire [DW-1:0] D;
reg  [DW-1:0] Q;

always @(posedge clk or negedge resetn) begin 
    if (~resetn) begin 
        Q <= {DW{1'b0}};
    end else begin 
        Q <= D;
    end 

end 

endmodule 
module MUX_2Select1 #(parameter DW=`DATA_WIDTH) (
iSel,
iZeroBrach,
iOneBranch,
oMuxOut
);
input  iSel;
input  iZeroBranch;
input  iOneBranch;
output oMuxOut;
wire [DW-1:0] iZeroBranch;
wire [DW-1:0] iOneBranch;
reg  [DW-1:0] oMuxOut;

always  @(*) begin 
     case (iSel) 
         1'b0:   oMuxOut = iZeroBranch;
         1'b1:   oMuxOut = iOneBrach;
         default:oMuxOut = iZeroBranch;
     endcase
end 

endmodule 

///Carry look ahead adder 
module FourBitAdd(
iA,
iB,
iCin,
oSum,
oCout
);
input  iA;
input  iB;
input  iCin;
output oSum;
output  oCout;
wire [3:0]  iA;
wire [3:0]  iB;
wire        iCin;
reg  [3:0]  oSum;
reg         oCout;

wire [3:0]  p,g,c;

assign p[0] = iA[0] | iB[0];
assign p[1] = iA[1] | iB[1];
assign p[2] = iA[2] | iB[2];
assign p[3] = iA[3] | iB[3];

assign g[0] = iA[0] & iB[0];
assign g[1] = iA[1] & iB[1];
assign g[2] = iA[2] & iB[2];
assign g[3] = iA[3] & iB[3];

assign c[0] = g[0] | (p[0] & iCin );
assign c[1] = g[1] | (p[1] & g[0] ) | (p[1] & p[0] & iCin);
assign c[2] = g[2] | (p[2] & g[1] ) | (p[2] & p[1] & g[0]) | (p[2] & p[1] & p[0] & iCin);
assign c[3] = g[3] | (p[3] & g[2] ) | (p[3] & p[2] & g[1]) | (p[3] & p[2] & p[1] & g[0]) | (p[3] & p[2] & p[1] & p[0] &iCin);

always @(*) begin 
    oSum[0] = iA[0] ^iB[0] ^iCin;
    oSum[1] = iA[1] ^iB[1] ^c[0];
    oSum[2] = iA[2] ^iB[2] ^c[1];
    oSum[3] = iA[3] ^iB[3] ^c[2];
    oCout   = c[3];
end 
//The longest datapath oCout; 
//AND logic needs 50ps. There are about 5 stages. so FourAdder needs 250ps to get the results. 
//To make sure the setup and holdon time, one cycles only has two FourAdder is OK. 

endmodule 

module OneBitAdd (
iA,
iB,
iCin,
oZ,
oCout
);
input iA;
input iB;
input iCin;
output oZ;
output oCout;
reg oZ;
reg oCout;
always @(iA or iB or iCin) begin 
    oZ    = ~iCin & (iA^iB) | iCin & ~(iA^iB);  
    oCout =  iCin & (iA^iB) | iA^iB ;
end 
//This longest critical path is the oMul, can be reduced to ~100ps when using 
//optimized technology.

endmodule 



module OneBitMul (
iA,
iB,
iCRin,
iCTin,
oCout,
oMul
);
input iA;
input iB;
input iCRin;
input iCTin;
output oCout;
output oMul;

wire p;
reg  oCout;
reg  oMul;

assign p = iA & iB;
always @(*) begin 
    oMul = (p &(iA&iB | ~iA&~iB)) |  (~p&(iA&~iB|~iA&iB));
    oCout= (p&iA | p&iB);
end 
//This longest critical path is the oMul, can be reduced to ~100ps when using 
//optimized technology.

endmodule

module FourBitMul (
iA,
iB,
oMul
);
input iA;
input iB;
output oMul;

wire [3:0] iA;
wire [3:0] iB;
reg  [7:0] oMul;
wire [7:0] wZ;

wire wCout00,wCout01,wCout02,wCout03;
wire wZ01,wZ02,wZ03;
wire wCout10,wCout11,wCout12,wCout13;
wire wZ11,wZ12,wZ13;
wire wCout20,wCout21,wCout22;
//First row
OneBitAdd HA  (.iA(1'b0),        .iB(iA[0]&iB[0]), .oZ(wZ[0]), .oCout(),        .iCin(1'b0));
OneBitAdd HA00(.iA(iA[1]&iB[0]), .iB(iA[0]&iB[1]), .oZ(wZ[1]), .oCout(wCout00)  .iCin(1'b0));
OneBitAdd FA01(.iA(iA[2]&iB[0]), .iB(iA[1]&iB[1]), .oZ(wZ01),  .oCout(wCout01), .iCin(wCout00));
OneBitAdd FA02(.iA(iA[3]&iB[0]), .iB(iA[2]&iB[1]), .oZ(wZ02),  .oCout(wCout02), .iCin(wCout01));
OneBitAdd HA03(.iA(wCout02),     .iB(iA[3]&iB[1]), .oZ(wZ03),  .oCout(wCout03), .iCin(1'b0));
//Second row
OneBitAdd HA10(.iA(wZ01),        .iB(iA[0]&iB[2]), .oZ(wZ[2]), .oCout(wCout10), .iCin(1'b0));
OneBitAdd FA11(.iA(wZ02),        .iB(iA[1]&iB[2]), .oZ(wZ11),  .oCout(wCout11), .iCin(wCout10));
OneBitAdd FA12(.iA(wZ03),        .iB(iA[2]&iB[2]), .oZ(wZ12),  .oCout(wCout12), .iCin(wCout11));
OneBitAdd FA13(.iA(wCout03),     .iB(iA[3]&iB[2]), .oZ(wZ13),  .oCout(wCout13), .iCin(wCout12));
//Third row
OneBitAdd HA20(.iA(wZ11),        .iB(iA[0]&iB[3]), .oZ(wZ[3]), .oCout(wCout20),  iCin(1'b0));
OneBitAdd FA21(.iA(wZ12),        .iB(iA[1]&iB[3]), .oZ(wZ[4]), .oCout(wCout21), .iCin(wCout20));
OneBitAdd FA22(.iA(wZ13),        .iB(iA[2]&iB[3]), .oZ(wZ[5]), .oCout(wCout22), .iCin(wCout21));
OneBitAdd FA23(.iA(wCout13),     .iB(iA[3]&iB[3]), .oZ(wZ[6]), .oCout(wZ[7]),   .iCin(wCout22));

//The longest path is the first row + FA13 + FA23 = 4*100ps+100ps+100ps= 600ps
//With some optimization, it will be reduced under 500ps. 

always @(*) begin
        oMul <= wZ;
end
endmodule 

module EightBitMul (
iA,
iB,
oMul
);
input iA;
input iB;
output oMul;

wire [7:0]  iA;
wire [7:0]  iB;
reg  [15:0] oMul;
wire [7:0]  wZ00;
wire [7:0]  wZ01;
wire [7:0]  wZ10;
wire [7:0]  wZ11;

FourBitMul FBM_00 (.iA(iA[3:0]), iB(iB(3:0)), .oMul(wZ00));
FourBitMul FBM_10 (.iA(iA[7:4]), iB(iB(3:0)), .oMul(wZ10));
FourBitMul FBM_01 (.iA(iA[3:0]), iB(iB(7:4)), .oMul(wZ01));
FourBitMul FBM_11 (.iA(iA[7:4]), iB(iB(7:4)), .oMul(wZ11));



endmodule 

