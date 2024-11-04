

module encryption_last(
	input		[127:0]	plaintxt	,	//输入初始变换后的明文
	input		[127:0]	key			,
	output		[127:0]	ciphertext		//输出一轮变换后的密文
);
	/*
	输入纵向
	*/
	
	wire [127:0] sub_result;		//字节提替换后的密文
	
	wire [ 31:0] colout1;
	wire [ 31:0] colout2;
	wire [ 31:0] colout3;
	wire [ 31:0] colout4;
	
	wire [ 31:0]	row1;
	wire [ 31:0]	row2;
	wire [ 31:0]	row3;
	wire [ 31:0]	row4;	
	
	
	//轮密钥加
	assign	ciphertext = {colout1 ^ key[127:96], colout2 ^ key[95:64], colout3 ^ key[63:32], colout4 ^ key[31:0]};
	
	//字节替换
	aes_subbytes aes_subbytes_inst(
		.in(plaintxt),
		.out(sub_result)
	);
	
	assign row1 = {sub_result[127:120],sub_result[ 95: 88],sub_result[ 63: 56],sub_result[ 31: 24]};
	assign row2 = {sub_result[ 87: 80],sub_result[ 55: 48],sub_result[ 23: 16],sub_result[119:112]};
	assign row3 = {sub_result[ 47: 40],sub_result[ 15:  8],sub_result[111:104],sub_result[ 79: 72]};
	assign row4 = {sub_result[  7:  0],sub_result[103: 96],sub_result[ 71: 64],sub_result[ 39: 32]};
	
	assign colout1 = {row1[31:24],row2[31:24],row3[31:24],row4[31:24]};
	assign colout2 = {row1[23:16],row2[23:16],row3[23:16],row4[23:16]};
	assign colout3 = {row1[15: 8],row2[15: 8],row3[15: 8],row4[15: 8]};
	assign colout4 = {row1[ 7: 0],row2[ 7: 0],row3[ 7: 0],row4[ 7: 0]};
	
	
	
endmodule



