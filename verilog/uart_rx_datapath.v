module uart_rx_datapath (
   input             clk,
   input             rx_serial,
   output reg [7:0]  rx_byte,
   output reg        rx_valid,
   input             en_clk_count,
   input             s_clk_count,
   input             en_bit_index,
   input             s_bit_index,
   input             en_rx_valid,
   input             s_rx_valid,
   input             en_rx_byte,
   output            start_bit,
   output            half_bit_width,
   output            full_bit_width,
   output            last_bit
   );
   
   parameter CLKS_PER_BIT = 5208;
//   parameter CLKS_PER_BIT = 217; // testbench
   
   reg         rx_serial_buf;
   reg [12:0]  clk_count;
   reg [2:0]   bit_index;
   
   always @(posedge clk)
      rx_serial_buf <= rx_serial;
   
   always @(posedge clk)
   if (en_clk_count)
      if (s_clk_count)
         clk_count <= clk_count + 13'd1;
      else
         clk_count <= 0;
      
   always @(posedge clk)
   if (en_bit_index)
      if (s_bit_index)
         bit_index <= bit_index + 3'd1;
      else
         bit_index <= 0;
         
   always @(posedge clk)
      if (en_rx_valid)
         rx_valid <= s_rx_valid;
   
   always @(posedge clk)
      if (en_rx_byte)
         rx_byte[bit_index] <= rx_serial_buf;

   assign start_bit        = rx_serial_buf == 0;
   assign half_bit_width   = clk_count == (CLKS_PER_BIT-1)/2;
   assign full_bit_width   = clk_count == CLKS_PER_BIT-1;
   assign last_bit         = bit_index == 7;
   
endmodule
   