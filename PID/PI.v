

/*
	模块运行时钟频率为500KHz
	只需要做输出电压单环控制
	此处不需要将adc数据转换为真实值
	直接使用adc值进行pi调整
	
	使用增量式pid进行调整
	
	vo输入范围为0-4095, 典型值为d3430
*/

module pid(
	input	wire					clk_50mhz	,
	input	wire					clk			, // 50Khz
	input	wire					rstp		,
	
	input	wire					key_add		,
	input	wire					key_sub		,
	
	
	input	wire	signed	[12:0]	vo			,
	
	output	wire			[11:0]	w_freq_cnt	
);
	

	
	localparam			CNT_MAX = 12'd625		; // 输出限幅 80k - 120k
	localparam			CNT_MIN = 12'd416		;
	localparam			DEFAULT_CNT = 12'd520	; // 默认为96K
	
	// parameter			kp	=	0.1				;
	// parameter			ki	=	0.01			;
	
	
	reg	signed	[12:0]	error					;
	reg	signed	[12:0]	error_last				;
	reg	signed	[12:0]	error_deta				;
	
	reg	signed	[11:0]	cnt_freq				;
	reg	signed	[11:0]	cnt_freq_last			;
	reg	signed	[11:0]	cnt_freq_deta			;
	
	reg	signed	[12:0]	error_cal				;
	reg	signed	[12:0]	error_deta_cal			;
	
	
	
	reg	signed	[12:0]	VO_GOAL				;
	
	wire				flag_add			;
	wire				flag_sub			;
	reg			[1:0]	delay_add			;
	reg			[1:0]	delay_sub			;
	
	
	assign flag_add = (delay_add == 2'b01) ? 1'b1 : 1'b0;
	assign flag_sub = (delay_sub == 2'b01) ? 1'b1 : 1'b0;
	
	
	always@(posedge clk or posedge rstp) begin
		if(rstp)
			delay_add <= 'd0;
		else
			delay_add <= {delay_add[0], key_add};
	end
	
	always@(posedge clk or posedge rstp) begin
		if(rstp)
			delay_sub <= 'd0;
		else
			delay_sub <= {delay_sub[0], key_sub};
	end
	
	
	always@(posedge clk or posedge rstp) begin
		if(rstp)
			VO_GOAL <= 13'd3430;
		else if(VO_GOAL >= 'd4000)
			VO_GOAL <= 'd4000;
		else if(flag_add)
			VO_GOAL <= VO_GOAL + 'd5;
		else if(flag_sub)
			VO_GOAL <= VO_GOAL - 'd5;
		else
			VO_GOAL <= VO_GOAL;
	end
	
	
	
	assign	w_freq_cnt = cnt_freq;
	
	
	always@(posedge clk  or posedge rstp) begin
		if(rstp)
			error <= 'd0;
		else
			error <= VO_GOAL - vo;
	end
	
	
	always@(posedge clk or posedge rstp) begin
		if(rstp)
			error_last <= 'd0;
		else
			error_last <= error;
	end
	
	
	always@(posedge clk or posedge rstp) begin
		if(rstp)
			error_deta <= 'd0;
		else
			error_deta <= error - error_last;
	end
	
	
	always@(posedge clk or posedge rstp) begin
		if(rstp)
			cnt_freq_last <= DEFAULT_CNT;
		else
			cnt_freq_last <= cnt_freq;
	end
	
	/*********************************************************************************/
	always@(posedge clk or negedge rstp) begin
		if(rstp)
			error_cal <= 'd0;
		else
			error_cal <= (error >>> 3);
	end
	
	always@(posedge clk or negedge rstp) begin
		if(rstp)
			error_deta_cal <= 'd0;
		else
			error_deta_cal <= (error_deta >>> 1);
	end
	/********************************************************************************/
	
	always@(posedge clk or posedge rstp) begin
		if(rstp)
			cnt_freq_deta <= 'd0;
		else
			// cnt_freq_deta <= (error_deta >>> 3) - (error >>> 2);
			// cnt_freq_deta <= error >>> 3;
			// cnt_freq_deta <= error_deta;
			cnt_freq_deta <= error_cal + error_deta_cal;
	end
	

// 对比1, 被限幅
	always@(posedge clk or posedge rstp) begin
		if(rstp)
			cnt_freq <= DEFAULT_CNT;
		else if(cnt_freq >= CNT_MAX)
			cnt_freq <= CNT_MAX;
		else if(cnt_freq <= CNT_MIN)
			cnt_freq <= CNT_MIN;
		else
			cnt_freq <= cnt_freq_last + cnt_freq_deta;
	end
	

// 对比2, 正常工作
	always@(posedge clk or posedge rstp) begin
		if(rstp)
			cnt_freq <= DEFAULT_CNT;
		else if(cnt_freq_last + cnt_freq_deta >= CNT_MAX)
			cnt_freq <= CNT_MAX;
		else if(cnt_freq_last + cnt_freq_deta <= CNT_MIN)
			cnt_freq <= CNT_MIN;
		else
			cnt_freq <= cnt_freq_last + cnt_freq_deta;
	end
	


	ila_1 ila_pid (
		.clk(clk_50mhz			), // input wire clk

		.probe0(VO_GOAL[11:0]	), // input wire [12:0]  probe0  
		.probe1(error			), // input wire [12:0]  probe1 
		.probe2(error_deta		), // input wire [12:0]  probe2 
		.probe3(cnt_freq_last	), // input wire [11:0]  probe3 
		.probe4(cnt_freq_deta	), // input wire [11:0]  probe4 
		.probe5(error_cal		), // input wire [12:0]  probe5 
		.probe6(error_deta_cal	) // input wire [12:0]  probe6
	);
	
	
endmodule




	// reg		[11:0]	error_1					; // e(t-1)
	// reg		[11:0]	error					; // e(t)
	// reg		[11:0]	r_cal1					; // e(t) - e(t-1)
	
	
	// reg 	[11:0]	cnt_freq				;
	// reg 	[11:0]	cnt_freq_last			;
	

	
	// assign	w_freq_cnt = cnt_freq;
	
	
	
	// reg	casebit1;
	// reg	casebit0;
	
	// always@(posedge clk or posedge rstp) begin
		// if(rstp)
			// casebit1 <= 1'b0;
		// else if(vo >= VO_GOAL)
			// casebit1 <= 1'b1;
		// else
			// casebit1 <= 1'b0;
	// end
	
	// always@(posedge clk or posedge rstp) begin
		// if(rstp)
			// casebit0 <= 1'b0;
		// else if(error > error_1)
			// casebit0 <= 1'b1;
		// else
			// casebit0 <= 1'b0;
	// end
	
	
	// always@(posedge clk or posedge rstp) begin
		// if(rstp)
			// error <= 'd0;
		// else
			// error <= (vo >= VO_GOAL) ? (vo - VO_GOAL) : (VO_GOAL - vo);
	// end
	
	
	// always@(posedge clk or posedge rstp) begin
		// if(rstp)
			// error_1 <= 'd0;
		// else
			// error_1 <= error;
	// end
	
	
	// always@(posedge clk or posedge rstp) begin
		// if(rstp)
			// r_cal1 <= 'd0;
		// else
			// r_cal1 <= (error > error_1) ? (error - error_1) : (error_1 - error);
	// end
	
	
	
	
	
	// always@(posedge clk or posedge rstp) begin
		// if(rstp)
			// cnt_freq <= DEFAULT_CNT; // 默认为96K
		// else if(cnt_freq >= CNT_MAX)
			// cnt_freq <= CNT_MAX;
		// else if(cnt_freq <= CNT_MIN)
			// cnt_freq <= CNT_MIN;
			
		// // else case({vo > VO_GOAL, error > error_1}) // VO_GOAL - vo,  error - error_1
		
		
		// // assign casebit1 = (vo > VO_GOAL) ? 1'b1 : 1'b0;
		// // assign casebit0 = (error > error_1) ? 1'b1 : 1'b0;
		
		// else case({casebit1, casebit0})
			// // 当输出电压小于期望电压, 则需要增大输出电压, 需要提升电压增益, 需要减小频率,则需要增大计数器
				// // 当前的误差比之前的误差小, 此方向正确
			// 2'b00  : cnt_freq <= cnt_freq_last + {5'd0,error[11:5]} + ({1'd0,r_cal1[11:1]});
			// 2'b01  : cnt_freq <= cnt_freq_last + {5'd0,error[11:5]} - ({1'd0,r_cal1[11:1]});
			// 2'b10  : cnt_freq <= cnt_freq_last - {5'd0,error[11:5]} + ({1'd0,r_cal1[11:1]});
			// 2'b11  : cnt_freq <= cnt_freq_last - {5'd0,error[11:5]} - ({1'd0,r_cal1[11:1]});
			// // 当输出电压大于期望电压, 则需要减小输出电压,需要将电压增益减小,则需要增大频率, 则需要减小计数器,
			// default: cnt_freq <= cnt_freq;
		// endcase
	// end
	
	
	// always@(posedge clk or posedge rstp) begin
		// if(rstp)
			// cnt_freq_last <= DEFAULT_CNT;
		// else
			// cnt_freq_last <= cnt_freq;
	// end

