module uart_rx_fsm (
   input       clk,
   input       reset,
   output reg  en_clk_count,
   output reg  s_clk_count,
   output reg  en_bit_index,
   output reg  s_bit_index,
   output reg  en_rx_valid,
   output reg  s_rx_valid,
   output reg  en_rx_byte,
   input       start_bit,
   input       half_bit_width,
   input       full_bit_width,
   input       last_bit
   );
   
   parameter IDLE             = 0;
   parameter WAIT_START_BIT   = 1;
   parameter RX_START_BIT     = 2;
   parameter WAIT_DATA_BIT    = 3;
   parameter RX_DATA_BIT      = 4;
   parameter WAIT_STOP_BIT    = 5;
   parameter RX_STOP_BIT      = 6;
   parameter CLEANUP          = 7;
   
   reg [2:0] state = 0;
   reg [2:0] next_state;
   
   always @(posedge clk)
      if (reset)
         state <= IDLE;
      else
         state <= next_state;
      
   always @(*) begin
      en_clk_count   = 0;
      s_clk_count    = 0;
      en_bit_index   = 0;
      s_bit_index    = 0;
      en_rx_valid    = 0;
      s_rx_valid     = 0;
      en_rx_byte     = 0;
      case (state)
         IDLE: begin
            en_rx_valid = 1;
            s_rx_valid = 0;
            en_clk_count = 1;
            s_clk_count = 0;
            en_bit_index = 1;
            s_bit_index = 0;
            if (start_bit)
               next_state = WAIT_START_BIT;
            else next_state = IDLE;
         end
         WAIT_START_BIT: begin
            en_clk_count = 1;
            s_clk_count = 1;
            if (half_bit_width)
               next_state = RX_START_BIT;
            else
               next_state = WAIT_START_BIT;
         end
         RX_START_BIT: begin
            en_clk_count = 1;
            s_clk_count = 0;
            if (start_bit)
               next_state = WAIT_DATA_BIT;
            else
               next_state = IDLE;
         end
         WAIT_DATA_BIT: begin
            en_clk_count = 1;
            s_clk_count = 1;
            if (full_bit_width)
               next_state = RX_DATA_BIT;
            else 
               next_state = WAIT_DATA_BIT;
         end
         RX_DATA_BIT: begin
            en_rx_byte = 1;
            en_bit_index = 1;
            s_bit_index = 1;
            en_clk_count = 1;
            s_clk_count = 0;
            if (last_bit)
               next_state = WAIT_STOP_BIT;
            else
               next_state = WAIT_DATA_BIT;
         end
         WAIT_STOP_BIT: begin
            en_clk_count = 1;
            s_clk_count = 1;
            if (full_bit_width)
               next_state = RX_STOP_BIT;
            else 
               next_state = WAIT_STOP_BIT;
         end
         RX_STOP_BIT: begin
            en_rx_valid = 1;
            s_rx_valid = 1;
            next_state = CLEANUP;
         end
         CLEANUP: begin
            en_rx_valid = 1;
            s_rx_valid = 0;
            next_state = IDLE;
         end
         default: next_state = IDLE;
      endcase
   end

endmodule
