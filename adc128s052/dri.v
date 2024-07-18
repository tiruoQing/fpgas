

/*
dout : 输出引脚
din : 输入引脚
cs下降沿开始数据帧
cs上升沿结束数据帧

sclk工作始终频率 : 3.2MHz - 8MHz
sclk上升沿个数为16的倍数
sclk下降沿, dout输出数据 , MSB优先, 则在sclk上升沿采集数据
sclk的1-4个下降沿输出零, 5-16输出12bit数据
sclk的上升沿记录DIN, 数据格式xx210xxx, 则需要在下降沿进行数据输入
*/


/*
	期望ADC采样率为500KSPS, 则需要sclk时钟为8MHz, 输入时钟16MHZ, 并且cs信号持续拉低
*/

module adc128s052_dri_8ch(
	input	wire			clk		, // 16MHz
	input	wire			rst_n	,
	input	wire			start	, // 只需要在16MHz时钟下给一个高电平脉冲即可
	
	// pin io
	output	wire			dout	,
	output	wire			sclk	,
	input	wire			din		,
	output	wire			cs		, // 低有效
	
	output	wire			done	, // 一个通道数据采集完成信号
	output	wire	[2:0]	channel	, //
	output	reg		[15:0]	data	
);
	
	parameter CNT_MAX	=	9'd32	;
	
	
	reg					r_cs		;
	reg					r_dout		;
	reg					r_sclk		;
	reg		[ 8:0]		cnt			; // sclk 时钟计数器
	
	reg		[15:0]		t_data		; // 通道数据采集
	reg		[ 2:0]		cnt_channel	;
	reg		[ 1:0]		channel_d	;
	
	assign cs 		= 	r_cs		;
	assign sclk 	= 	r_sclk		;
	assign dout 	= 	r_dout		;
	assign done		= 	(cnt == CNT_MAX) ? 1'b1 : 1'b0;	// 当16bit计数完成过后, 输出一次完成信号进行通道数据读取
	assign channel	=	cnt_channel	;
	
	/*
		cs信号一旦开始拉低, 一直保持, 使adc一直工作, 8MHz sclk, 500KSPS采样率
	*/
	always@(posedge clk or negedge rst_n) begin
		if(!rst_n)
			r_cs <= 1'b1;
		// 不将cs信号拉高, 使adc持续输出
		// else if(done)
			// r_cs <= 1'b1;
		else if(start)
			r_cs <= 1'b0;
		else
			r_cs <= r_cs;
	end
	
	
	// 当计数器满过后, 技术清零, 开始下一个工作
	always@(posedge clk or negedge rst_n) begin
		if(!rst_n)
			cnt <= 'd0;
		else if(!r_cs) begin
			if(cnt == CNT_MAX)
				cnt <= 'd1;
			else
				cnt <= cnt + 1'b1;
		end else
			cnt <= 'd0;
	end
	
	
	always@(posedge clk or negedge rst_n) begin
		if(!rst_n)
			channel_d <= 2'd0;
		else
			channel_d <= {channel_d[0], done};
	end
	
	// 通道计数器, 一个通道的最后一个下降沿时, 通道加 1 
	always@(posedge clk or negedge rst_n) begin
		if(!rst_n)
			cnt_channel <= 'd0;
		else if(channel_d[1])
			cnt_channel <= cnt_channel + 1'b1;
		else
			cnt_channel <= cnt_channel;
	end
	
	/*
	if(done)
		此时通道与通道数据对齐
	*/
	// 当采集完成信号拉高, 采集数据, 其余时间保持
	always@(posedge clk or negedge rst_n) begin
		if(!rst_n)
			data <= 16'h5a5a;
		else if(done)
			data <= t_data;
		else
			data <= data;
	end
	
	
	/*
	
	*/
	
	// sclk, sdi, sdo 操作时序
	always@(posedge clk or negedge rst_n) begin
		if(!rst_n) begin
			r_sclk <= 1'b1;
			r_dout <= 1'b1;
		end
		else if(!cs) begin
			case(cnt)
				'd0 : r_sclk <= 1'b1;
				'd1 : r_sclk <= 1'b0;  // 1
				'd2 : begin
					r_sclk <= 1'b1;
					t_data[15] <= 1'b0;
				end
				'd3 : r_sclk <= 1'b0;  // 2
				'd4 : begin
					r_sclk <= 1'b1;
					t_data[14] <= 1'b0;
				end
				'd5 : begin
					r_sclk <= 1'b0;    // 3
					r_dout <= cnt_channel[2];
				end
				'd6 : begin
					r_sclk <= 1'b1;
					t_data[13] <= 1'b0;
				end
				'd7 : begin
					r_sclk <= 1'b0;    // 4
					r_dout <= cnt_channel[1];
				end
				'd8 : begin
					r_sclk <= 1'b1;
					t_data[12] <= 1'b0;
				end
				'd9 : begin
					r_sclk <= 1'b0;    // 5
					r_dout <= cnt_channel[0];
				end
				'd10: begin
					r_sclk <= 1'b1;
					t_data[11] <= din;
				end
				'd11: r_sclk <= 1'b0;  // 6
				'd12: begin
					r_sclk <= 1'b1;
					t_data[10] <= din;
				end
				'd13: r_sclk <= 1'b0;  // 7
				'd14: begin
					r_sclk <= 1'b1;
					t_data[9] <= din;
				end
				'd15: r_sclk <= 1'b0;  // 8
				'd16: begin
					r_sclk <= 1'b1;
					t_data[8] <= din;
				end
				'd17: r_sclk <= 1'b0;  // 9
				'd18: begin
					r_sclk <= 1'b1;
					t_data[7] <= din;
				end
				'd19: r_sclk <= 1'b0;  // 10
				'd20: begin
					r_sclk <= 1'b1;
					t_data[6] <= din;
				end
				'd21: r_sclk <= 1'b0;  // 11
				'd22: begin
					r_sclk <= 1'b1;
					t_data[5] <= din;
				end
				'd23: r_sclk <= 1'b0;  // 12
				'd24: begin
					r_sclk <= 1'b1;
					t_data[4] <= din;
				end
				'd25: r_sclk <= 1'b0;  // 13
				'd26: begin
					r_sclk <= 1'b1;
					t_data[3] <= din;
				end
				'd27: r_sclk <= 1'b0;  // 14
				'd28: begin
					r_sclk <= 1'b1;
					t_data[2] <= din;
				end
				'd29: r_sclk <= 1'b0;  // 15
				'd30: begin
					r_sclk <= 1'b1;
					t_data[1] <= din;
				end
				'd31: r_sclk <= 1'b0;  // 16
				'd32: begin
					r_sclk <= 1'b1;  // 
					t_data[0] <= din;
				end
				default : r_sclk <= 1'b1;
			endcase
		end	else begin
			r_sclk <= 1'b1;
			r_dout <= 1'b1;
		end
	end
	
	
	
endmodule






