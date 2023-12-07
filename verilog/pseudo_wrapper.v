module pseudo_wrapper #(
    parameter BITS = 32
) (
`ifdef USE_POWER_PINS
    inout vdd,		// User area 5.0V supply
    inout vss,		// User area ground
`endif

    // Wishbone Slave ports (WB MI A)
    input wb_clk_i,
    input wb_rst_i,

    // Independent clock (on independent integer divider)
    input   user_clock2,

);

	pseudo mprj(

		/* Connect the vdd and vss to the risc module */
		`ifdef USE_POWER_PINS
			.vdd(vdd),	// User area 1 1.8V power
			.vss(vss),	// User area 1 digital ground
		`endif
		
		/* Inputs for wire and reset */
		.wb_clk_i(wb_clk_i),
		.wb_rst_i(wb_rst_i),
		
		// IO Pads
		.io_in ({io_in[20:5]}),
		.io_out({io_out[29:21]}),
		.io_oeb({io_out[29:21]}),

	);
endmodule	// pseudo

`default_nettype wire
