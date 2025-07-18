`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/05/09 15:21:14
// Design Name: 
// Module Name: tb_Top_Timer_reverse
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////



`timescale 1ns / 1ps

module tb_Top_Timer_Reverse;

    // 信号声明
    reg clk;
    reg reset;
    reg ok;
    reg ok_long;
    reg up;
    reg down;
    reg left;
    reg right;
    wire [3:0] h1;
    wire [3:0] h0;
    wire [3:0] m1;
    wire [3:0] m0;
    wire [3:0] s1;
    wire [3:0] s0;

    // 实例化被测试模块
    Top_Timer_Reverse uut (
       .clk(clk),
       .reset(reset),
       .ok(ok),
       .ok_long(ok_long),
       .up(up),
       .down(down),
       .left(left),
       .right(right),
       .h1(h1),
       .h0(h0),
       .m1(m1),
       .m0(m0),
       .s1(s1),
       .s0(s0)
    );

    // 时钟生成
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // 时钟周期为10ns，每5ns翻转一次
    end

    // 测试激励
    initial begin
        // 初始化信号
        reset = 1;
        ok = 0;
        ok_long = 0;
        up = 0;
        down = 0;
        left = 0;
        right = 0;
        #20;

        // 释放复位
        reset = 0;
        #100;


        // 模拟按下Left按钮
        left = 1;
        #10;
        left = 0;
        #10;

 
        up = 1;
        #10;
        up = 0;
        #10;
        up = 1;
        #10;
        up = 0;
        #10;
        up = 1;
        #10;
        up = 0;
        #10;
        up = 1;
        #10;
        up = 0;
        #10;
        
        left = 1;
        #10;
        left = 0;
        #10;
           #10;
             up = 1;
             #10;
             up = 0;
             #10;
             up = 1;
             #10;
             up = 0;  
             #20;     
         ok = 1;
         #10;
         ok = 0;
         #50;
         ok = 1;
         #10;
         ok = 0;
          #50;
         ok = 1;
         #10;
         ok = 0;
               
    

        #1600;
      

        // 结束仿真
        $stop;
    end

endmodule