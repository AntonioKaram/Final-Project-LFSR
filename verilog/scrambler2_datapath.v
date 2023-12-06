module scrambler2_datapath(
	input clk,
	
	// outside sources
	input [7:0] random,
	input [4:0] len_1,
	
	// controller
	input en_i,
	input s_i,
	
	input en_j,
	
	input s_r_addr,
	
	input en_temp,
	
	input s_w_addr,
	
	input s_din,
	
	output i_lt_len_1,
	
	// regfile
	input [7:0] dout,
	
	output reg [4:0] r_addr,
	output reg [4:0] w_addr,
	output reg [7:0] din
   );
	
	reg [4:0] i;
	reg [4:0] j;
	
	reg [7:0] temp;
	
	// i
	always @(posedge clk)
		if (en_i)
			if (s_i)
				i <= i + 1'b1;
			else
				i <= 0;
	
	// j
	wire [7:0] rand_addr;
	assign rand_addr = (random % (len_1 + 1'b1 - i)) + i;
	
	always @(posedge clk)
		if (en_j)
			j <= rand_addr[4:0];
			
	// r_addr
	always @(*)
		if (s_r_addr)
			r_addr <= j;
		else
			r_addr <= i;
			
	// temp
	always @(posedge clk)
		if (en_temp)
			temp <= dout;
			
	// w_addr
	always @(*)
		if (s_w_addr)
			w_addr <= j;
		else
			w_addr <= i;
			
	// din
	always @(*)
		if (s_din)
			din <= dout;
		else
			din <= temp;
			
	// flags
	assign i_lt_len_1 = (i < len_1);
			
endmodule