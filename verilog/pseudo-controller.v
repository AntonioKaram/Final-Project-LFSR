module pseudo_controller (
	input      clk,
	input      start,
	input      i_equals_8,
	input      switches0_equals_1,
	input      j_equals_seq_num,
	output reg busy_en,
	output reg busy_s,
	output reg num_en,
	output reg num_s,
	output reg i_en,
	output reg i_s,
	output reg j_en,
	output reg j_s,
	output reg tap0_en,
	output reg tap0_s,
	output reg tap1_en,
	output reg tap1_s,
	output reg switches_en,
	output reg switches_s,
	output reg seq_num_en,
	output reg seq_num_s
	);
	
	parameter WAIT          = 5'd0;
	parameter INIT          = 5'd1;
	parameter FIND_TAP0     = 5'd2;
	parameter UPDATE_TAP0   = 5'd3;
	parameter FIND_TAP1     = 5'd4;
	parameter UPDATE_TAP1   = 5'd5;
	parameter CALCULATE     = 5'd6;
	parameter FINISH        = 5'd7;
	
	reg [2:0] state = WAIT;
	reg [2:0] next_state;
	
	always @(posedge clk)
		state <= next_state;
		
	always @(*) begin
		busy_en     = 0;
		busy_s      = 0;
		i_en        = 0;
		i_s         = 0;
		j_en        = 0;
		j_s         = 0;
		num_en      = 0;
		num_s       = 0;
		tap0_en     = 0;
		tap0_s      = 0;
		tap1_en     = 0;
		tap1_s      = 0;
		switches_en = 0;
		switches_s  = 0;
		seq_num_en  = 0;
		seq_num_s   = 0;
		
		case (state)
	
			WAIT:	begin
				busy_en = 1;
				if (start)
					next_state = INIT;
				else
					next_state = WAIT;
			end
			
			INIT:	begin
				busy_en     = 1;
				i_en        = 1;
				j_en        = 1;
				num_en      = 1;
				tap0_en     = 1;
				tap1_en     = 1;
				switches_en = 1;
				seq_num_en  = 1;
				busy_s      = 1;
				next_state  = FIND_TAP0;
			end
			
			FIND_TAP0: begin
				i_en        = 1;
				i_s         = 1;
				switches_en = 1;
				switches_s  = 1;
				if (i_equals_8)
					next_state = CALCULATE;
				else if (switches0_equals_1)
					next_state = UPDATE_TAP0;
				else
					next_state = FIND_TAP0;
			end
			
			UPDATE_TAP0: begin
				tap0_en = 1;
				tap0_s  = 1;
				next_state = FIND_TAP1;
			end
			
			FIND_TAP1: begin
				i_en        = 1;
				i_s         = 1;
				switches_en = 1;
				switches_s  = 1;
				if (i_equals_8)
					next_state = CALCULATE;
				else if (switches0_equals_1)
					next_state = UPDATE_TAP1;
				else
					next_state = FIND_TAP1;
			end
			
			UPDATE_TAP1: begin
				tap1_en = 1;
				tap1_s  = 1;
				next_state = CALCULATE;
			end
			
			CALCULATE: begin
				j_en        = 1;
				j_s         = 1;
				num_en      = 1;
				num_s       = 1;
				if (j_equals_seq_num)
					next_state = FINISH;
				else
					next_state = CALCULATE;
			end
			
			FINISH: begin
				busy_en    = 1;
				next_state = WAIT;
			end
			
			default:
				next_state = WAIT;
				
		endcase
	end
	
endmodule
