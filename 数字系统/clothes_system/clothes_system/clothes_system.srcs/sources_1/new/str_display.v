`timescale 1ns / 1ps
//数码管显示模块
module str_display(
    input clk,
    input reset,
    input [3:0] di7,  
    input [3:0] di6,
    input [3:0] di5,
    input [3:0] di4,
    input [3:0] di3,
    input [3:0] di2,
    input [3:0] di1,
    input [3:0] di0, 
    output [3:0] an1, 
    output [3:0] an0, 
    output a1,b1,c1,d1,e1,f1,g1, 
    output a0,b0,c0,d0,e0,f0,g0  
);
    display display_high(
        .clk(clk),
        .reset(reset),  
        .in3(di7),
        .in2(di6),
        .in1(di5),
        .in0(di4),
        .an(an1),
        .a(a1),.b(b1),.c(c1),.d(d1),.e(e1),.f(f1),.g(g1)
    );
    
    display display_low(
        .clk(clk),
        .reset(reset),  
        .in3(di3),
        .in2(di2),
        .in1(di1),
        .in0(di0),
        .an(an0),
        .a(a0),.b(b0),.c(c0),.d(d0),.e(e0),.f(f0),.g(g0)
    );
endmodule