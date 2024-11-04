


module aes_decryption_for(
	input		[127:0]	ciphertex	,
	input		[127:0]	key			,
	output		[127:0]	plaintext	
);
	/************WIRE**************/
	//输入纵向
	wire	[31:0]	row1;
	wire	[31:0]	row2;
	wire	[31:0]	row3;
	wire	[31:0]	row4;
	//字节替换前
	wire	[31:0]	sub_row1;
	wire	[31:0]	sub_row2;
	wire	[31:0]	sub_row3;
	wire	[31:0]	sub_row4;
	
	wire	[31:0]	colout1 ;
	wire	[31:0]	colout2 ;
	wire	[31:0]	colout3 ;
	wire	[31:0]	colout4 ;
	
	wire	[31:0]	psdXor_row1;
	wire	[31:0]	psdXor_row2;
	wire	[31:0]	psdXor_row3;
	wire	[31:0]	psdXor_row4;
	
	/*************assign************/
	//逆行位移
	assign row1 = {ciphertex[127:120],ciphertex[ 95: 88],ciphertex[ 63: 56],ciphertex[ 31: 24]};
	assign row2 = {ciphertex[ 23: 16],ciphertex[119:112],ciphertex[ 87: 80],ciphertex[ 55: 48]};
	assign row3 = {ciphertex[ 47: 40],ciphertex[ 15:  8],ciphertex[111:104],ciphertex[ 79: 72]};
	assign row4 = {ciphertex[ 71: 64],ciphertex[ 39: 32],ciphertex[  7:  0],ciphertex[103: 96]};
	
	assign plaintext = {colout1,colout2,colout3,colout4};
	
	//轮密钥加数据
	assign psdXor_row1 = {key[127:120],key[ 95: 88],key[ 63: 56],key[ 31: 24]};
	assign psdXor_row2 = {key[119:112],key[ 87: 80],key[ 55: 48],key[ 23: 16]};
	assign psdXor_row3 = {key[111:104],key[ 79: 72],key[ 47: 40],key[ 15:  8]};
	assign psdXor_row4 = {key[103: 96],key[ 71: 64],key[ 39: 32],key[  7:  0]};
	
	
	/**********instance**********************/
	
	//逆字节代换
	aes_rsubbytes aes_rsubbytes_inst(.in({row1,row2,row3,row4}),.out({sub_row1,sub_row2,sub_row3,sub_row4}));
	
	//逆列混合
	//传入横向
	rcol_mix rcol_mix_inst(
		.row1		(sub_row1 ^ psdXor_row1	),
		.row2	    (sub_row2 ^ psdXor_row2	),
		.row3	    (sub_row3 ^ psdXor_row3	),
		.row4	    (sub_row4 ^ psdXor_row4	),
		.colout1	(colout1				),
		.colout2	(colout2				),
		.colout3	(colout3				),
		.colout4    (colout4    			)
	);

endmodule