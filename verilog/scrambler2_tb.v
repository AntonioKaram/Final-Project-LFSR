`timescale 1ns/1ns
module scrambler2_tb();
	reg        clk;
	reg        start;
	reg [4:0]  len_1;
	reg [15:0] usr_r_addr;
	reg [15:0] usr_w_addr;
	reg [7:0]  usr_din;
	reg        usr_wr_en;
	wire       busy;
	wire [7:0] dout;
	
	scrambler2 uut (
		.clk        (clk),
		.start      (start),
		.len_1      (len_1),
		.usr_r_addr (usr_r_addr),
		.usr_w_addr (usr_w_addr),
		.usr_din    (usr_din),
		.usr_wr_en  (usr_wr_en),
		.busy       (busy),
		.dout       (dout)
	);
	
	always
		#5 clk = ~clk;
	
	integer i;
	initial begin
		clk = 0;
		start = 0;
		len_1 = 5'd9;
		
		usr_wr_en  = 0;
		usr_r_addr = 5'h0;
		
		#21
		
		usr_wr_en = 1;
		
		#19
		
		for (i = 0; i < 10; i = i + 1) begin
			usr_w_addr = 16'hf050 + i;
			usr_din    = i + 1;
			#30;
		end
		
		usr_wr_en = 0;
		
		$stop;
		
		start = 1;
		
		#20
		
		start = 0;
		
		#50;
		
		while (busy)
			#20;
			
		#30;
		
		$stop;
		
		
	end
endmodule