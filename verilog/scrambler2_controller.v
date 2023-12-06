module scrambler2_controller(
	input clk,
	input start,
	input i_lt_len_1,
	
	output reg en_i,
	output reg s_i,
	
	output reg en_j,
	
	output reg s_r_addr,
	
	output reg en_temp,
	
	output reg s_w_addr,
	
	output reg s_din,
	output reg wr_en, // goes to the regfile
	
	output reg busy
	);
	
	parameter WAIT  = 2'h0;
	parameter READ  = 2'h1;
	parameter SWAP  = 2'h2;
	parameter WRITE = 2'h3;
	
	reg [1:0] state;
	reg [1:0] next;
	
	initial begin
		state = WAIT;
		next  = WAIT;
	end
	
	always @(*) begin
		en_i     = 0;
		s_i      = 0;
		en_j     = 0;
		s_r_addr = 0;
		en_temp  = 0;
		s_w_addr = 0;
		s_din    = 0;
		wr_en    = 0;
		busy     = 1; // busy by default, not busy in WAIT
		
		case (state)
			WAIT: begin
				// busy <- 0
				busy = 0;
				
				// i <- 0
				en_i = 1;
				s_i  = 0;
				
				if (start)
					next = READ;
				else
					next = WAIT;
			end
			
			READ: begin
				// j <- random % len - 1
				en_j = 1;
				
				// r_addr <- i
				s_r_addr = 0;
				
				// temp <- dout
				en_temp = 1;
				
				if (i_lt_len_1)
					next = SWAP;
				else
					next = WAIT;
			end
			
			SWAP: begin
				// w_addr <- i
				s_w_addr = 0;
				
				// r_addr <- j
				s_r_addr = 1;
				
				// din <- dout
				s_din = 1;
				wr_en = 1;
				
				next = WRITE;
			end
			
			WRITE: begin
				// w_addr <- j
				s_w_addr = 1;
				
				// din <- temp
				s_din = 0;
				wr_en = 1;
				
				// i <- i + 1
				en_i = 1;
				s_i  = 1;
				
				next = READ;
			end
			
			default: next = WAIT;
		endcase
	end
	
	always @(posedge clk)
			state <= next;
	
endmodule