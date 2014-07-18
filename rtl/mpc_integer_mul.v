//Author     : Alex Zhang(cgzhangwei@gmail.com)
//Date       : Jul.13.2014
//Desciption : ALU - Integer Mul Implementation
module UnsignIntegerMul (
clk,
resetn,
iValid,
iA,
iB,
oMul,
oOverflow,
oReady
);
input  clk;
input  resetn;
input  iValid;
input  iA;
input  iB;
output oMul;
output oOverflow;
output oReady;

wire iValid;
wire [`DATA_WIDTH-1:0]    iA;
wire [`DATA_WIDTH-1:0]    iB;
reg  [`DATA_WIDTH*2-1:0]  oMul;
reg                       oOverflow;
reg                       oReady;





endmodule 
