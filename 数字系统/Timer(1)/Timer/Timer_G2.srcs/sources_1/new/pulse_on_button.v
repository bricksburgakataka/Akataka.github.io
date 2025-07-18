module pulse_on_button (
    input clk,
    input reset,
    input noisy,         // 原始抖动按钮信号
    output pulse         // 每次按下输出一个时钟周期脉冲
);
    wire clean;          // 去抖动后的按钮状态
    reg clean_dly;       // 上一个时钟周期的按钮状态

    // 去抖动处理
    debounce db_inst (
        .clk(clk),
        .reset(reset),
        .noisy(noisy),
        .clean(clean)
    );

    // 边沿检测：上升沿（从0变1）时输出1周期脉冲
    always @(posedge clk or posedge reset) begin
        if (reset)
            clean_dly <= 0;
        else
            clean_dly <= clean;
    end

    assign pulse = (clean == 1 && clean_dly == 0);  // 上升沿检测

endmodule
