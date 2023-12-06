module uart_reset_delay (
   input       CLOCK_50,
   output reg  uart_reset
   );
   
   reg [19:0] count = 0;
   
   always @(posedge CLOCK_50)
      if (count != 20'hfffff) begin
         count <= count + 20'd1;
         uart_reset <= 1'b1;
      end
      else begin
         uart_reset <= 1'b0;
      end
      
endmodule
