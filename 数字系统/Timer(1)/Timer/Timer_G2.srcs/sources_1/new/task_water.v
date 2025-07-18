module task_water(
    input clk,                // 系统时钟
    input reset,              // 异步复位
    input ok,                 // 短按OK按钮
    input ok_long,            // 长按OK按钮
    input up,                 // 上调按钮
    input down,               // 下调按钮
    input left,               // 左选择按钮
    input right,              // 右选择按钮
    input silent_mode,        // 静音模式开关
    output remind,            // 浇花提醒信号（高电平表示提醒）
    output [3:0] an1,         // 高位数码管位选（用于显示星期）
    output [3:0] an0,         // 低位数码管位选（显示数字）
    output a1,b1,c1,d1,e1,f1,g1, // 高位段选
    output a0,b0,c0,d0,e0,f0,g0  // 低位段选
);

    // 按钮脉冲信号
    wire ok_pulse, ok_long_pulse;
    wire up_pulse, down_pulse, left_pulse, right_pulse;
    wire reset_pulse, silent_mode_pulse;

    // 实例化 pulse_on_button（对所有按钮去抖 + 单脉冲）
    pulse_on_button pb_ok        (.clk(clk), .reset(1'b0), .noisy(ok),         .pulse(ok_pulse));
    pulse_on_button pb_oklong    (.clk(clk), .reset(1'b0), .noisy(ok_long),    .pulse(ok_long_pulse));
    pulse_on_button pb_up        (.clk(clk), .reset(1'b0), .noisy(up),         .pulse(up_pulse));
    pulse_on_button pb_down      (.clk(clk), .reset(1'b0), .noisy(down),       .pulse(down_pulse));
    pulse_on_button pb_left      (.clk(clk), .reset(1'b0), .noisy(left),       .pulse(left_pulse));
    pulse_on_button pb_right     (.clk(clk), .reset(1'b0), .noisy(right),      .pulse(right_pulse));
    pulse_on_button pb_reset     (.clk(clk), .reset(1'b0), .noisy(reset),      .pulse(reset_pulse));
    pulse_on_button pb_silent    (.clk(clk), .reset(1'b0), .noisy(silent_mode),.pulse(silent_mode_pulse));

    // 内部信号：时间/星期
    wire [3:0] h1, h0, m1, m0, s1, s0, week;
    wire remind_water;
    wire clk_1s;
    
    clk_1Hz clkdiv_inst(
        .clk(clk),      //100MHZ输入
        .reset(reset_pulse),
        .clk_1s(clk_1s) //1HZ输出
    );
    // 实例化主时钟（设置+显示+星期）
    Top_Timer timer_inst(
        .clk(clk),
        .reset(reset_pulse),
        .ok(ok_pulse),
        .ok_long(ok_long_pulse),
        .up(up_pulse),
        .down(down_pulse),
        .left(left_pulse),
        .right(right_pulse),
        .h1(h1),
        .h0(h0),
        .m1(m1),
        .m0(m0),
        .s1(s1),
        .s0(s0),
        .week(week),
        .an1(an1),
        .an0(an0),
        .a1(a1),.b1(b1),.c1(c1),.d1(d1),.e1(e1),.f1(f1),.g1(g1),
        .a0(a0),.b0(b0),.c0(c0),.d0(d0),.e0(e0),.f0(f0),.g0(g0)
    );

    // 每周日10:00:00提醒逻辑
    water_reminder water_remind_inst(
        .clk_1s(clk_1s),
        .reset(reset_pulse),
        .week(week),
        .h1(h1),
        .h0(h0),
        .m1(m1),
        .m0(m0),
        .s1(s1),
        .s0(s0),
        .remind_trigger(remind_water)
    );

    // 提醒控制模块（考虑静音）
    Alarm_Controller remind_ctrl (
        .clk_1s(clk_1s),
        .reset(reset_pulse),
        .trigger(remind_water),
        .silent_mode(silent_mode_pulse),
        .alarm(remind)
    );

endmodule


