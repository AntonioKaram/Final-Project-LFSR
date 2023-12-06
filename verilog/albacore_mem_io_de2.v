module albacore_mem_io_de2 (
   input CLOCK_50,
   input  [15:0] SW,
   input  [3:0]  KEY,
   output [15:0] LEDR,
   output [3:0]  LEDG,
   output [6:0]  HEX7,
   output [6:0]  HEX6,
   output [6:0]  HEX5,
   output [6:0]  HEX4,
   output [6:0]  HEX3,
   output [6:0]  HEX2,
   output [6:0]  HEX1,
   output [6:0]  HEX0,
   input         UART_RXD,
   output        UART_TXD,
   output        LCD_ON,
	output        LCD_BLON,
	output        LCD_RW,
	output        LCD_EN,
	output        LCD_RS,
	inout  [7:0]  LCD_DATA
   );
   
   wire [3:0]  button;
   wire [15:0] hex7_hex4;
   wire [15:0] hex3_hex0;
   wire [4:0]  lcd_index;
   wire [7:0]  lcd_char;
   
   albacore_mem_io albacore_mem_io (
      .clk        (CLOCK_50 ),
      .switch     (SW       ),
      .button     (button   ),
      .led_red    (LEDR     ),
      .led_green  (LEDG     ),
      .hex7_hex4  (hex7_hex4),
      .hex3_hex0  (hex3_hex0),
      .lcd_index  (lcd_index),
      .lcd_char   (lcd_char ),
      .rx_serial  (UART_RXD ),
      .tx_serial  (UART_TXD )
   );
   
   debounce debounce_3 (
      .CLOCK_50   (CLOCK_50),
      .in         (~KEY[3]),
      .out        (button[3])
   );
   
   debounce debounce_2 (
      .CLOCK_50   (CLOCK_50),
      .in         (~KEY[2]),
      .out        (button[2])
   );
   
   debounce debounce_1 (
      .CLOCK_50   (CLOCK_50),
      .in         (~KEY[1]),
      .out        (button[1])
   );
   
   debounce debounce_0 (
      .CLOCK_50   (CLOCK_50),
      .in         (~KEY[0]),
      .out        (button[0])
   );
   
   hexdigit hex_7 (
      .in   (hex7_hex4[15:12]),
      .out  (HEX7)
   );
   
   hexdigit hex_6 (
      .in   (hex7_hex4[11:8]),
      .out  (HEX6)
   );
   
   hexdigit hex_5 (
      .in   (hex7_hex4[7:4]),
      .out  (HEX5)
   );
   
   hexdigit hex_4 (
      .in   (hex7_hex4[3:0]),
      .out  (HEX4)
   );
   
   hexdigit hex_3 (
      .in   (hex3_hex0[15:12]),
      .out  (HEX3)
   );
   
   hexdigit hex_2 (
      .in   (hex3_hex0[11:8]),
      .out  (HEX2)
   );
   
   hexdigit hex_1 (
      .in   (hex3_hex0[7:4]),
      .out  (HEX1)
   );
   
   hexdigit hex_0 (
      .in   (hex3_hex0[3:0]),
      .out  (HEX0)
   );
   
   LCD_Controller LCD_Controller_0 (
      .lcd_char   (lcd_char),
      .lcd_index  (lcd_index),
      .CLOCK_50   (CLOCK_50 ),
      .LCD_ON     (LCD_ON   ),	
      .LCD_BLON   (LCD_BLON ),
      .LCD_RW     (LCD_RW   ),	
      .LCD_EN     (LCD_EN   ),	
      .LCD_RS     (LCD_RS   ),	
      .LCD_DATA   (LCD_DATA )	
	);
   
endmodule
