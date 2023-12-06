module swap_regfile(
	input clk,
	input [4:0] r_addr,
	output [7:0] dout,
	
	input [4:0] w_addr,
	input [7:0] din,
	input wr_en
	);
	
	reg [7:0] msg [0:31];
	
	always @(posedge clk)
		if (wr_en)
			msg[w_addr] = din;
			
	assign dout = msg[r_addr];
	
	integer i;
	initial begin
		for (i = 0; i < 32; i = i + 1)
			msg[i] = 8'h0;
	end

endmodule