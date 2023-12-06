module pseudo (
	input         clk,
   input         start,
	input [7:0]   sw_in,
	input [7:0]   seq_num,
	output [7:0]  num,
   output        busy
);
	
	wire busy_en;
	wire busy_s;
	wire i_en;
	wire i_s;
	wire j_en;
	wire j_s;
	wire num_en;
	wire num_s;
	wire tap0_en;
	wire tap0_s;
	wire tap1_en;
	wire tap1_s;
	wire switches_en;
	wire switches_s;
	wire seq_num_en;
	wire seq_num_s;
	
	pseudo_controller controller (
		.clk          (clk),
		.start        (start),
		.busy_en      (busy_en),
		.busy_s       (busy_s),
		.num_en       (num_en),
		.num_s        (num_s),
		.i_en         (i_en),
		.i_s          (i_s),
		.j_en			  (j_en),
		.j_s			  (j_s),
		.tap0_en      (tap0_en),
		.tap0_s       (tap0_s),
		.tap1_en      (tap1_en),
		.tap1_s       (tap1_s),
		.switches_en  (switches_en),
		.switches_s   (switches_s),
		.seq_num_en   (seq_num_en),
		.seq_num_s    (seq_num_s),
		.i_equals_8         (i_equals_8),
		.switches0_equals_1 (switches0_equals_1),
		.j_equals_seq_num   (j_equals_seq_num)
	);
	
	pseudo_datapath datapath (
		.clk                (clk),
		.switches           (sw_in),
		.seq_num            (seq_num),
		.busy_en            (busy_en),
		.busy_s             (busy_s),
		.num_en             (num_en),
		.num_s              (num_s),
		.i_en               (i_en),
		.i_s                (i_s),
		.j_en               (j_en),
		.j_s                (j_s),
		.tap0_en            (tap0_en),
		.tap0_s             (tap0_s),
		.tap1_en            (tap1_en),
		.tap1_s             (tap1_s),
		.switches_en        (switches_en),
		.switches_s         (switches_s),
		.seq_num_en         (seq_num_en),
		.seq_num_s          (seq_num_s),
		.i_equals_8         (i_equals_8),
		.switches0_equals_1 (switches0_equals_1),
		.j_equals_seq_num   (j_equals_seq_num),
		.num                (num),
		.busy               (busy)
	);
	
endmodule

