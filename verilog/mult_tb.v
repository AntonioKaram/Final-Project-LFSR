`timescale 1ns/1ns
module mult_tb ();
   reg        clk;
   reg        start;
   reg  [15:0] m_in;
   reg  [15:0] n_in;
   wire [15:0] prod;
   wire       busy;
   
   mult uut (
      .clk   (clk),
      .start (start),
      .m_in  (m_in),
      .n_in  (n_in),
      .prod  (prod),
      .busy  (busy)
   );
   
   always #5 clk = ~clk;
   
   initial begin
		clk = 0;
		m_in = 16'hab;
		n_in = 16'hcd;
		
		start = 0;
		#10;
		start = 1;
		#30;
		start = 0;
		
		while (busy)
			#10;
			
		#10;
		
		$stop;
   end

endmodule
