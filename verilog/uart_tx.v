module uart_tx (
   input       clk,
   input       tx_start,
   input [7:0] tx_byte,
   output      tx_serial,
   output      tx_done,
   output      tx_active
   );
   
   wire        en_tx_serial;
   wire [1:0]  s_tx_serial;
   wire        en_clk_count;
   wire        s_clk_count;
   wire        en_bit_index;
   wire        s_bit_index;
   wire        en_tx_done;
   wire        s_tx_done;
   wire        en_tx_active;
   wire        s_tx_active;
   wire        full_bit_width;
   wire        last_bit;
   
   uart_tx_datapath datapath (
      .clk              (clk           ),
      .tx_byte          (tx_byte       ),
      .tx_serial        (tx_serial     ),
      .tx_done          (tx_done       ),
      .tx_active        (tx_active     ),
      .en_tx_serial     (en_tx_serial  ),
      .s_tx_serial      (s_tx_serial   ),
      .en_clk_count     (en_clk_count  ),
      .s_clk_count      (s_clk_count   ),
      .en_bit_index     (en_bit_index  ),
      .s_bit_index      (s_bit_index   ),
      .en_tx_done       (en_tx_done    ),
      .s_tx_done        (s_tx_done     ),
      .en_tx_active     (en_tx_active  ),
      .s_tx_active      (s_tx_active   ),
      .full_bit_width   (full_bit_width),
      .last_bit         (last_bit      )
   );
   
   uart_tx_fsm fsm (
      .clk              (clk           ),
      .tx_start         (tx_start      ),
      .en_tx_serial     (en_tx_serial  ),
      .s_tx_serial      (s_tx_serial   ),
      .en_clk_count     (en_clk_count  ),
      .s_clk_count      (s_clk_count   ),
      .en_bit_index     (en_bit_index  ),
      .s_bit_index      (s_bit_index   ),
      .en_tx_done       (en_tx_done    ),
      .s_tx_done        (s_tx_done     ),
      .en_tx_active     (en_tx_active  ),
      .s_tx_active      (s_tx_active   ),
      .full_bit_width   (full_bit_width),
      .last_bit         (last_bit      )
   );
   
endmodule
