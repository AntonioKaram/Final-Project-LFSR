module alu (
   input      [15:0] a,
   input      [15:0] b,
   input      [3:0]  op,
   input      [11:0] inst12,
   input      [15:0] pc,
   output reg [15:0] out,
   output            neg,
   output            zero
   );

   wire [7:0]  imm         = inst12[7:0];
   wire [7:0]  disp        = inst12[11:4];
   wire [3:0]  offset_ld   = inst12[7:4];
   wire [3:0]  offset_st   = inst12[11:8];
   
   assign neg              = b[15];
   assign zero             = b == 0;
   
   always @(*)
      case (op)
         // EX state for arith/logic ops
         0:  out = a + b;                                              // add
         1:  out = a - b;                                              // sub
         2:  out = a & b;                                              // and
         3:  out = a | b;                                              // or
         4:  out = ~a;                                                 // not
         5:  out = a << b;                                             // shl
         6:  out = a >> b;                                             // shr
         7:  out = {8'h0, imm};                                        // ldi
         
         // Address calculations
         // EX state for load/store
         8:  out = b + {12'h0, offset_ld};                             // ld
         9:  out = b + {12'h0, offset_st};                             // st
         
         // PC update calculations
         // WB_ALU, WB_LD, MEM_ST, BR_NOT, EX_JAL
         10: out = pc + 16'h1;                                         // jal, non-branch/jump
         // BR_TAKE
         11: out =  pc + ( disp[7] ? {8'hff, disp} : {8'h00, disp} );  // take branch
         // WB_JAL
         12: out = {pc[15:12], inst12};                                // jump target
         // EX_JR
         13: out = a;                                                  // jr
         default: out = 0;
      endcase
   
endmodule
