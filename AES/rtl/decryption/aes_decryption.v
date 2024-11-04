

module aes_decryption(
	input				clk			,
	input				rst			,
	input				de_start	,
	
	input		[127:0] ciphertext	,
	
	output		[127:0]	plaintext	
);
	
	/********include**************/
	`include "param.v"
	
	/************wire*****************/	
	wire	[127:0]	key00	;
	wire    [127:0]	key01	;
	wire    [127:0]	key02	;
	wire    [127:0]	key03	;
	wire    [127:0]	key04	;
	wire    [127:0]	key05	;
	wire    [127:0]	key06	;
	wire    [127:0]	key07	;
	wire    [127:0]	key08	;
	wire    [127:0]	key09	;
	wire    [127:0]	key10	;
	
	wire	[127:0]	de_result_01;
	wire	[127:0]	de_result_02;
	wire	[127:0]	de_result_03;
	wire	[127:0]	de_result_04;
	wire	[127:0]	de_result_05;
	wire	[127:0]	de_result_06;
	wire	[127:0]	de_result_07;
	wire	[127:0]	de_result_08;
	wire	[127:0]	de_result_09;
	
	/*****************reg*******************/	
	reg 	[31:0]	p0_r1	;
	reg 	[31:0]	p0_r2	;
	reg 	[31:0]	p0_r3	;
	reg 	[31:0]	p0_r4	;
	/****************assign****************/
	assign key00 = {`k0_w0,`k0_w1,`k0_w2,`k0_w3};
	
	/***************always**********************/
	
	//将明文转换成矩阵----->第一次密钥加变换
	always@(posedge clk or negedge rst ) begin
		if(!rst) begin
			p0_r1 <= 32'd0;
			p0_r2 <= 32'd0;
			p0_r3 <= 32'd0;
			p0_r4 <= 32'd0;
		end
		else begin
			if(de_start) begin
				p0_r1 = ({ciphertext[127:120],ciphertext[119:112],ciphertext[111:104],ciphertext[103: 96]}) ^ key10[127: 96];
				p0_r2 = ({ciphertext[ 95: 88],ciphertext[ 87: 80],ciphertext[ 79: 72],ciphertext[ 71: 64]}) ^ key10[ 95: 64];
				p0_r3 = ({ciphertext[ 63: 56],ciphertext[ 55: 48],ciphertext[ 47: 40],ciphertext[ 39: 32]}) ^ key10[ 63: 32];
				p0_r4 = ({ciphertext[ 31: 24],ciphertext[ 23: 16],ciphertext[ 15:  8],ciphertext[  7:  0]}) ^ key10[ 31:  0];
			end
			else begin
				p0_r1 <= 32'd0;
				p0_r2 <= 32'd0;
				p0_r3 <= 32'd0;
				p0_r4 <= 32'd0;
			end
		end
	end
	
	/********instance**************/
	
	aes_keyexpand aes_keyexpand_inst(
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
	
	aes_decryption_for aes_decryption_for_1(.ciphertex({p0_r1,p0_r2,p0_r3,p0_r4}),.key(key09),.plaintext(de_result_01));
	aes_decryption_for aes_decryption_for_2(.ciphertex(de_result_01),.key(key08),.plaintext(de_result_02));
	aes_decryption_for aes_decryption_for_3(.ciphertex(de_result_02),.key(key07),.plaintext(de_result_03));
	aes_decryption_for aes_decryption_for_4(.ciphertex(de_result_03),.key(key06),.plaintext(de_result_04));
	aes_decryption_for aes_decryption_for_5(.ciphertex(de_result_04),.key(key05),.plaintext(de_result_05));
	aes_decryption_for aes_decryption_for_6(.ciphertex(de_result_05),.key(key04),.plaintext(de_result_06));
	aes_decryption_for aes_decryption_for_7(.ciphertex(de_result_06),.key(key03),.plaintext(de_result_07));
	aes_decryption_for aes_decryption_for_8(.ciphertex(de_result_07),.key(key02),.plaintext(de_result_08));
	aes_decryption_for aes_decryption_for_9(.ciphertex(de_result_08),.key(key01),.plaintext(de_result_09));
	aes_decryption_last aes_decryption_last(.ciphertex(de_result_09),.key(key00),.plaintext(plaintext	));
	
	
endmodule










