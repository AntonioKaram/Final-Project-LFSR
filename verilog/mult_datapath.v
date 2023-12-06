module mult_datapath (
		input clk,

		// data inputs
		input [15:0] m_in,
		input [15:0] n_in,
		
		// data outputs
		output reg [15:0] prod,
		output reg busy,
		
		// control inputs
		input busy_sel,
		input busy_en,
		input prod_sel,
		input prod_en,
		input i_sel,
		input i_en,
		input mask_sel,
		input mask_en,
		input m_sel,
		input m_en,
		input n_en,
		
		// control outputs
		output reg i_zero,
		output reg mask_n_zero
   );
	
	reg [15:0] m;
	reg [15:0] n;
	reg [15:0] mask;
	reg [4:0] i;
	
	initial
		busy = 0;
	
	always @(posedge clk)
		if (busy_en)
			if (busy_sel)
				busy <= 1'b1;
			else
				busy <= 1'b0;
				
	always @(posedge clk)			
		if (prod_en)
			if (prod_sel)
				prod <= prod + m;
			else
				prod <= 16'd0;
				
	always @(posedge clk)			
		if (i_en)
			if (i_sel)
				i <= i - 5'd1;
			else
				i <= 5'd16;
				
	always @(posedge clk)			
		if (mask_en)
			if (mask_sel)
				mask <= mask << 16'd1;
			else
				mask <= 16'd1;
				
	always @(posedge clk)			
		if (m_en)
			if (m_sel)
				m <= m << 16'd1;
			else
				m <= m_in;
				
	always @(posedge clk)			
		if (n_en)
			n <= n_in;
	
	always @(*)
		if (i == 5'd0)
			i_zero = 1'b1;
		else
			i_zero = 1'b0;
	
	always @(*)	
		if ((mask & n) == 0)
			mask_n_zero = 1'b1;
		else
			mask_n_zero = 1'b0;
   
   
endmodule
