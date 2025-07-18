`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/05/07 23:03:29
// Design Name: 
// Module Name: tb_set_timer
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


module Set_timer_tb;

// �����ź�
reg clk;
reg reset;
reg up;
reg down;
reg left;
reg right;

// ����ź�
wire [3:0] h1;
wire [3:0] h0;
wire [3:0] m1;
wire [3:0] m0;
wire [3:0] s1;
wire [3:0] s0;
wire [2:0] sel;

// ʵ��������ģ��
Set_timer uut (
    .clk(clk),
    .reset(reset),
    .up(up),
    .down(down),
    .left(left),
    .right(right),
    .h1(h1),
    .h0(h0),
    .m1(m1),
    .m0(m0),
    .s1(s1),
    .s0(s0),
    .sel(sel)
);

// ʱ������ (100MHz)
initial begin
    clk = 0;
    forever #5 clk = ~clk; // 10ns����
end


// ����������
initial begin
    // ��ʼ������
    reset = 0;
    up = 0;
    down = 0;
    left = 0;
    right = 0;
    
    reset = 1;
    #20;
    reset = 0;
    #10
    up=1;
    #10
    up=0;
    #10
    up=1;
    #10
    up=0;
        #10
    up=1;
    #10
    up=0;
        #10
    up=1;
    #10
    up=0;
        #10
    up=1;
    #10
    up=0;
        #10
    up=1;
    #10
    up=0;
        #10
    up=1;
    #10
    up=0;
        #10
    up=1;
    #10
    up=0;
        #10
    up=1;
    #10
    up=0;
        #10
    up=1;
    #10
    up=0;
        #10
    up=1;
    #10
    up=0;
        #10
    up=1;
    #10
    up=0;
        #10
    up=1;
    #10
    up=0;
    #10
    left=1;
    #10
    left=0;    
    #10
    down=1;
    #10
    down=0;
    #10
    down=1;
    #10
    down=0;    
    #10
    down=1;
    #10
    down=0;
    #10
    right=1;
    #10
    right=0;
    #10
    right=1;
    #10
    right=0;
        #10
    right=1;
    #10
    right=0;
    #10
        down=1;
        #10
        down=0;    
        #10
        down=1;
        #10
        down=0;
        #10
            down=1;
            #10
            down=0;    
            #10
            down=1;
            #10
            down=0;
    #10
                left=1;
                #10
                left=0;    
                #10
           down=1;
                #10
                down=0;    
                #10
                down=1;
                #10
                down=0;
                #10
                    down=1;
                    #10
                    down=0;    
                    #10
                    down=1;
                    #10
                    down=0;             
        end
 
endmodule

