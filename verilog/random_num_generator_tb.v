`timescale 1ns/1ns
module random_num_generator_tb();
	reg clk;
	wire [7:0] random;

	random_num_generator uut(
		.clk(clk),
		.random(random)
		);
	
	always #5 clk = ~clk;
   
   initial begin
		clk = 0;
		#100;
		$stop;
	end
	
endmodule
