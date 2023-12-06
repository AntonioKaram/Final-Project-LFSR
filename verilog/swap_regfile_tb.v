`timescale 1ns/1ns
module swap_regfile_tb ();
	reg clk;
	reg [4:0] r_addr;
	reg [4:0] w_addr;
	reg [7:0] din;
	reg wr_en;
	
	wire [7:0] dout;
	
	swap_regfile uut (
		.clk (clk),
		.r_addr (r_addr),
		.w_addr (w_addr),
		.din (din),
		.wr_en (wr_en),
		.dout (dout)
	);
	
	always
		#5 clk = ~clk;
	
	
	initial begin
		clk = 1;
		w_addr = 5'h3;
		din = 8'hab;
		wr_en = 0;
		
		r_addr = 5'h3;
		
		#20
		
		wr_en = 1;
		
		#20
		
		#3
		din = 8'hcd;
		
		#10
		
		wr_en = 0;
		
		#10
		
		din = 5'h00;
		
		#20
		
		$stop;
	
	end
endmodule
