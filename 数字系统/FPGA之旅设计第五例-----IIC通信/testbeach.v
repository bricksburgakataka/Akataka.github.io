`timescale 1ns/1ps

module testbench();

    reg  clk;
    reg  rst;
    wire  SDA;
    wire  SCL;
    reg IICWriteReq;
    reg IICReadReq;
    wire IICWriteDone;
    wire IICReadDone;
    always # 50 clk = ~clk;
    initial begin
        clk = 1'b1;
        rst = 1'b1;

        IICWriteReq = 1'b0;
        IICReadReq = 1'b1;
        #100   /*手动复位*/
        rst = 1'b0;
        #100
        rst = 1'b1;
    end
    
    always@(posedge clk)
        if(IICReadDone == 1'b1)   /*读完成后，readReq为0，只进行一次读写操作*/
            IICReadReq <= 1'b0;
        else
            IICReadReq <= IICReadReq;

IIC_Driver  IIC_DriverHP(
    .sys_clk            (clk),           /*系统时钟*/
    .rst_n              (rst),             /*系统复位*/

    .IICSCL             (SCL),            /*IIC 时钟输出*/
    .IICSDA             (SDA),             /*IIC 数据线*/

    .IICSlave           ('h1234),

    .IICWriteReq        (IICWriteReq),       /*IIC写寄存器请求*/
    .IICWriteDone        (IICWriteDone),      /*IIC写寄存器完成*/
    .IICWriteData        ('h5a),      /*IIC发送数据 8bit的从机地址 + 8bit的寄存器地址 + 8bit的数据(读忽略，后默认为0)*/

    .IICReadReq         (IICReadReq),        /*IIC读寄存器请求*/
    .IICReadDone        (IICReadDone),       /*IIC读寄存器完成*/
    .IICReadData        ()/*IIC读取地址*/
);

endmodule
