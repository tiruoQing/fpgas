
module top(
	input	wire		clk_125mhz			,
	input	wire		rst_p				,
	
	input 	wire		vauxp1				,	
	input 	wire		vauxn1				,	
	input 	wire		vauxp6				,	
	input 	wire		vauxn6				,	
	input 	wire		vauxp9				,	
	input 	wire		vauxn9				,	
	input 	wire		vauxp15				,
	input 	wire		vauxn15				,

	input	wire		key					,
	output	wire		led					
);
	
	wire			clk_30mhz					;
	wire			xadc_busy					;
	
	wire	[15:0]	xadc_dout					;
	wire			flag						;
	wire			xadc_drdy					;
	wire			xadc_eoc					;
	wire			xadc_eos					;
	
	
	reg				xadc_en						;
	reg				xadc_wen					;
	reg		[1:0]	cnt							;
	reg		[6:0]	addr						;
	reg		[15:0]	xadc_din	=		16'd0	;
	reg		[16:0]	xadc_data					;
	reg				start						;
	reg		[1:0]	delay						;
	
	
	assign flag 	= (delay == 2'b10) ? 1'b1 : 1'b0;
	// assign xadc_en 	= start							;
	// assign xadc_wen = start							;
	assign led		= key							;
	
	
	always@(posedge clk_30mhz or posedge rst_p) begin
		if(rst_p)
			delay <= 'b0;
		else
			delay <= {delay[0], xadc_busy};
	end
	
	
	always@(posedge clk_30mhz or posedge rst_p) begin
		if(rst_p)
			cnt <= 'd0;
		else if(flag)
			cnt <= cnt + 2'd1;
		else
			cnt <= cnt;
	end
	
	
	always@(posedge clk_30mhz or posedge rst_p) begin
		if(rst_p)
			addr <= 'd17;
		else case(cnt)
			'd0 	: addr <= 'd17;
			'd1 	: addr <= 'd25;
			'd2 	: addr <= 'd22;
			'd3 	: addr <= 'd31;
			default	: addr <= 'd17;
		endcase
	end
	
	always@(posedge clk_30mhz or posedge rst_p) begin
		if(rst_p) begin
			xadc_en <= 1'b0;
			xadc_wen<= 1'b0;
		end
		else begin
			xadc_en <= start;
			xadc_wen<= start;
		end
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
	
	
	
	/*single ADC Test*/
	// // port for xadc
	// xadc_wiz_0 xadc_inst (
		// .di_in		(xadc_din	),	// input wire [15 : 0] di_in
		// .daddr_in	(addr		),	// input wire [6 : 0] daddr_in
		// .den_in		(xadc_en	),	// input wire den_in
		// .dwe_in		(xadc_wen	),	// input wire dwe_in
		// .drdy_out	(xadc_drdy	),	// output wire drdy_out
		// .do_out		(xadc_dout	),	// output wire [15 : 0] do_out
		
		// .dclk_in		(clk_30mhz	),	// input wire dclk_in
		// .reset_in	(rst_p		),	// input wire reset_in
		
		// .vp_in		(			),	// input wire vp_in
		// .vn_in		(			),	// input wire vn_in
		// .vauxp1		(ch1_p		),	// input wire vauxp1
		// .vauxn1		(ch1_n		),	// input wire vauxn1
		
		// .channel_out(			),  // output wire [4 : 0] channel_out
		// .eoc_out		(xadc_eoc	),	// output wire eoc_out
		// .alarm_out	(			),	// output wire alarm_out
		// .eos_out		(			),	// output wire eos_out
		// .busy_out	(xadc_busy	)	// output wire busy_out
	// );
	
	
	/*four adc channels Test*/
	xadc_wiz_0 your_instance_name (
		.di_in		(xadc_din	),              // input wire [15 : 0] di_in
		.daddr_in	(addr	 	),        // input wire [6 : 0] daddr_in
		.den_in		(xadc_en	),            // input wire den_in
		.dwe_in		(xadc_wen	),            // input wire dwe_in
		.drdy_out	(xadc_drdy	),        // output wire drdy_out
		.do_out		(xadc_dout	),            // output wire [15 : 0] do_out
		
		.dclk_in	(clk_30mhz	),          // input wire dclk_in
		.reset_in	(rst_p		),        // input wire reset_in
		
		.vp_in		(			),              // input wire vp_in
		.vn_in		(			),              // input wire vn_in
		.vauxp1		(vauxp1		),            // input wire vauxp1
		.vauxn1		(vauxn1		),            // input wire vauxn1
		.vauxp6		(vauxp6		),            // input wire vauxp6
		.vauxn6		(vauxn6		),            // input wire vauxn6
		.vauxp9		(vauxp9		),            // input wire vauxp9
		.vauxn9		(vauxn9		),            // input wire vauxn9
		.vauxp15	(vauxp15	),          // input wire vauxp15
		.vauxn15	(vauxn15	),          // input wire vauxn15
		.channel_out(			),  // output wire [4 : 0] channel_out
		.eoc_out	(xadc_eoc	),          // output wire eoc_out
		.alarm_out	(			),      // output wire alarm_out
		.eos_out	(xadc_eos	),          // output wire eos_out
		.busy_out	(xadc_busy	)        // output wire busy_out
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
		.probe3	(xadc_eos	), // input wire [0:0]  probe3 
		.probe4	(xadc_eoc	), // input wire [0:0]  probe4 
		.probe5	(xadc_dout	) // input wire [15:0]  probe5
	);



endmodule
