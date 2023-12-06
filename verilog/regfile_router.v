module regfile_router(
	input busy,
	
	input [4:0] usr_r_addr,
	input [4:0] usr_w_addr,
	input [7:0]  usr_din,
	input        usr_wr_en,
	
	input [4:0]  internal_r_addr,
	input [4:0]  internal_w_addr,
	input [7:0]  internal_din,
	input        internal_wr_en,
	
	output reg [4:0] r_addr,
	output reg [4:0] w_addr,
	output reg [7:0] din,
	output reg       wr_en
	);
	
	always @(*) begin
		if (busy) begin
			r_addr = internal_r_addr;
			w_addr = internal_w_addr;
			din    = internal_din;
			wr_en  = internal_wr_en;
		end else begin
			r_addr = usr_r_addr + 5'b10000;
			w_addr = usr_w_addr + 5'b10000;
			din    = usr_din;
			wr_en  = usr_wr_en;
		end
	end
endmodule