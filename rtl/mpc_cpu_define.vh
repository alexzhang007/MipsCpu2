//Author     : Alex Zhang(cgzhangwei@gmail.com)
//Date       : Jul.12.2014
//Desciption : Cpu macro defines

`define DATA_WIDTH  32

//mpc_instruction_fetch_unit.v
`define INSTRUCTION_WIDTH  32
`define INSTRUCTION_SIZE   1024
`deifne DATA_WIDTH         32

//mpc_instruction_decode_unit.v
`define INSTRUCTION_OP_WIDTH  6
`define INSTRUCTION_FU_WIDTH  6
`define INTERNAL_REGISTER_WIDTH  5
`define TARGET_ADDR_WIDTH        26
`define IMMEDIATE_WIDTH          16

//mpc_instruction_schedule_unit.v
`define GENERAL_REGISTER_NUM     16
`define FP_REGISTER_NUM          16
`define REGISTER_DATA_WIDTH      32

//mpc_control_unit.v
`define ALU_OP_WIDTH   16

///instruction top 6bits bit[31:26], see figure 3.26
`define OP_RFMT   6'b00_0000
`define OP_BLTZ   6'b00_0001
`define OP_J      6'b00_0010
`define OP_JAL    6'b00_0011
`define OP_BEQ    6'b00_0100
`define OP_BNE    6'b00_0101
`define OP_BLEZ   6'b00_0110
`define OP_BGTZ   6'b00_0111
`define OP_ADDI   6'b00_1000
`define OP_ADDIU  6'b00_1001
`define OP_SLTI   6'b00_1010
`define OP_SLTIU  6'b00_1011
`define OP_ANDI   6'b00_1100
`define OP_ORI    6'b00_1101
`define OP_XORI   6'b00_1110
`define OP_LUI    6'b00_1111
`define OP_TLB    6'b01_0000
`define OP_FLPT   6'b01_0010
`define OP_LB     6'b10_0000
`define OP_LH     6'b10_0001
`define OP_LWL    6'b10_0010
`define OP_LW     6'b10_0011
`define OP_LBU    6'b10_0100
`define OP_LHU    6'b10_0101
`define OP_LWR    6'b10_0110
`define OP_SB     6'b10_1000
`define OP_SH     6'b10_1001
`define OP_SWL    6'b10_1010
`define OP_SW     6'b10_1011
`define OP_SWR    6'b10_1110
`define OP_LWC0   6'b11_0000
`define OP_LWC1   6'b11_0001
`define OP_SWC0   6'b11_1000
`define OP_SWC1   6'b11_1001
 
//op[31:26]=6'b00_0000 R-format , funct[5:0], see figure 2.25
`define FU_SLL    6'b00_0000
`define FU_SRL    6'b00_0010
`define FU_SRA    6'b00_0011
`define FU_SLLV   6'b00_0100
`define FU_SRLV   6'b00_0110
`define FU_SRAV   6'b00_0111
`define FU_JR     6'b00_1000
`define FU_JAL    6'b00_1001
`define FU_CALL   6'b00_0100
`define FU_BRK    6'b00_0101
`define FU_MFHI   6'b01_0000
`define FU_MTHI   6'b01_0001
`define FU_MFLO   6'b01_0010
`define FU_MTLO   6'b01_0011
`define FU_MULT   6'b01_1000
`define FU_MULTU  6'b01_1001
`define FU_DIV    6'b01_1010
`define FU_DIVU   6'b01_1011
`define FU_ADD    6'b10_0000
`define FU_ADDU   6'b10_0001
`define FU_SUB    6'b10_0010
`define FU_SUBU   6'b10_0011
`define FU_AND    6'b10_0100
`define FU_OR     6'b10_0101
`define FU_XOR    6'b10_0110
`define FU_NOR    6'b10_0111
`define FU_SLT    6'b10_1010
`define FU_SLTU   6'b10_1011
//Floating-point functor
`define FU_ADDF   6'b00_0000
`define FU_SUBF   6'b00_0001
`define FU_MULF   6'b00_0010
`define FU_DIVF   6'b00_0011
`define FU_ABSF   6'b00_0101
`define FU_MOVF   6'b00_0110
`define FU_NEGF   6'b00_0111
`define FU_CVTSF  6'b10_0000
`define FU_CVTDF  6'b10_0001
`define FU_CVTWF  6'b10_0100
`define FU_CFF    6'b11_0000
`define FU_CUNF   6'b11_0001
`define FU_CEQF   6'b11_0010
`define FU_CUEQF  6'b11_0011
`define FU_COLTF  6'b11_0100
`define FU_CULTF  6'b11_0101
`define FU_COLEF  6'b11_0110
`define FU_CULEF  6'b11_0111
`define FU_CSFF   6'b11_1000
`define FU_CNGLEF 6'b11_1001
`define FU_CSEQF  6'b11_1010
`define FU_CNGLF  6'b11_1011
`define FU_CLTF   6'b11_1100
`define FU_CNGEF  6'b11_1101
`define FU_CLEF   6'b11_1110
`define FU_CNGTF  6'b11_1111

//mpc_control_unit.v
`define ALU_SYS_NOP   16'h0000
`define ALU_INT_ADD   16'h0001
`define ALU_INT_SUB   16'h0002
`define ALU_INT_MUL   16'h0003
`define ALU_INT_DIV   16'h0004
`define ALU_INT_AND   16'h0005
`defien ALU_INT_SLT   16'h0006
`define ALU_SFP_ADD   16'h1001
`define ALU_SFP_SUB   16'h1002
`define ALU_SFP_MUL   16'h1003
`define ALU_SFP_DIV   16'h1004


//op[25:21] RS field
`define RS_SFP    5'b1_0000 //RS field is single floating-point
`define RS_DFP    5'b1_0001 

