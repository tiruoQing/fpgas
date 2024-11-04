


module aes_decryption_last(
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
	
	wire	[31:0]	col1 ;
	wire	[31:0]	col2 ;
	wire	[31:0]	col3 ;
	wire	[31:0]	col4 ;
	
	wire	[31:0]	psdXor_row1;
	wire	[31:0]	psdXor_row2;
	wire	[31:0]	psdXor_row3;
	wire	[31:0]	psdXor_row4;
	
	wire	[31:0]	mix_row1	;
	wire	[31:0]	mix_row2    ;
	wire	[31:0]	mix_row3    ;
	wire	[31:0]	mix_row4    ;
	
	/*************assign************/
	//逆行位移
	assign row1 = {ciphertex[127:120],ciphertex[ 95: 88],ciphertex[ 63: 56],ciphertex[ 31: 24]};
	assign row2 = {ciphertex[ 23: 16],ciphertex[119:112],ciphertex[ 87: 80],ciphertex[ 55: 48]};
	assign row3 = {ciphertex[ 47: 40],ciphertex[ 15:  8],ciphertex[111:104],ciphertex[ 79: 72]};
	assign row4 = {ciphertex[ 71: 64],ciphertex[ 39: 32],ciphertex[  7:  0],ciphertex[103: 96]};
	
	assign plaintext = {col1,col2,col3,col4};
	
	//轮密钥加数据
	assign psdXor_row1 = {key[127:120],key[ 95: 88],key[ 63: 56],key[ 31: 24]};
	assign psdXor_row2 = {key[119:112],key[ 87: 80],key[ 55: 48],key[ 23: 16]};
	assign psdXor_row3 = {key[111:104],key[ 79: 72],key[ 47: 40],key[ 15:  8]};
	assign psdXor_row4 = {key[103: 96],key[ 71: 64],key[ 39: 32],key[  7:  0]};
	
	//code_mix
	assign mix_row1 = {sub_row1 ^ psdXor_row1} ;
	assign mix_row2 = {sub_row2 ^ psdXor_row2} ;
	assign mix_row3 = {sub_row3 ^ psdXor_row3} ;
	assign mix_row4 = {sub_row4 ^ psdXor_row4} ;
	
	assign col1 = {mix_row1[ 31: 24],mix_row2[ 31: 24],mix_row3[ 31: 24],mix_row4[ 31: 24]};
	assign col2 = {mix_row1[ 23: 16],mix_row2[ 23: 16],mix_row3[ 23: 16],mix_row4[ 23: 16]};
	assign col3 = {mix_row1[ 15:  8],mix_row2[ 15:  8],mix_row3[ 15:  8],mix_row4[ 15:  8]};
	assign col4 = {mix_row1[  7:  0],mix_row2[  7:  0],mix_row3[  7:  0],mix_row4[  7:  0]};
	
	/**********instance**********************/
	
	//逆字节代换
	aes_rsubbytes aes_rsubbytes_inst(.in({row1,row2,row3,row4}),.out({sub_row1,sub_row2,sub_row3,sub_row4}));
	
	
	
	
	
endmodule