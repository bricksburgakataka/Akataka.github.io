`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/05/12 10:00:34
// Design Name: 
// Module Name: tb_schedule
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


`timescale 1ns/1ps

module schedule_tb;

// 输入信号
reg clk;
reg reset;
reg [3:0] sh1, sh0, sm1, sm0;
reg [3:0] ss1, ss0;
reg [3:0] th1, th0, tm1, tm0;
reg set;

// 输出信号
wire timeeq;
wire [5:0] sche;

// 实例化被测模块
schedule uut (
    .clk(clk),
    .reset(reset),
    .sh1(sh1),
    .sh0(sh0),
    .sm1(sm1),
    .sm0(sm0),
    .ss1(ss1),
    .ss0(ss0),
    .th1(th1),
    .th0(th0),
    .tm1(tm1),
    .tm0(tm0),
    .set(set),
    .timeeq(timeeq),
    .sche(sche)
);

// 时钟生成（100MHz）
initial begin
    clk = 0;
    forever #5 clk = ~clk;
end

// 测试流程
initial begin
    // 初始化信号
    reset = 1;
    set = 0;
    {sh1, sh0, sm1, sm0} = 16'h0000;
    {ss1, ss0} = 2'b00;
    {th1, th0, tm1, tm0} = 16'h0000;
    
    // 复位释放（20ns后）
    #20 reset = 0;
    
    // 测试用例1：写入寄存器0（12:34）
    #10;
    set = 1;
    {sh1, sh0, sm1, sm0} = 16'h1234; // 12:34
    {ss1, ss0} = 2'b00;              // 选择寄存器0
    #10;
    set = 0;
    
    // 测试用例2：写入寄存器1（09:30）
    #20;
    set = 1;
    {sh1, sh0, sm1, sm0} = 16'h0930; // 09:30
    {ss1, ss0} = 2'b01;              // 选择寄存器1
    #10;
    set = 0;
    
    // 测试用例3：比较匹配测试（12:34）
    #20;
    {th1, th0, tm1, tm0} = 16'h1234; // 比较12:34
    
    // 测试用例4：比较不匹配测试（11:11）
    #20;
    {th1, th0, tm1, tm0} = 16'h1111; // 比较11:11
    
    // 测试用例5：比较匹配测试（09:30）
    #20;
    {th1, th0, tm1, tm0} = 16'h0930; // 比较09:30
    
    // 测试用例6：写入寄存器59（23:59）
    #20;
    set = 1;
    {sh1, sh0, sm1, sm0} = 16'h2359; // 23:59
    {ss1, ss0} = 6'h59;              // 选择寄存器59
    #10;
    set = 0;
    
    // 测试用例7：比较匹配测试（23:59）
    #20;
    {th1, th0, tm1, tm0} = 16'h2359; // 比较23:59
    
    // 结束仿真
    #50 $finish;
end

// 结果监控
initial begin
    $display("====================================================================");
    $display("Time(ns) | Operation           | Compare Time | Match | Reg");
    $display("--------------------------------------------------------------------");
    forever begin
        #5; // 同步采样
        if ($time >= 20) begin // 跳过复位阶段
            $write("%8t | ", $time);
            
            // 显示写入操作
            if (set) begin
                $write("WR: %d%d:%d%d -> Reg[%2d]", 
                      sh1, sh0, sm1, sm0, {ss1,ss0});
            end else begin
                $write("                    ");
            end
            
            // 显示比较结果
            $write(" | %d%d:%d%d | %b (%2d)", 
                  th1, th0, tm1, tm0, timeeq, sche);
            
            // 换行
            $display("");
        end
    end
end

endmodule
