`timescale 1ns / 1ps

module tb_task_water;

    // Inputs
    reg clk;
    reg reset;
    reg ok;
    reg ok_long;
    reg up;
    reg down;
    reg left;
    reg right;
    reg silent_mode;

    // Outputs
    wire remind;
    wire [3:0] an1, an0;
    wire a1, b1, c1, d1, e1, f1, g1;
    wire a0, b0, c0, d0, e0, f0, g0;

    // 实例化被测模块
    task_water uut (
        .clk(clk),
        .reset(reset),
        .ok(ok),
        .ok_long(ok_long),
        .up(up),
        .down(down),
        .left(left),
        .right(right),
        .silent_mode(silent_mode),
        .remind(remind),
        .an1(an1),
        .an0(an0),
        .a1(a1), .b1(b1), .c1(c1), .d1(d1), .e1(e1), .f1(f1), .g1(g1),
        .a0(a0), .b0(b0), .c0(c0), .d0(d0), .e0(e0), .f0(f0), .g0(g0)
    );

    // 模拟时钟
    always #5 clk = ~clk; // 100MHz 时钟

    // 模拟时间变量
    reg [3:0] h1, h0, m1, m0, s1, s0, week;
    integer i;

    initial begin
        // 初始值
        clk = 0;
        reset = 1;
        ok = 0;
        ok_long = 0;
        up = 0;
        down = 0;
        left = 0;
        right = 0;
        silent_mode = 0;

        #100;
        reset = 0;

        // 设置为周日 09:59:30
        week = 4'd7;
        h1 = 4'd0; h0 = 4'd9;
        m1 = 4'd5; m0 = 4'd9;
        s1 = 4'd3; s0 = 4'd0;

        // 强制写入时间
        force uut.timer_inst.week = week;
        force uut.timer_inst.h1 = h1;
        force uut.timer_inst.h0 = h0;
        force uut.timer_inst.m1 = m1;
        force uut.timer_inst.m0 = m0;
        force uut.timer_inst.s1 = s1;
        force uut.timer_inst.s0 = s0;

        // 模拟 40 秒，让它跨过 10:00:00
        for (i = 0; i < 40; i = i + 1) begin
            #100_000_000; // 1秒

            // 秒数加一
            s0 = s0 + 1;
            if (s0 == 10) begin
                s0 = 0; s1 = s1 + 1;
                if (s1 == 6) begin
                    s1 = 0; m0 = m0 + 1;
                    if (m0 == 10) begin
                        m0 = 0; m1 = m1 + 1;
                        if (m1 == 6) begin
                            m1 = 0; h0 = h0 + 1;
                            if (h0 == 10) begin
                                h0 = 0; h1 = h1 + 1;
                            end
                        end
                    end
                end
            end

            // 更新强制时间
            force uut.timer_inst.h1 = h1;
            force uut.timer_inst.h0 = h0;
            force uut.timer_inst.m1 = m1;
            force uut.timer_inst.m0 = m0;
            force uut.timer_inst.s1 = s1;
            force uut.timer_inst.s0 = s0;

            // 打印当前时间和提醒状态
            $display("Time: %d%d:%d%d:%d%d Week: %d | Remind: %b", 
                     h1, h0, m1, m0, s1, s0, week, remind);
        end

        #100_000_000;
        $finish;
    end

endmodule


