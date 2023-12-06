module albacore_mem_io (
   input             clk,
   input      [15:0] switch,
   input      [3:0]  button,
   output     [15:0] led_red,
   output     [7:0]  led_green,
   output     [15:0] hex7_hex4,
   output     [15:0] hex3_hex0,
   input      [4:0]  lcd_index,
   output     [7:0]  lcd_char,
   input             rx_serial,
   output            tx_serial
   );
   
   wire [15:0] addr;
   wire [15:0] proc_din;
   wire [15:0] proc_dout;
   wire        we;
   
   albacore albacore (
      .clk  (clk      ),
      .din  (proc_din ),
      .addr (addr     ),
      .dout (proc_dout),
      .we   (we       )
   );
   
   mem_io mem_io (
      .clk        (clk      ),
      .addr       (addr     ),
      .din        (proc_dout),
      .dout       (proc_din ),
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
   
endmodule
