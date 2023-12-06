module mem_io (
   input             clk,
   input      [15:0] addr,
   input      [15:0] din,
   output reg [15:0] dout,
   input             we,
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
   
//   Memory Map
//   led:
//   f000: write:  led_red_en
//   f001: write:  led_green_en
///
//   hex:
//   f002: write:  hex3_hex0_en
//   f003: write:  hex7_hex4_en
//
//   switches and buttons:
//   f004: read:   switch
//   f005: read:   button
//
//   rx:
//   f006  read:   rx_valid
//   f007  write:  rx_valid_clr
//   f008  read:   rx_byte
//
//   tx: 
//   f009: write:  tx_byte_en
//   f00a: write:  tx_start
//   f00b: read:   tx_active
//
//   LCD:
//   f02?-f03?: write: lcd_ram_we
//
//   Multiplier:
//   f040: write:  m_in
//   f041: write:  n_in
//   f042: read:   prod
//   f043: write:  start
//   f044: read:   busy
   
   reg         ram_we;
   reg         tx_start;
   reg         rx_valid_clr;
   reg         tx_byte_en;
   reg         hex7_hex4_en;
   reg         hex3_hex0_en;
   reg         led_red_en;
   reg         led_green_en;
   reg         lcd_ram_we;
   
   wire [15:0] ram_dout;
   wire        rx_valid_p;
   wire        rx_valid;
   wire [7:0]  rx_byte;
   wire [7:0]  tx_byte;
   wire        tx_done;
   wire        tx_active;
	
	// Multiplier
	reg         mult_start;
	reg         mult_m_en;
	reg         mult_n_en;
	
	wire [15:0] mult_m_in;
	wire [15:0] mult_n_in;
	
	wire [15:0] mult_prod;
	wire        mult_busy;
	
	// Scrambler2
	reg        scram_start;
	reg        scram_len_1_en;
	reg        scram_we;
	
	wire [7:0] scram_len_1;
	wire       scram_busy;
	wire [7:0] scram_dout;
	
   
   // store demux: demux we from processor to enables of writables
   // uart_tx
   always @(*) begin
      ram_we         = 0;
      tx_byte_en     = 0;
      tx_start       = 0;
      rx_valid_clr   = 0;
      hex7_hex4_en   = 0;
      hex3_hex0_en   = 0;
      lcd_ram_we     = 0;
      led_red_en     = 0;
      led_green_en   = 0;
		
	   mult_start     = 0;
	   mult_m_en      = 0;
	   mult_n_en      = 0;
		
		scram_start    = 0;
		scram_len_1_en = 0;
		scram_we       = 0;
      
      // store demux: route we to output devices
      casez (addr)
         16'hf000: led_red_en     = we;
         16'hf001: led_green_en   = we;
         16'hf002: hex3_hex0_en   = we;
         16'hf003: hex7_hex4_en   = we;
         16'hf007: rx_valid_clr   = we;
         16'hf009: tx_byte_en     = we;
         16'hf00a: tx_start       = we;
         16'hf02?,
         16'hf03?: lcd_ram_we     = we;
			
			16'hf040: mult_m_en      = we;
			16'hf041: mult_n_en      = we;
			16'hf043: mult_start     = we;
			
			16'hf05?,
			16'hf06?: scram_we       = we;
			16'hf070: scram_len_1_en = we;
			16'hf071: scram_start    = we;
         default:  ram_we         = we;
      endcase
   end
   
   // load mux: route input devices to mem_io dout (processor din)
   always @(*)
      casez (addr)
         16'hf004: dout = switch;
         16'hf005: dout = {12'b0, button};
         16'hf006: dout = {15'b0, rx_valid};
         16'hf008: dout = {8'b0,  rx_byte};
         16'hf00b: dout = {15'b0, tx_active};
			16'hf042: dout = mult_prod;
			16'hf044: dout = {15'b0, mult_busy};
			16'hf05?,
			16'hf06?: dout = {8'b0,  scram_dout};
			16'hf072: dout = {15'b0, scram_busy};
         default:  dout = ram_dout;
      endcase
		
	
   
   // RAM
   ram ram_0 (
      .clk  (clk),
      .addr (addr),
      .din  (din),
      .we   (ram_we),
      .dout (ram_dout)
   );
   
   // I/O devices
   // LEDs
   reg16 led_red_reg (
      .clk  (clk),
      .en   (led_red_en),
      .d    (din),
      .q    (led_red)
   );
   
   reg8 led_green_reg (
      .clk  (clk),
      .en   (led_green_en),
      .d    (din),
      .q    (led_green)
   );
   
   // Hex Displays
   reg16 hex3_hex0_reg (
      .clk  (clk),
      .en   (hex3_hex0_en),
      .d    (din),
      .q    (hex3_hex0)
   );
   
   reg16 hex7_hex4_reg (
      .clk  (clk),
      .en   (hex7_hex4_en),
      .d    (din),
      .q    (hex7_hex4)
   );
   
   // UART
   uart_rx uart_rx_0 (
      .clk        (clk),
      .rx_serial  (rx_serial),
      .rx_byte    (rx_byte),
      .rx_valid   (rx_valid_p)
   );
   
   ff_set_clr rx_valid_buf (
      .clk  (clk),
      .set  (rx_valid_p),
      .clr  (rx_valid_clr),
      .q    (rx_valid)
   );
   
   uart_tx uart_tx_0 (
      .clk        (clk),
      .tx_start   (tx_start),
      .tx_byte    (tx_byte),
      .tx_serial  (tx_serial),
      .tx_done    (tx_done),
      .tx_active  (tx_active)
   );
   
   reg8 tx_byte_buf (
      .clk  (clk       ),
      .en   (tx_byte_en),
      .d    (din[7:0]  ),
      .q    (tx_byte   )
   );
   
   // LCD
   lcd_ram lcd_ram_0 (
      .clk        (clk       ),
      .lcd_index  (lcd_index ),
      .lcd_char   (lcd_char  ),
      .din        (din[7:0]  ),
      .waddr      (addr[4:0] ),
      .we         (lcd_ram_we)
   );
	
	// Multiplier	
	reg16 mult_m (
		.clk  (clk      ),
      .en   (mult_m_en),
      .d    (din      ),
      .q    (mult_m_in)
	);
	
	reg16 mult_n (
		.clk  (clk      ),
      .en   (mult_n_en),
      .d    (din      ),
      .q    (mult_n_in)
	);
	
	mult hardware_mult (
		.clk    (clk       ),
		.start  (mult_start),
		.m_in   (mult_m_in ),
		.n_in   (mult_n_in ),
		.prod   (mult_prod ),
		.busy   (mult_busy )
	);
	
	// Scrambler2
	scrambler2 scram (
		.clk        (clk             ),
		.start      (scram_start     ),
		.len_1      (scram_len_1[4:0]),
		.busy       (scram_busy      ),
		.usr_r_addr (addr[4:0]       ),
		.usr_w_addr (addr[4:0]       ),
		.usr_din    (din[7:0]        ), 
		.usr_wr_en  (scram_we        ),
		.dout       (scram_dout      )
	);
	
	reg8 scram_len_1_reg (
		.clk (clk           ),
		.en  (scram_len_1_en),
		.d   (din[7:0]      ),
		.q   (scram_len_1   )
	);	
   
endmodule
