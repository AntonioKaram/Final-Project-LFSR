module uart_rx (
   input          clk,
   input          rx_serial,
   output [7:0]   rx_byte,
   output         rx_valid
   );
   
   wire en_clk_count;
   wire s_clk_count;
   wire en_bit_index;
   wire s_bit_index;
   wire en_rx_valid;
   wire s_rx_valid;
   wire en_rx_byte;
   wire start_bit;
   wire half_bit_width;
   wire full_bit_width;
   wire last_bit;
   
   wire reset;
   
   uart_reset_delay uart_reset_0 (
      .CLOCK_50   (clk),
      .uart_reset (reset)
   );
   
   uart_rx_datapath uart_rx_datapath (
      .clk            (clk           ),
      .rx_serial      (rx_serial     ),
      .rx_byte        (rx_byte       ),
      .rx_valid       (rx_valid      ),
      .en_clk_count   (en_clk_count  ),
      .s_clk_count    (s_clk_count   ),
      .en_bit_index   (en_bit_index  ),
      .s_bit_index    (s_bit_index   ),
      .en_rx_valid    (en_rx_valid   ),
      .s_rx_valid     (s_rx_valid    ),
      .en_rx_byte     (en_rx_byte    ),
      .start_bit      (start_bit     ),
      .half_bit_width (half_bit_width),
      .full_bit_width (full_bit_width),
      .last_bit       (last_bit      )
   );
   
   uart_rx_fsm uart_rx_fsm (
      .clk            (clk           ),
      .reset          (reset         ),
      .en_clk_count   (en_clk_count  ),
      .s_clk_count    (s_clk_count   ),
      .en_bit_index   (en_bit_index  ),
      .s_bit_index    (s_bit_index   ),
      .en_rx_valid    (en_rx_valid   ),
      .s_rx_valid     (s_rx_valid    ),
      .en_rx_byte     (en_rx_byte    ),
      .start_bit      (start_bit     ),
      .half_bit_width (half_bit_width),
      .full_bit_width (full_bit_width),
      .last_bit       (last_bit      )
   );
   
endmodule
