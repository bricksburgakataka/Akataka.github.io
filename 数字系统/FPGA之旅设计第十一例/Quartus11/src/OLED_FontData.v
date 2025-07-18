




module OLED_FontData(
	
	input			sys_clk,
	input			rst_n,
	
	input[5:0]	index,
	
	output[7:0]	data
);


reg[7:0] data1[16:0];

assign data = data1[index];



always@(posedge sys_clk or negedge rst_n)
begin
	if(rst_n == 1'b0)
	begin
		 data1[0] = 8'h00;
		 data1[1] = 8'h40;
		 data1[2] = 8'h64;
		 data1[3] = 8'h1C;
		 data1[4] = 8'h8A;
		 data1[5] = 8'h6C;
		 data1[6] = 8'h1C;
		 data1[7] = 8'h04;
		 data1[8] = 8'hFC;
		 data1[9] = 8'h8A;
		 data1[10] = 8'h5C;
		 data1[11] = 8'h64;
		 data1[12] = 8'h54;
		 data1[13] = 8'h54;
		 data1[14] = 8'h10;
		 data1[15] = 8'h00;

	end
end




endmodule 