


module col_mix(
	input		[ 31:  0]	row1	,
	input		[ 31:  0]	row2	,
	input		[ 31:  0]	row3	,
	input		[ 31:  0]	row4	,
	output	reg	[ 31:  0]	colout1	,
	output	reg	[ 31:  0]	colout2	,
	output	reg	[ 31:  0]	colout3	,
	output	reg	[ 31:  0]	colout4
);
	/*
	输入的数据横向
	输出的数据纵向
	*/
	always@(*) begin
		colout1[ 31: 24] = col_mix_mul2(row1[31:24]) ^ col_mix_mul3(row2[31:24]) ^ row3[31:24] ^ row4[31:24];
		colout1[ 23: 16] = row1[31:24] ^ col_mix_mul2(row2[31:24]) ^ col_mix_mul3(row3[31:24]) ^ row4[31:24];
		colout1[ 15:  8] = row1[31:24] ^ row2[31:24] ^ col_mix_mul2(row3[31:24]) ^ col_mix_mul3(row4[31:24]);
		colout1[  7:  0] = col_mix_mul3(row1[31:24]) ^ row2[31:24] ^ row3[31:24] ^ col_mix_mul2(row4[31:24]);
		
		colout2[ 31: 24] = col_mix_mul2(row1[23:16]) ^ col_mix_mul3(row2[23:16]) ^ row3[23:16] ^ row4[23:16];
		colout2[ 23: 16] = row1[23:16] ^ col_mix_mul2(row2[23:16]) ^ col_mix_mul3(row3[23:16]) ^ row4[23:16];
		colout2[ 15:  8] = row1[23:16] ^ row2[23:16] ^ col_mix_mul2(row3[23:16]) ^ col_mix_mul3(row4[23:16]);
		colout2[  7:  0] = col_mix_mul3(row1[23:16]) ^ row2[23:16] ^ row3[23:16] ^ col_mix_mul2(row4[23:16]);
		
	    colout3[ 31: 24] = col_mix_mul2(row1[15: 8]) ^ col_mix_mul3(row2[15: 8]) ^ row3[15: 8] ^ row4[15: 8];
		colout3[ 23: 16] = row1[15: 8] ^ col_mix_mul2(row2[15: 8]) ^ col_mix_mul3(row3[15: 8]) ^ row4[15: 8];
		colout3[ 15:  8] = row1[15: 8] ^ row2[15: 8] ^ col_mix_mul2(row3[15: 8]) ^ col_mix_mul3(row4[15: 8]);
		colout3[  7:  0] = col_mix_mul3(row1[15: 8]) ^ row2[15: 8] ^ row3[15: 8] ^ col_mix_mul2(row4[15: 8]);
		
	    colout4[ 31: 24] = col_mix_mul2(row1[ 7: 0]) ^ col_mix_mul3(row2[ 7: 0]) ^ row3[ 7: 0] ^ row4[ 7: 0];
		colout4[ 23: 16] = row1[ 7: 0] ^ col_mix_mul2(row2[ 7: 0]) ^ col_mix_mul3(row3[ 7: 0]) ^ row4[ 7: 0];
		colout4[ 15:  8] = row1[ 7: 0] ^ row2[ 7: 0] ^ col_mix_mul2(row3[ 7: 0]) ^ col_mix_mul3(row4[ 7: 0]);
		colout4[  7:  0] = col_mix_mul3(row1[ 7: 0]) ^ row2[ 7: 0] ^ row3[ 7: 0] ^ col_mix_mul2(row4[ 7: 0]);
		

		// colout1[ 31: 24] = col_mix_mul2(row1[31:24]) ^ row2[31:24] ^ row3[31:24] ^ col_mix_mul3(row4[31:24]);
		// colout1[ 23: 16] = col_mix_mul3(row1[31:24]) ^ col_mix_mul2(row2[31:24]) ^ row3[31:24] ^ row4[31:24];
		// colout1[ 15:  8] = row1[31:24] ^ col_mix_mul3(row2[31:24]) ^ col_mix_mul2(row3[31:24]) ^ row4[31:24];
		// colout1[  7:  0] = row1[31:24] ^ row2[31:24] ^ col_mix_mul3(row3[31:24]) ^ col_mix_mul2(row4[31:24]);
		                   
		// colout2[ 31: 24] = col_mix_mul2(row1[23:16]) ^ row2[23:16] ^ row3[23:16] ^ col_mix_mul3(row4[23:16]);
		// colout2[ 23: 16] = col_mix_mul3(row1[23:16]) ^ col_mix_mul2(row2[23:16]) ^ row3[23:16] ^ row4[23:16];
		// colout2[ 15:  8] = row1[23:16] ^ col_mix_mul3(row2[23:16]) ^ col_mix_mul2(row3[23:16]) ^ row4[23:16];
		// colout2[  7:  0] = row1[23:16] ^ row2[23:16] ^ col_mix_mul3(row3[23:16]) ^ col_mix_mul2(row4[23:16]);
		                   
		// colout3[ 31: 24] = col_mix_mul2(row1[15: 8]) ^ row2[15: 8] ^ row3[15: 8] ^ col_mix_mul3(row4[15: 8]);
		// colout3[ 23: 16] = col_mix_mul3(row1[15: 8]) ^ col_mix_mul2(row2[15: 8]) ^ row3[15: 8] ^ row4[15: 8];
		// colout3[ 15:  8] = row1[15: 8] ^ col_mix_mul3(row2[15: 8]) ^ col_mix_mul2(row3[15: 8]) ^ row4[15: 8];
		// colout3[  7:  0] = row1[15: 8] ^ row2[15: 8] ^ col_mix_mul3(row3[15: 8]) ^ col_mix_mul2(row4[15: 8]);
		                   
		// colout4[ 31: 24] = col_mix_mul2(row1[ 7: 0]) ^ row2[ 7: 0] ^ row3[ 7: 0] ^ col_mix_mul3(row4[ 7: 0]);
		// colout4[ 23: 16] = col_mix_mul3(row1[ 7: 0]) ^ col_mix_mul2(row2[ 7: 0]) ^ row3[ 7: 0] ^ row4[ 7: 0];
		// colout4[ 15:  8] = row1[ 7: 0] ^ col_mix_mul3(row2[ 7: 0]) ^ col_mix_mul2(row3[ 7: 0]) ^ row4[ 7: 0];
		// colout4[  7:  0] = row1[ 7: 0] ^ row2[ 7: 0] ^ col_mix_mul3(row3[ 7: 0]) ^ col_mix_mul2(row4[ 7: 0]);
	end
	
	
	function [7:0] col_mix_mul2(input [7:0] data);
		begin
			if(data[7])
				col_mix_mul2 = {data[6:0],1'b0} ^ 8'b0001_1011;
			else
				col_mix_mul2 = {data[6:0],1'b0};
		end
	endfunction
	
	function [7:0] col_mix_mul3(input [7:0] data);
		begin
			col_mix_mul3 = col_mix_mul2(data) ^ data;
		end
	endfunction
	
	
endmodule




		// colout1[ 31: 24] = col_mix_mul2(row1[31:24]) ^ col_mix_mul3(row2[31:24]) ^ row3[31:24] ^ row4[31:24];
		// colout1[ 23: 16] = col_mix_mul2(row1[23:16]) ^ col_mix_mul3(row2[23:16]) ^ row3[23:16] ^ row4[23:16];
		// colout1[ 15:  8] = col_mix_mul2(row1[15: 8]) ^ col_mix_mul3(row2[15: 8]) ^ row3[15: 8] ^ row4[15: 8];
		// colout1[  7:  0] = col_mix_mul2(row1[ 7: 0]) ^ col_mix_mul3(row2[ 7: 0]) ^ row3[ 7: 0] ^ row4[ 7: 0];
		// colout2[ 31: 24] = row1[31:24] ^ col_mix_mul2(row2[31:24]) ^ col_mix_mul3(row3[31:24]) ^ row4[31:24];
		// colout2[ 23: 16] = row1[23:16] ^ col_mix_mul2(row2[23:16]) ^ col_mix_mul3(row3[23:16]) ^ row4[23:16];
		// colout2[ 15:  8] = row1[15: 8] ^ col_mix_mul2(row2[15: 8]) ^ col_mix_mul3(row3[15: 8]) ^ row4[15: 8];
		// colout2[  7:  0] = row1[ 7: 0] ^ col_mix_mul2(row2[ 7: 0]) ^ col_mix_mul3(row3[ 7: 0]) ^ row4[ 7: 0];
		// colout3[ 31: 24] = row1[31:24] ^ row2[31:24] ^ col_mix_mul2(row3[31:24]) ^ col_mix_mul3(row4[31:24]);
		// colout3[ 23: 16] = row1[23:16] ^ row2[23:16] ^ col_mix_mul2(row3[23:16]) ^ col_mix_mul3(row4[23:16]);
		// colout3[ 15:  8] = row1[15: 8] ^ row2[15: 8] ^ col_mix_mul2(row3[15: 8]) ^ col_mix_mul3(row4[15: 8]);
		// colout3[  7:  0] = row1[ 7: 0] ^ row2[ 7: 0] ^ col_mix_mul2(row3[ 7: 0]) ^ col_mix_mul3(row4[ 7: 0]);
		// colout4[ 31: 24] = col_mix_mul3(row1[31:24]) ^ row2[31:24] ^ row3[31:24] ^ col_mix_mul2(row4[31:24]);
		// colout4[ 23: 16] = col_mix_mul3(row1[23:16]) ^ row2[23:16] ^ row3[23:16] ^ col_mix_mul2(row4[23:16]);
		// colout4[ 15:  8] = col_mix_mul3(row1[15: 8]) ^ row2[15: 8] ^ row3[15: 8] ^ col_mix_mul2(row4[15: 8]);
		// colout4[  7:  0] = col_mix_mul3(row1[ 7: 0]) ^ row2[ 7: 0] ^ row3[ 7: 0] ^ col_mix_mul2(row4[ 7: 0]);


