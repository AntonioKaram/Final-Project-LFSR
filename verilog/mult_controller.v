module mult_controller (
		input clk,
		
		// controller inputs
		input start,
		
		// flag inputs
		input i_zero,
		input mask_n_zero,
		
		// controller outputs
		output reg busy_sel,
		output reg busy_en,
		output reg prod_sel,
		output reg prod_en,
		output reg i_sel,
		output reg i_en,
		output reg mask_sel,
		output reg mask_en,
		output reg m_sel,
		output reg m_en,
		output reg n_en
   );
	
	parameter WAIT     = 3'd0;
	parameter INIT     = 3'd1;
	parameter LOOP     = 3'd2;
	parameter ADD_PROD = 3'd3;
	parameter SHIFT    = 3'd4;
	parameter FINISH   = 3'd5;
	
	reg [2:0] state;
	reg [2:0] next_state;
	
	always @(posedge clk)
		state <= next_state;
	
	always @(*) begin
		busy_sel = 0;
		busy_en  = 0;
		prod_sel = 0;
		prod_en  = 0;
		i_sel    = 0;
		i_en     = 0;
		mask_sel = 0;
		mask_en  = 0;
		m_sel    = 0;
		m_en     = 0;
		n_en     = 0;
		
		case (state)
			WAIT: 
			begin
				// busy = 0
				busy_sel = 0;
				busy_en  = 1;
				
				if (start)
					next_state = INIT;
				else
					next_state = WAIT;
			end
			
			INIT:
			begin
				// prod = 0
				prod_sel = 0;
				prod_en  = 1;

				// i = 4
				i_sel = 0;
				i_en  = 1;
				
				// mask = 1
				mask_sel = 0;
				mask_en  = 1;
				
				// m = m_in
				m_sel = 0;
				m_en  = 1;
				
				// n = n_in
				n_en = 1;
				
				// busy = 1
				busy_sel = 1;
				busy_en  = 1;
				
				next_state = LOOP;
			end
			
			LOOP:
			begin
				if (i_zero)
					next_state = FINISH;
				else
					if (mask_n_zero)
						next_state = SHIFT;
					else
						next_state = ADD_PROD;
			end
			
			ADD_PROD:
			begin
				// prod = prod + m
				prod_sel = 1;
				prod_en  = 1;
				
				next_state = SHIFT;
			end
			
			SHIFT:
			begin
				// m = m << 1
				m_sel = 1;
				m_en  = 1;
				
				// mask = mask << 1
				mask_sel = 1;
				mask_en  = 1;
				
				// i = i - 1
				i_sel = 1;
				i_en  = 1;
				
				next_state = LOOP;
			end
			
			FINISH:
			begin
				// busy = 0
				busy_sel = 0;
				busy_en  = 1;
				
				next_state = WAIT;
			end
			
			default:
				next_state = WAIT;
		
		endcase
	end
   
   
endmodule

