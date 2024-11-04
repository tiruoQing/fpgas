

module aes_keyexpand(
	input	[127:0]	key00,
	
	output	[127:0]	key01,
	output	[127:0]	key02,
	output	[127:0]	key03,
	output	[127:0]	key04,
	output	[127:0]	key05,
	output	[127:0]	key06,
	output	[127:0]	key07,
	output	[127:0]	key08,
	output	[127:0]	key09,
	output	[127:0]	key10	
);
	/******************include*************/
	`include	"param.v"
	
	/******************wire*************/
	wire [31:0] w04_t;
	wire [31:0] w08_t;
	wire [31:0] w12_t;
	wire [31:0] w16_t;
	wire [31:0] w20_t;
	wire [31:0] w24_t;
	wire [31:0] w28_t;
	wire [31:0] w32_t;
	wire [31:0] w36_t;
	wire [31:0] w40_t;
	
	
	wire [ 31:0]	w00;
	wire [ 31:0]	w01;
	wire [ 31:0]	w02;
	wire [ 31:0]	w03;
	
	wire [ 31:0]	w04;
	wire [ 31:0]	w05;
	wire [ 31:0]	w06;
	wire [ 31:0]	w07;
	
	wire [ 31:0]	w08;
	wire [ 31:0]	w09;
	wire [ 31:0]	w10;
	wire [ 31:0]	w11;
	
	wire [ 31:0]	w12;
	wire [ 31:0]	w13;
	wire [ 31:0]	w14;
	wire [ 31:0]	w15;
	
	wire [ 31:0]	w16;
	wire [ 31:0]	w17;
	wire [ 31:0]	w18;
	wire [ 31:0]	w19;
	
	wire [ 31:0]	w20;
	wire [ 31:0]	w21;
	wire [ 31:0]	w22;
	wire [ 31:0]	w23;
	
	wire [ 31:0]	w24;
	wire [ 31:0]	w25;
	wire [ 31:0]	w26;
	wire [ 31:0]	w27;
	
	wire [ 31:0]	w28;
	wire [ 31:0]	w29;
	wire [ 31:0]	w30;
	wire [ 31:0]	w31;
	
	wire [ 31:0]	w32;
	wire [ 31:0]	w33;
	wire [ 31:0]	w34;
	wire [ 31:0]	w35;
	
	wire [ 31:0]	w36;
	wire [ 31:0]	w37;
	wire [ 31:0]	w38;
	wire [ 31:0]	w39;
	
	wire [ 31:0]	w40;
	wire [ 31:0]	w41;
	wire [ 31:0]	w42;
	wire [ 31:0]	w43;
	
	/******************assign*************/
	//拆解
	assign w00 = key00[127: 96];
	assign w01 = key00[ 95: 64];
	assign w02 = key00[ 63: 32];
	assign w03 = key00[ 31:  0];
	//组合
	assign key01 = {w04,w05,w06,w07};
	assign key02 = {w08,w09,w10,w11};
	assign key03 = {w12,w13,w14,w15};
	assign key04 = {w16,w17,w18,w19};
	assign key05 = {w20,w21,w22,w23};
	assign key06 = {w24,w25,w26,w27};
	assign key07 = {w28,w29,w30,w31};
	assign key08 = {w32,w33,w34,w35};
	assign key09 = {w36,w37,w38,w39};
	assign key10 = {w40,w41,w42,w43};
	
	//非4倍数计算
	assign w05 = w01 ^ w04;
	assign w06 = w02 ^ w05;
	assign w07 = w03 ^ w06;
	
	assign w09 = w05 ^ w08;
	assign w10 = w06 ^ w09;
	assign w11 = w07 ^ w10;
	
	assign w13 = w09 ^ w12;
	assign w14 = w10 ^ w13;
	assign w15 = w11 ^ w14;
	
	assign w17 = w13 ^ w16;
	assign w18 = w14 ^ w17;
	assign w19 = w15 ^ w18;
	
	assign w21 = w17 ^ w20;
	assign w22 = w18 ^ w21;
	assign w23 = w19 ^ w22;
	
	assign w25 = w21 ^ w24;
	assign w26 = w22 ^ w25;
	assign w27 = w23 ^ w26;
	
	assign w29 = w25 ^ w28;
	assign w30 = w26 ^ w29;
	assign w31 = w27 ^ w30;
	
	assign w33 = w29 ^ w32;
	assign w34 = w30 ^ w33;
	assign w35 = w31 ^ w34;
	
	assign w37 = w33 ^ w36;
	assign w38 = w34 ^ w37;
	assign w39 = w35 ^ w38;
	
	assign w41 = w37 ^ w40;
	assign w42 = w38 ^ w41;
	assign w43 = w39 ^ w42;
	
	//4倍数计算
	//第一轮
	aes_sbox aes_sbox_01(.a(w03[31:24]), .d(w04_t[31:24]));
	aes_sbox aes_sbox_02(.a(w03[23:16]), .d(w04_t[23:16]));
	aes_sbox aes_sbox_03(.a(w03[15: 8]), .d(w04_t[15: 8]));
	aes_sbox aes_sbox_04(.a(w03[ 7: 0]), .d(w04_t[ 7: 0]));
	assign w04 = {w04_t[23:16],w04_t[15: 8],w04_t[ 7: 0],w04_t[31:24]} ^ `RC01 ^ w00;
	
	//第二轮
	aes_sbox aes_sbox_05(.a(w07[31:24]), .d(w08_t[31:24]));
	aes_sbox aes_sbox_06(.a(w07[23:16]), .d(w08_t[23:16]));
	aes_sbox aes_sbox_07(.a(w07[15: 8]), .d(w08_t[15: 8]));
	aes_sbox aes_sbox_08(.a(w07[ 7: 0]), .d(w08_t[ 7: 0]));
	assign w08 = {w08_t[23:16],w08_t[15: 8],w08_t[ 7: 0],w08_t[31:24]} ^ `RC02 ^ w04;
	
	//第三轮
	aes_sbox aes_sbox_09(.a(w11[31:24]), .d(w12_t[31:24]));
	aes_sbox aes_sbox_10(.a(w11[23:16]), .d(w12_t[23:16]));
	aes_sbox aes_sbox_11(.a(w11[15: 8]), .d(w12_t[15: 8]));
	aes_sbox aes_sbox_12(.a(w11[ 7: 0]), .d(w12_t[ 7: 0]));
	assign w12 = {w12_t[23:16],w12_t[15: 8],w12_t[ 7: 0],w12_t[31:24]} ^ `RC03 ^ w08;
	
	//第四轮
	aes_sbox aes_sbox_13(.a(w15[31:24]), .d(w16_t[31:24]));
	aes_sbox aes_sbox_14(.a(w15[23:16]), .d(w16_t[23:16]));
	aes_sbox aes_sbox_15(.a(w15[15: 8]), .d(w16_t[15: 8]));
	aes_sbox aes_sbox_16(.a(w15[ 7: 0]), .d(w16_t[ 7: 0]));
	assign w16 = {w16_t[23:16],w16_t[15: 8],w16_t[ 7: 0],w16_t[31:24]} ^ `RC04 ^ w12;
	
	//第五轮
	aes_sbox aes_sbox_17(.a(w19[31:24]), .d(w20_t[31:24]));
	aes_sbox aes_sbox_18(.a(w19[23:16]), .d(w20_t[23:16]));
	aes_sbox aes_sbox_19(.a(w19[15: 8]), .d(w20_t[15: 8]));
	aes_sbox aes_sbox_20(.a(w19[ 7: 0]), .d(w20_t[ 7: 0]));
	assign w20 = {w20_t[23:16],w20_t[15: 8],w20_t[ 7: 0],w20_t[31:24]} ^ `RC05 ^ w16;
	
	//第六轮
	aes_sbox aes_sbox_21(.a(w23[31:24]), .d(w24_t[31:24]));
	aes_sbox aes_sbox_22(.a(w23[23:16]), .d(w24_t[23:16]));
	aes_sbox aes_sbox_23(.a(w23[15: 8]), .d(w24_t[15: 8]));
	aes_sbox aes_sbox_24(.a(w23[ 7: 0]), .d(w24_t[ 7: 0]));
	assign w24 = {w24_t[23:16],w24_t[15: 8],w24_t[ 7: 0],w24_t[31:24]} ^ `RC06 ^ w20;
	
	//第七轮
	aes_sbox aes_sbox_25(.a(w27[31:24]), .d(w28_t[31:24]));
	aes_sbox aes_sbox_26(.a(w27[23:16]), .d(w28_t[23:16]));
	aes_sbox aes_sbox_27(.a(w27[15: 8]), .d(w28_t[15: 8]));
	aes_sbox aes_sbox_28(.a(w27[ 7: 0]), .d(w28_t[ 7: 0]));
	assign w28 = {w28_t[23:16],w28_t[15: 8],w28_t[ 7: 0],w28_t[31:24]} ^ `RC07 ^ w24;
	
	//第八轮
	aes_sbox aes_sbox_29(.a(w31[31:24]), .d(w32_t[31:24]));
	aes_sbox aes_sbox_30(.a(w31[23:16]), .d(w32_t[23:16]));
	aes_sbox aes_sbox_31(.a(w31[15: 8]), .d(w32_t[15: 8]));
	aes_sbox aes_sbox_32(.a(w31[ 7: 0]), .d(w32_t[ 7: 0]));
	assign w32 = {w32_t[23:16],w32_t[15: 8],w32_t[ 7: 0],w32_t[31:24]} ^ `RC08 ^ w28;
	
	//第九轮
	aes_sbox aes_sbox_33(.a(w35[31:24]), .d(w36_t[31:24]));
	aes_sbox aes_sbox_34(.a(w35[23:16]), .d(w36_t[23:16]));
	aes_sbox aes_sbox_35(.a(w35[15: 8]), .d(w36_t[15: 8]));
	aes_sbox aes_sbox_36(.a(w35[ 7: 0]), .d(w36_t[ 7: 0]));
	assign w36 = {w36_t[23:16],w36_t[15: 8],w36_t[ 7: 0],w36_t[31:24]} ^ `RC09 ^ w32;
	
	//第十轮
	aes_sbox aes_sbox_37(.a(w39[31:24]), .d(w40_t[31:24]));
	aes_sbox aes_sbox_38(.a(w39[23:16]), .d(w40_t[23:16]));
	aes_sbox aes_sbox_39(.a(w39[15: 8]), .d(w40_t[15: 8]));
	aes_sbox aes_sbox_40(.a(w39[ 7: 0]), .d(w40_t[ 7: 0]));
	assign w40 = {w40_t[23:16],w40_t[15: 8],w40_t[ 7: 0],w40_t[31:24]} ^ `RC10 ^ w36;
	
endmodule