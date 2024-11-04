//************************************************/
//
//plaintext :0
//key		:000102030405060708090a0b0c0d0e0f
//ciphertext:
//
//
//
//
//
//*************************************************/


module aes_encryption(
	input				clk				,
	input				rst				,
	input				en_start		,
	input		[127:0]	plaintext		,
	
	output		[127:0]	ciphertext_o		
);
	
	/******************include**********************/
	`include	"param.v"
	
	/******************reg**********************/
	//开始信号两级寄存器
	reg s0,s1;
	
	
	//原始明文矩阵
	reg [ 31:0]	p0_r1		;
	reg [ 31:0]	p0_r2		;
	reg [ 31:0]	p0_r3		;
	reg [ 31:0]	p0_r4		;
	
	/******************wire**********************/	
	wire	[127:0]		key00		;
	wire    [127:0]		key01  		;
	wire    [127:0]		key02       ;
	wire    [127:0]		key03       ;
	wire    [127:0]		key04       ;
	wire    [127:0]		key05       ;
	wire    [127:0]		key06       ;
	wire    [127:0]		key07       ;
	wire    [127:0]		key08       ;
	wire    [127:0]		key09       ;
	wire    [127:0]		key10       ;
	
	wire	[127:0]		for_result_1;
	wire	[127:0]		for_result_2;
	wire	[127:0]		for_result_3;
	wire	[127:0]		for_result_4;
	wire	[127:0]		for_result_5;
	wire	[127:0]		for_result_6;
	wire	[127:0]		for_result_7;
	wire	[127:0]		for_result_8;
	wire	[127:0]		for_result_9;
	
	/******************assign**********************/
	assign key00 = {`k0_w0, `k0_w1, `k0_w2, `k0_w3};
	
	/******************always**********************/
	
	//将明文转换成矩阵----->第一次密钥加变换
	always@(posedge clk or negedge rst) begin
		if(!rst) begin
			p0_r1 <= 31'd0;
			p0_r2 <= 31'd0;
			p0_r3 <= 31'd0;
			p0_r4 <= 31'd0;
		end
		else begin
			if(en_start) begin
				p0_r1 <= plaintext[127: 96] ^ `k0_w0;
				p0_r2 <= plaintext[ 95: 64] ^ `k0_w1;
				p0_r3 <= plaintext[ 63: 32] ^ `k0_w2;
				p0_r4 <= plaintext[ 31:  0] ^ `k0_w3;
			end
			else begin
				p0_r1 <= 32'd0;
				p0_r2 <= 32'd0;
				p0_r3 <= 32'd0;
				p0_r4 <= 32'd0;
			end
			
		end
	end
	
	
	/******************instance**********************/
	//第一轮
	encryption_for encryption_for_1 	(.plaintxt({p0_r1,p0_r2,p0_r3,p0_r4}), .key(key01), .ciphertext(for_result_1));
	encryption_for encryption_for_2 	(.plaintxt(for_result_1), .key(key02), .ciphertext(for_result_2));
	encryption_for encryption_for_3 	(.plaintxt(for_result_2), .key(key03), .ciphertext(for_result_3));
	encryption_for encryption_for_4 	(.plaintxt(for_result_3), .key(key04), .ciphertext(for_result_4));
	encryption_for encryption_for_5 	(.plaintxt(for_result_4), .key(key05), .ciphertext(for_result_5));
	encryption_for encryption_for_6 	(.plaintxt(for_result_5), .key(key06), .ciphertext(for_result_6));
	encryption_for encryption_for_7 	(.plaintxt(for_result_6), .key(key07), .ciphertext(for_result_7));
	encryption_for encryption_for_8 	(.plaintxt(for_result_7), .key(key08), .ciphertext(for_result_8));
	encryption_for encryption_for_9 	(.plaintxt(for_result_8), .key(key09), .ciphertext(for_result_9));
	encryption_last encryption_last_o	(.plaintxt(for_result_9), .key(key10), .ciphertext(ciphertext_o));
	
	
	aes_keyexpand aes_keyexpand_ins(
		.key00	(key00	),
		.key01  (key01  ),
		.key02  (key02  ),
		.key03  (key03  ),
		.key04  (key04  ),
		.key05  (key05  ),
		.key06  (key06  ),
		.key07  (key07  ),
		.key08  (key08  ),
		.key09  (key09  ),
		.key10  (key10  )
	);


endmodule





