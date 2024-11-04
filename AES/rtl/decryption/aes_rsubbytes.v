

module aes_rsubbytes(
	inout		[127:0]	in,
	output		[127:0]	out
);
	aes_inv_sbox aes_inv_sbox_01 (.a(in[127:120]), .d(out[127:120]));
	aes_inv_sbox aes_inv_sbox_02 (.a(in[119:112]), .d(out[119:112]));
	aes_inv_sbox aes_inv_sbox_03 (.a(in[111:104]), .d(out[111:104]));
	aes_inv_sbox aes_inv_sbox_04 (.a(in[103: 96]), .d(out[103: 96]));
	
	aes_inv_sbox aes_inv_sbox_05 (.a(in[ 95: 88]), .d(out[ 95: 88]));
	aes_inv_sbox aes_inv_sbox_06 (.a(in[ 87: 80]), .d(out[ 87: 80]));
	aes_inv_sbox aes_inv_sbox_07 (.a(in[ 79: 72]), .d(out[ 79: 72]));
	aes_inv_sbox aes_inv_sbox_08 (.a(in[ 71: 64]), .d(out[ 71: 64]));
	
	aes_inv_sbox aes_inv_sbox_09 (.a(in[ 63: 56]), .d(out[ 63: 56]));
	aes_inv_sbox aes_inv_sbox_10 (.a(in[ 55: 48]), .d(out[ 55: 48]));
	aes_inv_sbox aes_inv_sbox_11 (.a(in[ 47: 40]), .d(out[ 47: 40]));
	aes_inv_sbox aes_inv_sbox_12 (.a(in[ 39: 32]), .d(out[ 39: 32]));
	
	aes_inv_sbox aes_inv_sbox_13 (.a(in[ 31: 24]), .d(out[ 31: 24]));
	aes_inv_sbox aes_inv_sbox_14 (.a(in[ 23: 16]), .d(out[ 23: 16]));
	aes_inv_sbox aes_inv_sbox_15 (.a(in[ 15:  8]), .d(out[ 15:  8]));
	aes_inv_sbox aes_inv_sbox_16 (.a(in[  7:  0]), .d(out[  7:  0]));
	
	
	
	
	
	
	
	
	
	
	
 endmodule