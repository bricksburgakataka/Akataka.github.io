





//OLED顶层模块
module OLED_Top(

	input			sys_clk,
	input			rst_n,

	
	
	//OLED IIC
	output		OLED_SCL,
	inout			OLED_SDA
	
);



localparam	OLED_INIT 		=  'd0;			//初始化
localparam  OLED_ShowFont	=	'd1;			//显示字符
localparam	OLED_IDLE 		=  'd2;			//空闲




reg[4:0]	state , next_state;


wire			IICWriteReq;
wire[23:0]  IICWriteData;
wire			IICWriteDone;

wire			init_finish;
wire[23:0]  Init_data;
wire 			init_req;

wire			showfont_finish;
wire[23:0]	showfont_data;
wire			showfont_req;


assign init_req     = (state == OLED_INIT) ? 1'b1 : 1'b0;
assign showfont_req = (state == OLED_ShowFont) ? 1'b1 : 1'b0;

always@(posedge sys_clk or negedge rst_n)
begin
	if(rst_n == 1'b0)
		state <= OLED_INIT;
	else
		state <= next_state;
end

always@(*)
begin
	case(state)
	OLED_INIT:
		if(init_finish == 1'b1)
			next_state <= OLED_ShowFont;
		else
			next_state <= OLED_INIT;
	OLED_ShowFont:
		if(showfont_finish == 1'b1)
			next_state <= OLED_IDLE;
		else
			next_state <= OLED_ShowFont;
	OLED_IDLE:
		next_state <= OLED_IDLE;

	default: next_state <= OLED_INIT;
	endcase
end





OLED_Init OLED_InitHP(
	
	.sys_clk				(sys_clk),
	.rst_n				(rst_n),
	
	.init_req			(init_req),				//初始化请求
	.write_done			(IICWriteDone),			//一组初始化数据完成信号
	
	.init_finish		(init_finish),			//初始化完成输出

	.Init_data			(Init_data)//初始化的数据
);

OLED_ShowFont OLED_ShowFont_HP(

	.sys_clk			(sys_clk),
	.rst_n			(rst_n),
	
	.ShowFont_req	(showfont_req),		 //字符显示请求
	.write_done		(IICWriteDone),			 //iic一组数据写完成
	
	.ShowFont_Data		(showfont_data),		 //字符显示数据
	
	.ShowFont_finish(showfont_finish)   //字符显示完成
);


//数据选择
OLED_SelData OLED_SelDataHP(
	
	.sys_clk			(sys_clk),
	.rst_n			(rst_n),
	
	
	.init_req		(init_req),
	.init_data		(Init_data),
	
	
		
	.showfont_req	(showfont_req),
	.showfont_data	(showfont_data),
	
	
	
	.IICWriteReq	(IICWriteReq),	
	.IICWriteData	(IICWriteData)
);



IIC_Driver IIC_DriverHP_OLED(
   .sys_clk				(sys_clk),           /*系统时钟*/
   .rst_n				(rst_n),             /*系统复位*/

    .IICSCL				(OLED_SCL),            /*IIC 时钟输出*/
    .IICSDA				(OLED_SDA),             /*IIC 数据线*/


    .IICSlave			({IICWriteData[15:8],IICWriteData[23:16]}),           /*从机 8bit的寄存器地址 + 8bit的从机地址*/

    .IICWriteReq		(IICWriteReq),       /*IIC写寄存器请求*/
    .IICWriteDone		(IICWriteDone),      /*IIC写寄存器完成*/
    .IICWriteData		(IICWriteData[7:0]),       /*IIC发送数据  8bit的数据*/

    .IICReadReq			(1'b0),        /*IIC读寄存器请求*/
    .IICReadDone			(),       /*IIC读寄存器完成*/
    .IICReadData    		()    /*IIC读取数据*/
);



endmodule 