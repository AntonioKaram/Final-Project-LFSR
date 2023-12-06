`timescale 1ns/1ns
module mult_tb ();
   reg        clk;
   reg        start;
   reg  [7:0] select;
   reg  [7:0] taps;
   wire [7:0] prod;
   wire       busy;
   
   mult uut (
      .clk   (clk),
      .start (start),
      .select  (select),
      .taps  (taps),
      .prod  (prod),
      .busy  (busy)
   );
   
   always #5 clk = ~clk;
   
   initial begin
//		start = 1;
		clk = 0;
		select = 8'h8; taps = 8'h9;
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
		$stop;
   end

endmodule
