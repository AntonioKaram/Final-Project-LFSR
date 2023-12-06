`timescale 1ns/1ns
module albacore_mem_io_tb ();
   reg         clk;
   reg  [15:0] switch;
   reg  [3:0]  button;
   wire [15:0] led_red;
   wire [7:0]  led_green;
   wire [15:0] hex7_hex4;
   wire [15:0] hex3_hex0;
   reg  [4:0]  lcd_index;
   wire [7:0]  lcd_char;
   reg         rx_serial;
   wire        tx_serial;
   
   parameter IFETCH  = 5'd0;
   parameter IFETCH2 = 5'd1;
   parameter DECODE  = 5'd2;
   parameter EX_ADD  = 5'd3;
   parameter EX_SUB  = 5'd4;
   parameter EX_AND  = 5'd5;
   parameter EX_OR   = 5'd6;
   parameter EX_NOT  = 5'd7;
   parameter EX_SHL  = 5'd8;
   parameter EX_SHR  = 5'd9;
   parameter EX_LDI  = 5'd10;
   parameter EX_LD   = 5'd11;
   parameter EX_ST   = 5'd12;
   parameter EX_BR   = 5'd13;
   parameter EX_BZ   = 5'd14;
   parameter EX_BN   = 5'd15;
   parameter EX_JAL  = 5'd16;
   parameter EX_JR   = 5'd17;
   parameter EX_QUIT = 5'd18;
   parameter MEM_LD  = 5'd19;
   parameter MEM_LD2 = 5'd20;
   parameter MEM_ST  = 5'd21;
   parameter WB_ALU  = 5'd22;
   parameter WB_LD   = 5'd23;
   parameter WB_JAL  = 5'd24;
   parameter BR_TAKE = 5'd25;
   parameter BR_NOT  = 5'd26;
   
   albacore_mem_io uut (
      .clk        (clk      ),
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
   
   // 50 MHz clock --> 20 ns clock cycle
   always #10 clk = ~clk;
   
   initial begin
      clk = 0;
      while (uut.albacore.controller.state != EX_QUIT) 
         #20;
      #20 $stop;
		
   end

endmodule
