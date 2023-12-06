module ff_set_clr (
   input       clk,
   input       set,
   input       clr,
   output reg  q
   );
   
   initial q = 1'b0;
   
   always @(posedge clk)
      if (set)
         q <= 1'b1;
      else if (clr)
         q <= 1'b0;

endmodule
