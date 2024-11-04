


module rcol_mix(
	input		[ 31:  0]	row1	,
	input		[ 31:  0]	row2	,
	input		[ 31:  0]	row3	,
	input		[ 31:  0]	row4	,
	output	reg	[ 31:  0]	colout1	,
	output	reg	[ 31:  0]	colout2	,
	output	reg	[ 31:  0]	colout3	,
	output	reg	[ 31:  0]	colout4
);
	
	 
	always@(*) begin
		colout1[ 31: 24] = col_mix_mu0e(row1[31:24]) ^ col_mix_mu0b(row2[31:24]) ^ col_mix_mu0d(row3[31:24]) ^ col_mix_mu09(row4[31:24]);
		colout1[ 23: 16] = col_mix_mu09(row1[31:24]) ^ col_mix_mu0e(row2[31:24]) ^ col_mix_mu0b(row3[31:24]) ^ col_mix_mu0d(row4[31:24]);
		colout1[ 15:  8] = col_mix_mu0d(row1[31:24]) ^ col_mix_mu09(row2[31:24]) ^ col_mix_mu0e(row3[31:24]) ^ col_mix_mu0b(row4[31:24]);
		colout1[  7:  0] = col_mix_mu0b(row1[31:24]) ^ col_mix_mu0d(row2[31:24]) ^ col_mix_mu09(row3[31:24]) ^ col_mix_mu0e(row4[31:24]);
		
		colout2[ 31: 24] = col_mix_mu0e(row1[23:16]) ^ col_mix_mu0b(row2[23:16]) ^ col_mix_mu0d(row3[23:16]) ^ col_mix_mu09(row4[23:16]);
		colout2[ 23: 16] = col_mix_mu09(row1[23:16]) ^ col_mix_mu0e(row2[23:16]) ^ col_mix_mu0b(row3[23:16]) ^ col_mix_mu0d(row4[23:16]);
		colout2[ 15:  8] = col_mix_mu0d(row1[23:16]) ^ col_mix_mu09(row2[23:16]) ^ col_mix_mu0e(row3[23:16]) ^ col_mix_mu0b(row4[23:16]);
		colout2[  7:  0] = col_mix_mu0b(row1[23:16]) ^ col_mix_mu0d(row2[23:16]) ^ col_mix_mu09(row3[23:16]) ^ col_mix_mu0e(row4[23:16]);
		
		colout3[ 31: 24] = col_mix_mu0e(row1[15: 8]) ^ col_mix_mu0b(row2[15: 8]) ^ col_mix_mu0d(row3[15: 8]) ^ col_mix_mu09(row4[15: 8]);
		colout3[ 23: 16] = col_mix_mu09(row1[15: 8]) ^ col_mix_mu0e(row2[15: 8]) ^ col_mix_mu0b(row3[15: 8]) ^ col_mix_mu0d(row4[15: 8]);
		colout3[ 15:  8] = col_mix_mu0d(row1[15: 8]) ^ col_mix_mu09(row2[15: 8]) ^ col_mix_mu0e(row3[15: 8]) ^ col_mix_mu0b(row4[15: 8]);
		colout3[  7:  0] = col_mix_mu0b(row1[15: 8]) ^ col_mix_mu0d(row2[15: 8]) ^ col_mix_mu09(row3[15: 8]) ^ col_mix_mu0e(row4[15: 8]);
		
		colout4[ 31: 24] = col_mix_mu0e(row1[ 7: 0]) ^ col_mix_mu0b(row2[ 7: 0]) ^ col_mix_mu0d(row3[ 7: 0]) ^ col_mix_mu09(row4[ 7: 0]);
		colout4[ 23: 16] = col_mix_mu09(row1[ 7: 0]) ^ col_mix_mu0e(row2[ 7: 0]) ^ col_mix_mu0b(row3[ 7: 0]) ^ col_mix_mu0d(row4[ 7: 0]);
		colout4[ 15:  8] = col_mix_mu0d(row1[ 7: 0]) ^ col_mix_mu09(row2[ 7: 0]) ^ col_mix_mu0e(row3[ 7: 0]) ^ col_mix_mu0b(row4[ 7: 0]);
		colout4[  7:  0] = col_mix_mu0b(row1[ 7: 0]) ^ col_mix_mu0d(row2[ 7: 0]) ^ col_mix_mu09(row3[ 7: 0]) ^ col_mix_mu0e(row4[ 7: 0]);
		
		// colout1[ 31: 24] = col_mix_mu0e(row1[31:24]) ^ col_mix_mu0b(row2[23:16]) ^ col_mix_mu0d(row3[15: 8]) ^ col_mix_mu09(row4[ 7: 0]);
		// colout1[ 23: 16] = col_mix_mu09(row1[31:24]) ^ col_mix_mu0e(row2[23:16]) ^ col_mix_mu0b(row3[15: 8]) ^ col_mix_mu0d(row4[ 7: 0]);
		// colout1[ 15:  8] = col_mix_mu0d(row1[31:24]) ^ col_mix_mu09(row2[23:16]) ^ col_mix_mu0e(row3[15: 8]) ^ col_mix_mu0b(row4[ 7: 0]);
		// colout1[  7:  0] = col_mix_mu0b(row1[31:24]) ^ col_mix_mu0d(row2[23:16]) ^ col_mix_mu09(row3[15: 8]) ^ col_mix_mu0e(row4[ 7: 0]);
		
		// colout2[ 31: 24] = col_mix_mu0e(row1[31:24]) ^ col_mix_mu0b(row2[23:16]) ^ col_mix_mu0d(row3[15: 8]) ^ col_mix_mu09(row4[ 7: 0]);
		// colout2[ 23: 16] = col_mix_mu09(row1[31:24]) ^ col_mix_mu0e(row2[23:16]) ^ col_mix_mu0b(row3[15: 8]) ^ col_mix_mu0d(row4[ 7: 0]);
		// colout2[ 15:  8] = col_mix_mu0d(row1[31:24]) ^ col_mix_mu09(row2[23:16]) ^ col_mix_mu0e(row3[15: 8]) ^ col_mix_mu0b(row4[ 7: 0]);
		// colout2[  7:  0] = col_mix_mu0b(row1[31:24]) ^ col_mix_mu0d(row2[23:16]) ^ col_mix_mu09(row3[15: 8]) ^ col_mix_mu0e(row4[ 7: 0]);
		
		// colout3[ 31: 24] = col_mix_mu0e(row1[31:24]) ^ col_mix_mu0b(row2[23:16]) ^ col_mix_mu0d(row3[15: 8]) ^ col_mix_mu09(row4[ 7: 0]);
		// colout3[ 23: 16] = col_mix_mu09(row1[31:24]) ^ col_mix_mu0e(row2[23:16]) ^ col_mix_mu0b(row3[15: 8]) ^ col_mix_mu0d(row4[ 7: 0]);
		// colout3[ 15:  8] = col_mix_mu0d(row1[31:24]) ^ col_mix_mu09(row2[23:16]) ^ col_mix_mu0e(row3[15: 8]) ^ col_mix_mu0b(row4[ 7: 0]);
		// colout3[  7:  0] = col_mix_mu0b(row1[31:24]) ^ col_mix_mu0d(row2[23:16]) ^ col_mix_mu09(row3[15: 8]) ^ col_mix_mu0e(row4[ 7: 0]);
		
		// colout4[ 31: 24] = col_mix_mu0e(row1[31:24]) ^ col_mix_mu0b(row2[23:16]) ^ col_mix_mu0d(row3[15: 8]) ^ col_mix_mu09(row4[ 7: 0]);
		// colout4[ 23: 16] = col_mix_mu09(row1[31:24]) ^ col_mix_mu0e(row2[23:16]) ^ col_mix_mu0b(row3[15: 8]) ^ col_mix_mu0d(row4[ 7: 0]);
		// colout4[ 15:  8] = col_mix_mu0d(row1[31:24]) ^ col_mix_mu09(row2[23:16]) ^ col_mix_mu0e(row3[15: 8]) ^ col_mix_mu0b(row4[ 7: 0]);
		// colout4[  7:  0] = col_mix_mu0b(row1[31:24]) ^ col_mix_mu0d(row2[23:16]) ^ col_mix_mu09(row3[15: 8]) ^ col_mix_mu0e(row4[ 7: 0]);
	end
	
	/*********function****************/
	
	function [7:0] col_mix_mul2(input [7:0] data);
		begin
			if(data[7])
				col_mix_mul2 = {data[6:0],1'b0} ^ 8'b0001_1011;
			else
				col_mix_mul2 = {data[6:0],1'b0};
		end
	endfunction
	
	
	function [7:0] col_mix_mu09(input [7:0] data);
		begin
			col_mix_mu09 = col_mix_mul2(col_mix_mul2(col_mix_mul2(data))) ^ data;
		end
	endfunction
	
	
	function [7:0] col_mix_mu0b(input [7:0] data);
		begin
			col_mix_mu0b = col_mix_mul2(col_mix_mul2(col_mix_mul2(data))) ^ col_mix_mul2(data) ^ data;
		end
	endfunction
	
	
	function [7:0] col_mix_mu0d(input [7:0] data);
		begin
			col_mix_mu0d = col_mix_mul2(col_mix_mul2(col_mix_mul2(data))) ^ col_mix_mul2(col_mix_mul2(data)) ^ data;
		end
	endfunction
	
	
	function [7:0] col_mix_mu0e(input [7:0] data);
		begin
			col_mix_mu0e = col_mix_mul2(col_mix_mul2(col_mix_mul2(data))) ^ col_mix_mul2(col_mix_mul2(data)) ^ col_mix_mul2(data);
		end
	endfunction

endmodule





		// colout1[ 31: 24] = col_mix_mu0e(row1[31:24]) ^ col_mix_mu0b(row2[31:24]) ^ col_mix_mu0d(row3[31:24]) ^ col_mix_mu09(row4[31:24]);
		// colout1[ 23: 16] = col_mix_mu09(row1[31:24]) ^ col_mix_mu0e(row2[31:24]) ^ col_mix_mu0b(row3[31:24]) ^ col_mix_mu0d(row4[31:24]);
		// colout1[ 15:  8] = col_mix_mu0d(row1[31:24]) ^ col_mix_mu09(row2[31:24]) ^ col_mix_mu0e(row3[31:24]) ^ col_mix_mu0b(row4[31:24]);
		// colout1[  7:  0] = col_mix_mu0b(row1[31:24]) ^ col_mix_mu0d(row2[31:24]) ^ col_mix_mu09(row3[31:24]) ^ col_mix_mu0e(row4[31:24]);
		
		// colout2[ 31: 24] = col_mix_mu0e(row1[23:16]) ^ col_mix_mu0b(row2[23:16]) ^ col_mix_mu0d(row3[23:16]) ^ col_mix_mu09(row4[23:16]);
		// colout2[ 23: 16] = col_mix_mu09(row1[23:16]) ^ col_mix_mu0e(row2[23:16]) ^ col_mix_mu0b(row3[23:16]) ^ col_mix_mu0d(row4[23:16]);
		// colout2[ 15:  8] = col_mix_mu0d(row1[23:16]) ^ col_mix_mu09(row2[23:16]) ^ col_mix_mu0e(row3[23:16]) ^ col_mix_mu0b(row4[23:16]);
		// colout2[  7:  0] = col_mix_mu0b(row1[23:16]) ^ col_mix_mu0d(row2[23:16]) ^ col_mix_mu09(row3[23:16]) ^ col_mix_mu0e(row4[23:16]);
		
		// colout3[ 31: 24] = col_mix_mu0e(row1[15: 8]) ^ col_mix_mu0b(row2[15: 8]) ^ col_mix_mu0d(row3[15: 8]) ^ col_mix_mu09(row4[15: 8]);
		// colout3[ 23: 16] = col_mix_mu09(row1[15: 8]) ^ col_mix_mu0e(row2[15: 8]) ^ col_mix_mu0b(row3[15: 8]) ^ col_mix_mu0d(row4[15: 8]);
		// colout3[ 15:  8] = col_mix_mu0d(row1[15: 8]) ^ col_mix_mu09(row2[15: 8]) ^ col_mix_mu0e(row3[15: 8]) ^ col_mix_mu0b(row4[15: 8]);
		// colout3[  7:  0] = col_mix_mu0b(row1[15: 8]) ^ col_mix_mu0d(row2[15: 8]) ^ col_mix_mu09(row3[15: 8]) ^ col_mix_mu0e(row4[15: 8]);
		
		// colout4[ 31: 24] = col_mix_mu0e(row1[ 7: 0]) ^ col_mix_mu0b(row2[ 7: 0]) ^ col_mix_mu0d(row3[ 7: 0]) ^ col_mix_mu09(row4[ 7: 0]);
		// colout4[ 23: 16] = col_mix_mu09(row1[ 7: 0]) ^ col_mix_mu0e(row2[ 7: 0]) ^ col_mix_mu0b(row3[ 7: 0]) ^ col_mix_mu0d(row4[ 7: 0]);
		// colout4[ 15:  8] = col_mix_mu0d(row1[ 7: 0]) ^ col_mix_mu09(row2[ 7: 0]) ^ col_mix_mu0e(row3[ 7: 0]) ^ col_mix_mu0b(row4[ 7: 0]);
		// colout4[  7:  0] = col_mix_mu0b(row1[ 7: 0]) ^ col_mix_mu0d(row2[ 7: 0]) ^ col_mix_mu09(row3[ 7: 0]) ^ col_mix_mu0e(row4[ 7: 0]);	




