

module encryption_for(
	input		[127:0]	plaintxt	,	//输入初始变换后的明文
	input		[127:0]	key			,
	output		[127:0]	ciphertext		//输出一轮变换后的密文
);
	/*
	输入纵向
	*/
	wire [127:0] sub_result;		//字节提替换后的密文		
	wire [ 31:0] colout1,colout2,colout3,colout4;
	
	//轮密钥加
	assign	ciphertext = {colout1 ^ key[127:96], colout2 ^ key[95:64], colout3 ^ key[63:32], colout4 ^ key[31:0]};
	
	//字节替换
	aes_subbytes aes_subbytes_inst(
		.in(plaintxt),
		.out(sub_result)
	);
	
	//在输入列混合参数的时候进行 行位移
	col_mix col_mix_inst_inst(
		.row1	({sub_result[127:120],sub_result[ 95: 88],sub_result[ 63: 56],sub_result[ 31: 24]}),
		.row2	({sub_result[ 87: 80],sub_result[ 55: 48],sub_result[ 23: 16],sub_result[119:112]}),
		.row3	({sub_result[ 47: 40],sub_result[ 15:  8],sub_result[111:104],sub_result[ 79: 72]}),
		.row4	({sub_result[  7:  0],sub_result[103: 96],sub_result[ 71: 64],sub_result[ 39: 32]}),
		.colout1 (colout1),
		.colout2 (colout2),
		.colout3 (colout3),
		.colout4 (colout4)
	);
	
endmodule



