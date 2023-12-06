module uart_tx_datapath (
   input             clk,
   input      [7:0]  tx_byte,
   output reg        tx_serial,
   output reg        tx_done,
   output reg        tx_active,
   input             en_tx_serial,
   input      [1:0]  s_tx_serial,
   input             en_clk_count,
   input             s_clk_count,
   input             en_bit_index,
   input             s_bit_index,
   input             en_tx_done,
   input             s_tx_done,
   input             en_tx_active,
   input             s_tx_active,
   output            full_bit_width,
   output            last_bit
   );
   
   parameter CLKS_PER_BIT = 5208;
//   parameter CLKS_PER_BIT = 217;  // testbench
   
   reg [12:0]  clk_count;
   reg [2:0]   bit_index;
   
   assign full_bit_width   = clk_count == CLKS_PER_BIT-1;
   assign last_bit         = bit_index == 7;
   
//   output reg        tx_serial,
//   output reg        tx_done,
//   output reg        tx_active,

   always @(posedge clk)
      if (en_tx_serial)
         case (s_tx_serial)
            0: tx_serial = 1'b0;
            1: tx_serial = 1'b1;
            2: tx_serial = tx_byte[bit_index];
            default: tx_serial = 1'b0;
         endcase
   
   always @(posedge clk)
      if (en_tx_done)
         tx_done <= s_tx_done;
      
   always @(posedge clk)
      if (en_tx_active)
         tx_active <= s_tx_active;
   
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
   
endmodule
