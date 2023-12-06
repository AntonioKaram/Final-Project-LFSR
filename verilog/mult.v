module mult (
   input         clk,
   input         start,
   input  [15:0]  m_in,
   input  [15:0]  n_in,
   output [15:0]  prod,
   output        busy
   );
	
	// control signals
	wire busy_sel;
	wire busy_en;
	wire prod_sel;
	wire prod_en;
	wire i_sel;
	wire i_en;
	wire mask_sel;
	wire mask_en;
	wire m_sel;
	wire m_en;
	wire n_en;
	
	// controller flags
	wire i_zero;
	wire mask_n_zero;
	
	mult_datapath path (
		.clk (clk),

		// data inputs
		.m_in (m_in),
		.n_in (n_in),
		
		// data outputs
		.prod (prod),
		.busy (busy),
		
		// control inputs
		.busy_sel (busy_sel),
		.busy_en  (busy_en),
		.prod_sel (prod_sel),
		.prod_en  (prod_en),
		.i_sel    (i_sel),
		.i_en     (i_en),
		.mask_sel (mask_sel),
		.mask_en  (mask_en),
		.m_sel    (m_sel),
		.m_en     (m_en),
		.n_en     (n_en),
		
		// control outputs
		.i_zero (i_zero),
		.mask_n_zero (mask_n_zero)
	);
	
	mult_controller cont (
		.clk (clk),
		
		// controller inputs
		.start (start),
		
		// flag inputs
		.i_zero      (i_zero),
		.mask_n_zero (mask_n_zero),
		
		// controller outputs
		.busy_sel (busy_sel),
		.busy_en  (busy_en),
		.prod_sel (prod_sel),
		.prod_en  (prod_en),
		.i_sel    (i_sel),
		.i_en     (i_en),
		.mask_sel (mask_sel),
		.mask_en  (mask_en),
		.m_sel    (m_sel),
		.m_en     (m_en),
		.n_en     (n_en)
	);
	
endmodule
