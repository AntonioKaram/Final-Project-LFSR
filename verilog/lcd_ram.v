module lcd_ram (
   input            clk,
   input      [4:0] lcd_index,
   output reg [7:0] lcd_char,
   input      [7:0] din,
   input      [4:0] waddr,
   input            we
   );
   
   reg [7:0] m [0:31];
   
   integer i;
   initial begin
      for (i = 0;  i < 32;  i = i + 1)
         m[i] = " ";
    end
   
   always @(posedge clk)
      if (we)
         m[waddr] <= din;
         
   always @(posedge clk)
      lcd_char <= m[lcd_index];
 
endmodule
 