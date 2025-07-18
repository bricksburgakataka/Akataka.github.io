`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/05/07 22:56:10
// Design Name: 
// Module Name: tb_timer
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

module tb_timer;

    // 定义信号
    reg clk;
    reg reset;
    reg [3:0] setin_sec_ones;
    reg [3:0] setin_sec_tens;
    reg [3:0] setin_min_ones;
    reg [3:0] setin_min_tens;
    reg [3:0] setin_hour_ones;
    reg [3:0] setin_hour_tens;
    reg set;
    reg EN;
    wire [3:0] timer_sec_ones;
    wire [3:0] timer_sec_tens;
    wire [3:0] timer_min_ones;
    wire [3:0] timer_min_tens;
    wire [3:0] timer_hour_ones;
    wire [3:0] timer_hour_tens;

    // 实例化被测试模块
    timer uut (
       .clk(clk), 
       .reset(reset), 
       .setin_sec_ones(setin_sec_ones), 
       .setin_sec_tens(setin_sec_tens), 
       .setin_min_ones(setin_min_ones), 
       .setin_min_tens(setin_min_tens), 
       .setin_hour_ones(setin_hour_ones), 
       .setin_hour_tens(setin_hour_tens), 
       .set(set), 
       .EN(EN), 
       .timer_sec_ones(timer_sec_ones), 
       .timer_sec_tens(timer_sec_tens), 
       .timer_min_ones(timer_min_ones), 
       .timer_min_tens(timer_min_tens), 
       .timer_hour_ones(timer_hour_ones), 
       .timer_hour_tens(timer_hour_tens)
    );

    // 生成时钟信号
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // 10ns 周期的时钟信号
    end

    // 测试序列
    initial begin
        // 初始化信号
        reset = 1;
        setin_sec_ones = 4'd0;
        setin_sec_tens = 4'd0;
        setin_min_ones = 4'd0;
        setin_min_tens = 4'd0;
        setin_hour_ones = 4'd0;
        setin_hour_tens = 4'd0;
        set = 0;
        EN = 0;

        #20; // 保持复位一段时间
        reset = 0; // 释放复位

        // 设置时间
        set = 1;
        setin_sec_ones = 4'd8;
        setin_sec_tens = 4'd5;
        setin_min_ones = 4'd8;
        setin_min_tens = 4'd5;
        setin_hour_ones = 4'd0;
        setin_hour_tens = 4'd0;
        #20;
        set = 0;

        // 启动计时
        EN=1;
        #100;
        EN=0;
        #50;
        
        EN = 1;
        #600; // 运行一段时间

        $finish; // 结束仿真
    end

    // 监控输出
    initial begin
        $monitor("Time: %0t, timer_hour: %d%d, timer_min: %d%d, timer_sec: %d%d",
                 $time, timer_hour_tens, timer_hour_ones, timer_min_tens, timer_min_ones, timer_sec_tens, timer_sec_ones);
    end

endmodule    