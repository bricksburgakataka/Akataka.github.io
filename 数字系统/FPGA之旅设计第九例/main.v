







//顶层模块
module main(

	input			sys_clk,
	input			rst_n,
	
	
	

	//OLED IIC
	output		OLED_SCL,
	inout			OLED_SDA
);






OLED_Top OLED_TopHP(

	.sys_clk		(sys_clk),
	.rst_n		(rst_n),

	
	
	
		//OLED IIC
	.OLED_SCL	(OLED_SCL),
	.OLED_SDA	(OLED_SDA)
);











endmodule 