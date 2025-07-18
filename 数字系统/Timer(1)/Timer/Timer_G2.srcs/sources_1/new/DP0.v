module DP0(
    input clk,reset,up, down, left, right, setEN, sEN,displayMUX,      
    
    output timeout,          
    output [3:0] h1,       
    output [3:0] h0,      
    output [3:0] m1,     
    output [3:0] m0,       
    output [3:0] s1,        
    output [3:0] s0       
);
    wire [3:0] sh1, sh0, sm1, sm0, ss1, ss0;  // 设置时间�?
    wire [3:0] th1, th0, tm1, tm0, ts1, ts0;  // 倒计时时间�??

    // 时间设置模块实例�?
    Set_timer set0 (
        .clk       (clk),       // 时钟输入
        .reset     (reset),     // 复位输入
        .up        (up),        // 向上调整
        .down      (down),      // 向下调整
        .left      (left),      // 向左选择
        .right     (right),     // 向右选择
        .h1        (sh1),       // 小时十位输出
        .h0        (sh0),       // 小时个位输出
        .m1        (sm1),       // 分钟十位输出
        .m0        (sm0),       // 分钟个位输出
        .s1        (ss1),       // 秒十位输�?
        .s0        (ss0)        // 秒个位输�?
    );

    // 倒计时模块实例化
    timer_reverse timrev (
        .clk               (clk),               // 时钟输入
        .reset             (reset),             // 复位输入
        .set               (setEN),             // 设置使能
        .EN                (sEN),               // 计数使能
        .timeout           (timeout),           // 超时输出
        .setin_hour_tens   (sh1),               // 设置的小时十�?
        .setin_hour_ones   (sh0),               // 设置的小时个�?
        .setin_min_tens    (sm1),               // 设置的分钟十�?
        .setin_min_ones    (sm0),               // 设置的分钟个�?
        .setin_sec_tens    (ss1),               // 设置的秒十位
        .setin_sec_ones    (ss0),               // 设置的秒个位
        .timer_hour_tens   (th1),               // 计时的小时十�?
        .timer_hour_ones   (th0),               // 计时的小时个�?
        .timer_min_tens    (tm1),               // 计时的分钟十�?
        .timer_min_ones    (tm0),               // 计时的分钟个�?
        .timer_sec_tens    (ts1),               // 计时的秒十位
        .timer_sec_ones    (ts0)                // 计时的秒个位
    );

    // 数码管显示多路�?�择�?
    MUX mux5 (
        .in0       (th1),       // 计时小时十位
        .in1       (sh1),       // 设置小时十位
        .S         (displayMUX),// 显示选择
        .out       (h1)         // 输出到数码管
    );
    
    MUX mux4 (
        .in0       (th0),       // 计时小时个位
        .in1       (sh0),       // 设置小时个位
        .S         (displayMUX),// 显示选择
        .out       (h0)         // 输出到数码管
    );
    
    MUX mux3 (
        .in0       (tm1),       // 计时分钟十位
        .in1       (sm1),       // 设置分钟十位
        .S         (displayMUX),// 显示选择
        .out       (m1)         // 输出到数码管
    );
    
    MUX mux2 (
        .in0       (tm0),       // 计时分钟个位
        .in1       (sm0),       // 设置分钟个位
        .S         (displayMUX),// 显示选择
        .out       (m0)         // 输出到数码管
    );
    
    MUX mux1 (
        .in0       (ts1),       // 计时秒十�?
        .in1       (ss1),       // 设置秒十�?
        .S         (displayMUX),// 显示选择
        .out       (s1)         // 输出到数码管
    );
    
    MUX mux0 (
        .in0       (ts0),       // 计时秒个�?
        .in1       (ss0),       // 设置秒个�?
        .S         (displayMUX),// 显示选择
        .out       (s0)         // 输出到数码管
    );
endmodule