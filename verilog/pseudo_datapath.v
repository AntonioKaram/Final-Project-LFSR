module pseudo_datapath (
	input clk,
	input [7:0] switches,
	input [7:0] seq_num,
	input busy_en,
	input busy_s,
	input i_en,
	input i_s,
	input j_en,
	input j_s,
	input num_en,
	input num_s,
	input tap0_en,
	input tap0_s,
	input tap1_en,
	input tap1_s,
	input switches_en,
	input switches_s,
	input seq_num_en,
	input seq_num_s,
	output i_equals_8,
	output switches0_equals_1,
	output j_equals_seq_num,
	output reg [7:0] num,
	output reg busy
   );
   
	initial busy = 0;
	
	reg [3:0] i          = -1;
	reg [7:0] j          = 0;
	reg [3:0] tap0 = 0;
	reg [3:0] tap1 = 1;
	reg [7:0] switch_shift;
	
//initial switch_shift = switches;
	
	always @ (posedge clk)
		if (switches_en)
			if (~switches_s)
				switch_shift <= switches;
			else
				switch_shift <= switch_shift >> 1;

	
	always @ (posedge clk)
		if (busy_en)
			if (~busy_s)
				busy <= 0;
			else
				busy <= 1;
				
	always @(posedge clk)
		if (i_en)
			if (~i_s)
				i <= -1;
			else
				i <= i + 1;
				
	always @(posedge clk)
		if (j_en)
			if (~j_s)
				j <= 0;
			else
				j <= j + 1;
				
	always @(posedge clk)
		if (tap0_en)
			if (~tap0_s)
				tap0 <= 1;
			else
				tap0 <=i;
				
	always @(posedge clk)
		if (tap1_en)
			if (~tap1_s)
				tap1 <= 0;
			else
				tap1 <=i;
				
	always @(posedge clk)
		if (num_en)
			if (~num_s)
				num <= 1;
			else
				num <= {num[6:0], num[tap0] ^ num[tap1]};
				
	assign i_equals_8 = (i == 8);
	assign switches0_equals_1 = (switch_shift[0] == 1);
	assign j_equals_seq_num = (j == seq_num);
	
endmodule
