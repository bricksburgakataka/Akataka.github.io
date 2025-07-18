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

    // �ź�����
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

    // ʵ����������ģ��
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

    // ʱ������
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // ʱ������Ϊ10ns��ÿ5ns��תһ��
    end

    // ���Լ���
    initial begin
        // ��ʼ���ź�
        reset = 1;
        ok = 0;
        ok_long = 0;
        up = 0;
        down = 0;
        left = 0;
        right = 0;
        #20;

        // �ͷŸ�λ
        reset = 0;
        #100;


        // ģ�ⰴ��Left��ť
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
      

        // ��������
        $stop;
    end

endmodule