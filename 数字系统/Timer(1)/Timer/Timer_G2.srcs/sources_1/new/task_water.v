module task_water(
    input clk,                // ϵͳʱ��
    input reset,              // �첽��λ
    input ok,                 // �̰�OK��ť
    input ok_long,            // ����OK��ť
    input up,                 // �ϵ���ť
    input down,               // �µ���ť
    input left,               // ��ѡ��ť
    input right,              // ��ѡ��ť
    input silent_mode,        // ����ģʽ����
    output remind,            // ���������źţ��ߵ�ƽ��ʾ���ѣ�
    output [3:0] an1,         // ��λ�����λѡ��������ʾ���ڣ�
    output [3:0] an0,         // ��λ�����λѡ����ʾ���֣�
    output a1,b1,c1,d1,e1,f1,g1, // ��λ��ѡ
    output a0,b0,c0,d0,e0,f0,g0  // ��λ��ѡ
);

    // ��ť�����ź�
    wire ok_pulse, ok_long_pulse;
    wire up_pulse, down_pulse, left_pulse, right_pulse;
    wire reset_pulse, silent_mode_pulse;

    // ʵ���� pulse_on_button�������а�ťȥ�� + �����壩
    pulse_on_button pb_ok        (.clk(clk), .reset(1'b0), .noisy(ok),         .pulse(ok_pulse));
    pulse_on_button pb_oklong    (.clk(clk), .reset(1'b0), .noisy(ok_long),    .pulse(ok_long_pulse));
    pulse_on_button pb_up        (.clk(clk), .reset(1'b0), .noisy(up),         .pulse(up_pulse));
    pulse_on_button pb_down      (.clk(clk), .reset(1'b0), .noisy(down),       .pulse(down_pulse));
    pulse_on_button pb_left      (.clk(clk), .reset(1'b0), .noisy(left),       .pulse(left_pulse));
    pulse_on_button pb_right     (.clk(clk), .reset(1'b0), .noisy(right),      .pulse(right_pulse));
    pulse_on_button pb_reset     (.clk(clk), .reset(1'b0), .noisy(reset),      .pulse(reset_pulse));
    pulse_on_button pb_silent    (.clk(clk), .reset(1'b0), .noisy(silent_mode),.pulse(silent_mode_pulse));

    // �ڲ��źţ�ʱ��/����
    wire [3:0] h1, h0, m1, m0, s1, s0, week;
    wire remind_water;
    wire clk_1s;
    
    clk_1Hz clkdiv_inst(
        .clk(clk),      //100MHZ����
        .reset(reset_pulse),
        .clk_1s(clk_1s) //1HZ���
    );
    // ʵ������ʱ�ӣ�����+��ʾ+���ڣ�
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

    // ÿ����10:00:00�����߼�
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

    // ���ѿ���ģ�飨���Ǿ�����
    Alarm_Controller remind_ctrl (
        .clk_1s(clk_1s),
        .reset(reset_pulse),
        .trigger(remind_water),
        .silent_mode(silent_mode_pulse),
        .alarm(remind)
    );

endmodule


