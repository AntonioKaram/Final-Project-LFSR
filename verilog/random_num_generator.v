module random_num_generator(
	input        clk,
	output [7:0] random
	);
	
	reg [15:0] full_random;
	
	wire [15:0] new_bit = ((full_random >> 0) ^ (full_random >> 2) ^ (full_random >> 3) ^ (full_random >> 5));
   
	always @(posedge clk)
		full_random <= (full_random >> 1) | (new_bit[0] << 15);
		
	assign random = full_random[7:0];
		
	initial begin
		// full_random = 16'hCAFE; // mem_test result: 4-3-2-1
		// full_random = 16'h1234; // mem_test result: 4-3-2-1
		// full_random = 16'hE7A7; // mem_test result: 2-1-4-3
		// full_random = 16'hABCD; // mem_test result: 4-2-1-3
		// full_random = 16'hEEEE; // mem_test result: 3-1-4-2
		full_random = 16'hDEAD; // mem_test result: 2-4-1-3
	end
	
endmodule