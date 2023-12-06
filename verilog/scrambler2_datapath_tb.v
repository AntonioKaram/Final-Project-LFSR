`timescale 1ns/1ns
module scrambler2_datapath_tb();
	reg clk;
	reg [7:0] random;
	reg [4:0] len_1;
	reg en_i;
	reg s_i;
	reg en_j;
	reg s_r_addr;
	reg en_temp;
	reg s_w_addr;
	reg s_din;
	wire i_lt_len_1;
	reg [7:0] dout;
	wire [4:0] r_addr;
	wire [4:0] w_addr;
	wire [7:0] din;
	
	scrambler2_datapath uut(
		.clk 	  	     (clk),
		.random 	     (random),
		.len_1	     (len_1),
		.en_i   	     (en_i),
		.s_i		     (s_i),
		.en_j			  (en_j),
		.s_r_addr     (s_r_addr),
		.en_temp      (en_temp),
		.s_w_addr     (s_w_addr),
		.s_din	     (s_din),
		.i_lt_len_1   (i_lt_len_1),
		.dout		     (dout),
		.r_addr	     (r_addr),
		.w_addr	     (w_addr),
		.din	        (din)
	);
	
	always
		#5 clk = ~clk;
		
	initial begin
		clk = 1; dout = 8'haa; random = 5'b10110; len_1 = 10; 
		en_i = 0; s_i = 0; en_j = 0; s_r_addr = 0; en_temp = 0;
		s_w_addr = 0; s_din = 0; 

		
		#10; en_i = 1; s_i = 0;
		#10; en_i = 1; s_i = 1; 	
		#50; en_i = 0;
		#100; en_j = 1;
		#50;  en_j = 0;
		#50; s_r_addr = 1; 
		#50; s_r_addr = 0;
		#50; en_temp = 1;
		#50; en_temp = 0;
		#50; s_w_addr = 1;
		#50; s_w_addr = 0;
		#50; s_din = 1;
		#50; s_din = 0;
		#50; $stop;
	
	end
	
endmodule
