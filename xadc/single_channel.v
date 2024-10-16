
module top(
	input	wire		clk_125mhz			,
	input	wire		rst_p				,
	
	input	wire		ch1_p				,
	input	wire		ch1_n				,
	input	wire		key					,
	output	wire		led					
);
	
	wire			clk_30mhz					;
	wire			xadc_busy					;
	wire			xadc_en						;
	wire			xadc_wen					;
	wire	[15:0]	xadc_dout					;
	wire			flag						;
	wire			xadc_drdy					;
	wire			xadc_eoc					;
	
	
	reg		[6:0]	addr		=		7'd17	;
	reg		[15:0]	xadc_din	=		16'd17	;
	reg		[16:0]	xadc_data					;
	reg				start						;
	reg		[1:0]	delay						;
	
	
	assign flag 	= (delay == 2'b01) ? 1'b1 : 1'b0;
	assign xadc_en 	= start							;
	assign xadc_wen = start							;
	assign led		= key							;
	
	
	always@(posedge clk_30mhz or posedge rst_p) begin
		if(rst_p)
			delay <= 'b0;
		else
			delay <= {delay[0], xadc_eoc};
	end
	
	
	always@(posedge clk_30mhz or posedge rst_p) begin
		if(rst_p)
			start <= 1'b0;
		else if(flag)
			start <= 1'b1;
		else
			start <= 1'b0;
	end
	
	always@(posedge clk_30mhz or posedge rst_p) begin
		if(rst_p)
			xadc_data <= 'd0;
		else if(xadc_eoc)
			xadc_data <= xadc_dout;
		else
			xadc_data <= xadc_data;
	end
	
	
	
	
	// port for xadc
	xadc_wiz_0 xadc_inst (
		.di_in		(xadc_din	),	// input wire [15 : 0] di_in
		.daddr_in	(addr		),	// input wire [6 : 0] daddr_in
		.den_in		(xadc_en	),	// input wire den_in
		.dwe_in		(xadc_wen	),	// input wire dwe_in
		.drdy_out	(xadc_drdy	),	// output wire drdy_out
		.do_out		(xadc_dout	),	// output wire [15 : 0] do_out
		
		.dclk_in	(clk_30mhz	),	// input wire dclk_in
		.reset_in	(rst_p		),	// input wire reset_in
		
		.vp_in		(			),	// input wire vp_in
		.vn_in		(			),	// input wire vn_in
		.vauxp1		(ch1_p		),	// input wire vauxp1
		.vauxn1		(ch1_n		),	// input wire vauxn1
		
		.channel_out(			),  // output wire [4 : 0] channel_out
		.eoc_out	(xadc_eoc	),	// output wire eoc_out
		.alarm_out	(			),	// output wire alarm_out
		.eos_out	(			),	// output wire eos_out
		.busy_out	(xadc_busy	)	// output wire busy_out
	);

	
	clk_0 clk_inst(
		.clk_out1	(clk_30mhz	),
		.reset		(rst_p		),
		.clk_in1	(clk_125mhz	)
	);
	
	
	
	ila_0 ila_inst (
		.clk	(clk_30mhz), // input wire clk

		.probe0	(xadc_busy	), // input wire [0:0]  probe0  
		.probe1	(xadc_en	), // input wire [0:0]  probe1 
		.probe2	(xadc_drdy	), // input wire [0:0]  probe2 
		.probe3	(key		), // input wire [0:0]  probe3 
		.probe4	(xadc_eoc	), // input wire [0:0]  probe4 
		.probe5	(xadc_dout	) // input wire [15:0]  probe5
	);



endmodule
