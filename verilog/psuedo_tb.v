`timescale 1ns/1ns
module pseudo_tb ();
   reg        clk;
   reg        start;
   reg  [7:0] sw_in;
   reg  [7:0] seq_num;
   wire [7:0] num;
   wire       busy;

   
   pseudo uut (
      .clk      (clk),
      .start    (start),
      .sw_in    (sw_in),
      .seq_num  (seq_num),
      .num      (num),
      .busy     (busy)
   );
   
   always #5 clk = ~clk;
   
   initial begin
//		start = 1;
		clk = 0;
		sw_in = 8'h8; seq_num = 8'h9;
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
