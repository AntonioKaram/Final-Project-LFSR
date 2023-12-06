`timescale 1ns/1ns
module scrambler2_controller_tb();
	reg clk;
	reg start;
	reg i_lt_len_1;
	wire en_i;
	wire s_i;
	wire en_j;
	wire s_r_addr;
	wire en_temp;
	wire s_w_addr;
	wire s_din;
	wire wr_en; // goes to the regfile
	wire busy;
	
	scrambler2_controller uut (
		.clk (clk),
		.start (start),
		.i_lt_len_1 (i_lt_len_1),
		.en_i (en_i),
		.s_i (s_i),
		.en_j (en_j),
		.s_r_addr (s_r_addr),
		.en_temp (en_temp),
		.s_w_addr (s_w_addr),
		.s_din (s_din),
		.wr_en (wr_en), // goes to the regfile
		.busy (busy)
	);
	
	always
		#5 clk = ~clk;
		
	initial begin
		clk = 1;
		start = 0;
		i_lt_len_1 = 1;
		
		#20
		
		start = 1;
		
		#20
		
		start = 0;
		
		#300
		
		i_lt_len_1 = 0;
		
		#100
		
		$stop;
	end
	
endmodule