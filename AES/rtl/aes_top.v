

module aes_top(
	input			sys_clk			,
	input			sys_rst			,
	input			en_start		,
	input			de_start		,
	input			out_en			,
	
	input	[127:0]	text_in	,
	
	output	reg [127:0]	text_out
);
	//密文
	wire	[127:0]	ciphertex	;
	//解密后的明文
	wire	[127:0]	plaintext	;
	
	
	//输出使能拉高输出明文,否则输出密文;
	//用always块是为了同步于时钟
	always@(posedge sys_clk) begin
		if(out_en)
			text_out <= ciphertex;
		else
			text_out <= plaintext;
	end
	
	aes_encryption aes_encryption(
		.clk			(sys_clk			),
		.rst			(sys_rst			),
		.plaintext	    (text_in		   	),
		.en_start	    (en_start	    	),
		
		.ciphertext_o   (ciphertex   		)
	);
	
	aes_decryption aes_decryption(
		.clk			(sys_clk			),
		.rst		    (sys_rst			),
		.de_start       (de_start			),
		.ciphertext	    (ciphertex		   	),
		
		.plaintext	    (plaintext  	 	)
	);
	
	
	
endmodule










