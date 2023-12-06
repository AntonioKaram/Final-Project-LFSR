module regfile_router_tb();
	reg busy;
	reg [15:0] usr_r_addr;
	reg [15:0] usr_w_addr;
	reg [7:0] usr_din;
	reg       usr_wr_en;
	reg [4:0] internal_r_addr;
	reg [4:0] internal_w_addr;
	reg [7:0] internal_din;
	reg       internal_wr_en;
	wire [4:0] r_addr;
	wire [4:0] w_addr;
	wire [7:0] din;
	wire       wr_en;
	
	regfile_router uut (
		.busy (busy),
		.usr_r_addr (usr_r_addr[4:0]),
		.usr_w_addr (usr_w_addr[4:0]),
		.usr_din (usr_din),
		.usr_wr_en (usr_wr_en),
		.internal_r_addr (internal_r_addr),
		.internal_w_addr (internal_w_addr),
		.internal_din (internal_din),
		.internal_wr_en (internal_wr_en),
		.r_addr (r_addr),
		.w_addr (w_addr),
		.din (din),
		.wr_en (wr_en)
	
	);
	
	initial begin
		usr_r_addr = 16'hf051;
		usr_w_addr = 16'hf052;
		usr_din    = 8'hff;
		usr_wr_en  = 1;
		
		internal_r_addr = 5'h00;
		internal_w_addr = 5'h00;
		internal_din    = 8'h00;
		internal_wr_en  = 0;
		
		busy = 0;
		
		#10
		
		busy = 1;
		
		#10
		
		busy = 0;
		
		#10
		
		$stop;
	end
endmodule