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

// �����ź�
reg clk;
reg reset;
reg [3:0] sh1, sh0, sm1, sm0;
reg [3:0] ss1, ss0;
reg [3:0] th1, th0, tm1, tm0;
reg set;

// ����ź�
wire timeeq;
wire [5:0] sche;

// ʵ��������ģ��
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

// ʱ�����ɣ�100MHz��
initial begin
    clk = 0;
    forever #5 clk = ~clk;
end

// ��������
initial begin
    // ��ʼ���ź�
    reset = 1;
    set = 0;
    {sh1, sh0, sm1, sm0} = 16'h0000;
    {ss1, ss0} = 2'b00;
    {th1, th0, tm1, tm0} = 16'h0000;
    
    // ��λ�ͷţ�20ns��
    #20 reset = 0;
    
    // ��������1��д��Ĵ���0��12:34��
    #10;
    set = 1;
    {sh1, sh0, sm1, sm0} = 16'h1234; // 12:34
    {ss1, ss0} = 2'b00;              // ѡ��Ĵ���0
    #10;
    set = 0;
    
    // ��������2��д��Ĵ���1��09:30��
    #20;
    set = 1;
    {sh1, sh0, sm1, sm0} = 16'h0930; // 09:30
    {ss1, ss0} = 2'b01;              // ѡ��Ĵ���1
    #10;
    set = 0;
    
    // ��������3���Ƚ�ƥ����ԣ�12:34��
    #20;
    {th1, th0, tm1, tm0} = 16'h1234; // �Ƚ�12:34
    
    // ��������4���Ƚϲ�ƥ����ԣ�11:11��
    #20;
    {th1, th0, tm1, tm0} = 16'h1111; // �Ƚ�11:11
    
    // ��������5���Ƚ�ƥ����ԣ�09:30��
    #20;
    {th1, th0, tm1, tm0} = 16'h0930; // �Ƚ�09:30
    
    // ��������6��д��Ĵ���59��23:59��
    #20;
    set = 1;
    {sh1, sh0, sm1, sm0} = 16'h2359; // 23:59
    {ss1, ss0} = 6'h59;              // ѡ��Ĵ���59
    #10;
    set = 0;
    
    // ��������7���Ƚ�ƥ����ԣ�23:59��
    #20;
    {th1, th0, tm1, tm0} = 16'h2359; // �Ƚ�23:59
    
    // ��������
    #50 $finish;
end

// ������
initial begin
    $display("====================================================================");
    $display("Time(ns) | Operation           | Compare Time | Match | Reg");
    $display("--------------------------------------------------------------------");
    forever begin
        #5; // ͬ������
        if ($time >= 20) begin // ������λ�׶�
            $write("%8t | ", $time);
            
            // ��ʾд�����
            if (set) begin
                $write("WR: %d%d:%d%d -> Reg[%2d]", 
                      sh1, sh0, sm1, sm0, {ss1,ss0});
            end else begin
                $write("                    ");
            end
            
            // ��ʾ�ȽϽ��
            $write(" | %d%d:%d%d | %b (%2d)", 
                  th1, th0, tm1, tm0, timeeq, sche);
            
            // ����
            $display("");
        end
    end
end

endmodule
