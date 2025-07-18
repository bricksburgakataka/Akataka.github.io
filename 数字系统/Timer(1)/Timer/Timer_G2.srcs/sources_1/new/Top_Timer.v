module Top_Timer(
    input clk, reset, ok, ok_long, up, down, left, right,          
    output [3:0] h1,      
    output [3:0] h0,      
    output [3:0] m1,       
    output [3:0] m0,   
    output [3:0] s1,       
    output [3:0] s0,
    output [3:0] week,
    output [3:0] an1,         // 高4位数码管位选
    output [3:0] an0,         // 低4位数码管位选
    output a1,b1,c1,d1,e1,f1,g1, // 高4位数码管段选
    output a0,b0,c0,d0,e0,f0,g0  // 低4位数码管段选
);
    wire setEN;          
    wire displayMUX;
    wire clk_1s;        
    wire [3:0] disp_h1, disp_h0, disp_m1, disp_m0, disp_week;
    
    clk_1Hz clkdiv_inst(
        .clk(clk),      //100MHZ输入
        .reset(reset),
        .clk_1s(clk_1s) //1HZ输出
    );
         
    FSM1 fsm1 (
        .clk(clk),
        .reset(reset),
        .ok(ok),
        .ok_long(ok_long),
        .setEN(setEN),
        .displayMUX(displayMUX)
    );

    DP1 dp1 (
        .clk(clk),
        .clk_1s(clk_1s),
        .reset(reset),
        .up(up),
        .down(down),
        .left(left),
        .right(right),
        .setEN(setEN),
        .displayMUX(displayMUX),
        .h1(h1),
        .h0(h0),
        .m1(m1),
        .m0(m0),
        .s1(s1),
        .s0(s0),
        .week(week)
    );
    // 显示选择逻辑（隐藏秒显示）
    assign disp_h1 = h1; 
    assign disp_h0 = h0;
    assign disp_m1 = m1;
    assign disp_m0 = m0;
    assign disp_week = week;
    
    // 实例化数码管显示模块（最后两位保持熄灭）
    str_display display (
        .clk(clk),
        .reset(reset),
        .di7(disp_m0),  // 分钟个位 (最右的数码管）
        .di6(disp_m1),  // 分钟十位
        .di5(4'b0000),  // 空
        .di4(disp_h0),  // 小时个位
        .di3(disp_h1),  // 小时十位
        .di2(4'b0000),  // 空
        .di1(4'b0000),  // 空
        .di0(disp_week),  // 星期（最左的数码管）
        .an1(an1),
        .an0(an0),
        .a1(a1),.b1(b1),.c1(c1),.d1(d1),.e1(e1),.f1(f1),.g1(g1),
        .a0(a0),.b0(b0),.c0(c0),.d0(d0),.e0(e0),.f0(f0),.g0(g0)
    );
endmodule

