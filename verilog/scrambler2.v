module scrambler2 (
	input clk,
	input start,
	input [4:0] len_1,
	
	output busy,
	
	// user i/o
	input [4:0] usr_r_addr,
	input [4:0] usr_w_addr,
	input [7:0] usr_din,
	input       usr_wr_en,
	
	output [7:0] dout
	);
	
	// random number generator
	wire [7:0] random;
	
	// internal i/o
	wire [4:0] internal_r_addr;
	wire [4:0] internal_w_addr;
	wire [7:0] internal_din;
	wire       internal_wr_en;
	
	// regfile i/o
	wire [4:0] r_addr;
	wire [4:0] w_addr;
	wire [7:0] din;
	wire       wr_en;
	
	// controller signals
	wire i_lt_len_1;
	wire en_i;
	wire s_i;
	wire en_j;
	wire s_r_addr;
	wire en_temp;
	wire s_w_addr;
	wire s_din;
	
	regfile_router rout (
		.busy (busy),
	
		.usr_r_addr (usr_r_addr),
		.usr_w_addr (usr_w_addr),
		.usr_din    (usr_din),
		.usr_wr_en  (usr_wr_en),
		
		.internal_r_addr (internal_r_addr),
		.internal_w_addr (internal_w_addr),
		.internal_din    (internal_din),
		.internal_wr_en  (internal_wr_en),
		
		.r_addr (r_addr),
		.w_addr (w_addr),
		.din    (din),
		.wr_en  (wr_en)
	);
	
	swap_regfile regfile0 (
		.clk    (clk),
		.r_addr (r_addr),
		.dout   (dout),
		.w_addr (w_addr),
		.din    (din),
		.wr_en  (wr_en)
	);
		
	scrambler2_controller cont (
		.clk        (clk),
		.start      (start),
		.i_lt_len_1 (i_lt_len_1),
		.en_i       (en_i),
		.s_i        (s_i),
		.en_j       (en_j),
		.s_r_addr   (s_r_addr),
		.en_temp    (en_temp),
		.s_w_addr   (s_w_addr),
		.s_din      (s_din),
		.wr_en      (internal_wr_en), // goes to the router
		.busy       (busy)
	);
	
	scrambler2_datapath path (
		.clk (clk),
		
		// outside sources
		.random (random),
		.len_1  (len_1),
		
		// controller
		.en_i       (en_i),
		.s_i        (s_i),
		.en_j       (en_j),
		.s_r_addr   (s_r_addr),
		.en_temp    (en_temp),
		.s_w_addr   (s_w_addr),
		.s_din      (s_din),
		.i_lt_len_1 (i_lt_len_1),
		
		// regfile
		.dout   (dout),
		.r_addr (internal_r_addr),
		.w_addr (internal_w_addr),
		.din    (internal_din)
	);
	
	random_num_generator rand0 (
		.clk    (clk),
		.random (random)
	);
	
endmodule