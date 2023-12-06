`timescale 1ns/1ns
module mem_io_tb ();
	reg             clk;
   reg      [15:0] addr;
   reg      [15:0] din;
   reg             we;
   reg      [15:0] switch;
   reg      [3:0]  button;
   reg      [4:0]  lcd_index;
   reg             rx_serial;
	
	wire 		[15:0] dout;
	wire     [15:0] led_red;
   wire     [7:0]  led_green;
   wire     [15:0] hex7_hex4;
   wire     [15:0] hex3_hex0;
	wire     [7:0]  lcd_char;
	wire            tx_serial;
	
	
	
	mem_io uut (
      .clk        (clk      ),
      .addr       (addr     ),
      .din        (din		 ),
      .dout       (dout	    ),
      .we         (we       ),
      .switch     (switch   ),
      .button     (button   ),
      .led_red    (led_red  ),
      .led_green  (led_green), 
      .hex7_hex4  (hex7_hex4),
      .hex3_hex0  (hex3_hex0),
      .lcd_index  (lcd_index),
      .lcd_char   (lcd_char ),
      .rx_serial  (rx_serial),
      .tx_serial  (tx_serial)
	);
	
	always #10 clk = ~clk;
   
   initial begin
      clk = 0; addr = 0; we = 1; din = 16'hffff;
		
      #50; addr = 16'hf060;
		#50; addr = 16'hf070; 	
		#50; addr = 16'hf071; 
		
		#50; addr = 16'hf063; 
		#50; addr = 16'hf072; 
				
      #50 $stop;
		
   end
	
   
endmodule
