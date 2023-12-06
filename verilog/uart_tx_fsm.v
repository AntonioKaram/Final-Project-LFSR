module uart_tx_fsm (
   input            clk,
   input            tx_start,
   output reg       en_tx_serial,
   output reg [1:0] s_tx_serial,
   output reg       en_clk_count,
   output reg       s_clk_count,
   output reg       en_bit_index,
   output reg       s_bit_index,
   output reg       en_tx_done,
   output reg       s_tx_done,
   output reg       en_tx_active,
   output reg       s_tx_active,
   input            full_bit_width,
   input            last_bit
   );
   
   parameter IDLE          = 3'd0;
   parameter TX_START_BIT  = 3'd1;
   parameter WAIT_DATA_BIT = 3'd2;
   parameter TX_DATA_BIT   = 3'd3;
   parameter WAIT_STOP_BIT = 3'd4;
   parameter TX_STOP_BIT   = 3'd5;
   parameter CLEANUP       = 3'd6;
   
   reg [2:0] state = 3'd0;
   reg [2:0] next_state;
   
   always @(posedge clk)
      state <= next_state;
      
   always @(*) begin
      en_tx_serial   = 0;
      s_tx_serial    = 0;
      en_clk_count   = 0;
      s_clk_count    = 0;
      en_bit_index   = 0;
      s_bit_index    = 0;
      en_tx_done     = 0;
      s_tx_done      = 0;
      en_tx_active   = 0;
      s_tx_active    = 0;
      
      case (state)
         IDLE: begin
            en_tx_serial = 1;
            s_tx_serial = 1;
            en_tx_done = 1;
            en_tx_active = 1;
            en_clk_count = 1;
            en_bit_index = 1;
            if (tx_start)
               next_state = TX_START_BIT;
            else
               next_state = IDLE;
         end
         TX_START_BIT: begin
            en_tx_serial = 1;
            en_tx_active = 1;
            s_tx_active = 1;
            en_clk_count = 1;
            en_bit_index = 1;
            next_state = WAIT_DATA_BIT;
         end
         WAIT_DATA_BIT: begin
            en_clk_count = 1;
            s_clk_count = 1;
            if (full_bit_width)
               next_state = TX_DATA_BIT;
            else 
               next_state = WAIT_DATA_BIT;
         end
         TX_DATA_BIT: begin
            en_tx_serial = 1;
            s_tx_serial = 2;
            en_bit_index = 1;
            s_bit_index = 1;
            en_clk_count = 1; 
            if (last_bit)
               next_state = WAIT_STOP_BIT;
            else
               next_state = WAIT_DATA_BIT;       
         end  
         WAIT_STOP_BIT: begin
            en_clk_count = 1;
            s_clk_count = 1;
            if (full_bit_width)
               next_state = TX_STOP_BIT;
            else 
               next_state = WAIT_STOP_BIT;
         end
         TX_STOP_BIT: begin
            en_tx_serial = 1;
            s_tx_serial = 1;
            en_tx_done = 1;
            s_tx_done = 1;
            en_clk_count = 1;
            en_tx_active = 1;
            next_state = CLEANUP;
         end
         CLEANUP: begin
            en_tx_done = 1;
            s_tx_done = 1;
            next_state = IDLE;
         end
         default: next_state = IDLE;
      endcase
   end
endmodule
