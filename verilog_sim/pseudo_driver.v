module pseudo_driver;

	reg clk;
	wire busy;
	reg start;
	wire [7:0] sw_in;
	wire [7:0] seq_num;
	wire [7:0] num;
	
	// Generate the Stimulus 
	pseudo_stim stim(sw_in, seq_num);
	
	// Test the circuit using the stimulus 
	pseudo p0(clk, start, sw_in, seq_num, num, busy);

	always #5 clk = ~clk;

	initial begin
		start = 1;
		clk = 0;
		#10;
		start = 0;
		#10;
		start = 1;
		#10;
		start = 0;
		#10;
		start = 1;
		#10;
		while (busy)
			#10;
		#10;
		$monitor ("@ time=%d clk=%b, start=%b, sw_in=%b, seq_num=%b, num=%b, busy=%b", $time, clk, start, sw_in, seq_num, num, busy);
		$stop;
   end
endmodule