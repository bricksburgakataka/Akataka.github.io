






module OLED_ShowFont(

	input				sys_clk,
	input				rst_n,
	
	input				ShowFont_req,		 //字符显示请求
	input				write_done,			 //iic一组数据写完成
	
	output[23:0]	ShowFont_Data,		 //字符显示数据
	
	output			ShowFont_finish   //字符显示完成
);

reg[5:0]	showfont_index;
reg[23:0]	showfont_data_reg;

wire[7:0]	fontdata;

assign ShowFont_finish = (showfont_index == 'd18 && write_done == 1'b1) ? 1'b1 : 1'b0;
assign ShowFont_Data = showfont_data_reg;

always@(posedge sys_clk or negedge rst_n)
begin
	if(rst_n == 1'b0)
		showfont_index <= 'd0;
	else if(ShowFont_finish == 1'b1)
		showfont_index <= 'd0;
	else if(write_done == 1'b1 && ShowFont_req == 1'b1)
		showfont_index <= showfont_index + 1'b1;
	else
		showfont_index <= showfont_index;

end
always@(*)
begin
	case(showfont_index)
	'd0:	showfont_data_reg <= {8'h78,8'h00,8'hB0 + 8'h03};
	'd1:  showfont_data_reg <= {8'h78,8'h00,8'h00 + 8'h02};
	'd2:  showfont_data_reg <= {8'h78,8'h00,8'h10 + 8'h02};
	default:	showfont_data_reg <= {8'h78,8'h40,fontdata}; //fontdata
	endcase
end

OLED_FontData OLED_FontData_HP(
	
	.sys_clk			(sys_clk),
	.rst_n			(rst_n),
	.index			(showfont_index - 'd3),
	.data				(fontdata)
);


endmodule 