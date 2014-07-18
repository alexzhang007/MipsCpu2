//Author     : Alex Zhang(cgzhangwei@gmail.com)
//Date       : Jul.14.2014
//Desciption : Cpu control unit
module ALUOpDecode(
iOperation,
iFunctor,
oALUOperation,
oImmediate,
oSign
);
input  iOperation;
input  iFunctor;
output oALUOperation;
output oImmediate;
output oSign;

wire [`INSTRUCTION_OP_WIDTH-1:0]  iOperation;
wire [`INSTRUCTION_FU_WIDTH-1:0]  iFunctor;
reg  [`ALU_OP_WIDTH-1:0]          oALUOperation;
reg                               oImmediate;
reg                               oSign;

always @(*) begin 
    casex(iOperation) 
        `OP_LW, `OP_SW
               :  begin 
                      oALUOperation  = `ALU_INT_ADD;
                      oImmediate     = 1'b0;
                      oSign          = 1'b1;
                  end 
        `OP_ADDI 
               :  begin 
                      oALUOperation  = `ALU_INT_ADD;
                      oImmediate     = 1'b1;
                      oSign          = 1'b1;
                  end 
        `OP_ADDIU
               :  begin 
                      oALUOperation  = `ALU_INT_ADD;
                      oImmediate     = 1'b1;
                      oSign          = 1'b0;
                  end 
        `OP_BEQ
               :  begin 
                      oALUOperation  = `ALU_INT_SUB;
                      oImmediate     = 1'b0;
                      oSign          = 1'b1;
                  end 
        `OP_RFMT 
                : begin 
                      case (iFunctor) 
                          `FU_ADD  : begin 
                                         oALUOperation  = `ALU_INT_ADD;
                                         oImmediate     = 1'b0;
                                         oSign          = 1'b1;
                                     end 
                          `FU_ADDU : begin 
                                         oALUOperation  = `ALU_INT_ADD;
                                         oImmediate     = 1'b0;
                                         oSign          = 1'b0;
                                     end 
                          `FU_SUB  : begin 
                                         oALUOperation  = `ALU_INT_SUB;
                                         oImmediate     = 1'b0;
                                         oSign          = 1'b1;
                                     end
                          `FU_SUBU : begin 
                                         oALUOperation  = `ALU_INT_SUB;
                                         oImmediate     = 1'b0;
                                         oSign          = 1'b0;
                                     end
                          `FU_AND  : begin 
                                         oALUOperation  = `ALU_INT_AND;
                                         oImmediate     = 1'b0;
                                         oSign          = 1'b0;
                                     end 
                          `FU_SLT  : begin 
                                         oALUOperation  = `ALU_INT_SLT;
                                         oImmediate     = 1'b0;
                                         oSign          = 1'b0;
                                     end 
                          `FU_MULT : begin 
                                         oALUOperation  = `ALU_INT_MUL;
                                         oImmediate     = 1'b0;
                                         oSign          = 1'b1;
                                     end 
                          `FU_MULTU: begin 
                                         oALUOperation  = `ALU_INT_MUL;
                                         oImmediate     = 1'b0;
                                         oSign          = 1'b0;
                                     end 
                          `FU_DIV  : begin 
                                         oALUOperation  = `ALU_INT_DIV;
                                         oImmediate     = 1'b0;
                                         oSign          = 1'b1;
                                     end 
                          `FU_DIVU : begin 
                                         oALUOperation  = `ALU_INT_DIV;
                                         oImmediate     = 1'b0;
                                         oSign          = 1'b0;
                                     end 
                           
                       endcase 
                   end 
        `OP_FLPT 
                :  begin 
                       case (iFunctor)
                           `FU_ADDF : begin 
                                         oALUOperation  = `ALU_SFP_ADD;
                                         oImmediate     = 1'b0;
                                         oSign          = 1'b1;
                                      end 
                           `FU_SUBF : begin 
                                         oALUOperation  = `ALU_SFP_SUB;
                                         oImmediate     = 1'b0;
                                         oSign          = 1'b1;
                                      end 
                           `FU_MULF : begin 
                                         oALUOperation  = `ALU_SFP_MUL;
                                         oImmediate     = 1'b0;
                                         oSign          = 1'b1;
                                      end 
                           `FU_DIVF : begin 
                                         oALUOperation  = `ALU_SFP_DIV;
                                         oImmediate     = 1'b0;
                                         oSign          = 1'b1;
                                      end 
                       endcase 
                   end 
        default  : begin 
                       oALUOperation  = `ALU_SYS_NOP;
                       oImmediate     = 1'b0;
                       oSign          = 1'b0;
                   end 
    endcase 
end 



endmodule 
