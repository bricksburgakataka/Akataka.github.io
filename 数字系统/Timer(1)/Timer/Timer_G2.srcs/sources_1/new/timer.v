module timer(
    input clk,          // 时钟信号
    input reset,        // 异步复位(高有效)
    input [3:0] setin_sec_ones,  // 设置值输入：秒的个位(0-9)
    input [3:0] setin_sec_tens,  // 设置值输入：秒的十位(0-5)
    input [3:0] setin_min_ones,  // 设置值输入：分的个位(0-9)
    input [3:0] setin_min_tens,  // 设置值输入：分的十位(0-5)
    input [3:0] setin_hour_ones, // 设置值输入：时的个位(0-9)
    input [3:0] setin_hour_tens, // 设置值输入：时的十位(0-2)
    input [3:0] setin_week,      // 设置值输入：星期（1-7）
    input set,          // 设置使能(高有效)   
    input EN,
    output reg [3:0] timer_sec_ones, // 计时器输出：秒的个位(0-9)
    output reg [3:0] timer_sec_tens, // 计时器输出：秒的十位(0-5)
    output reg [3:0] timer_min_ones, // 计时器输出：分的个位(0-9)
    output reg [3:0] timer_min_tens, // 计时器输出：分的十位(0-5)
    output reg [3:0] timer_hour_ones, // 计时器输出：时的个位(0-9)
    output reg [3:0] timer_hour_tens, // 计时器输出：时的十位(0-2)
    output reg [3:0] timer_week      // 输出当前星期（1-7）
);

always @(posedge clk or posedge reset) begin
    if (reset) begin
        // 异步复位
        timer_sec_ones <= 4'd0;
        timer_sec_tens <= 4'd0;
        timer_min_ones <= 4'd0;
        timer_min_tens <= 4'd0;
        timer_hour_ones <= 4'd0;
        timer_hour_tens <= 4'd0;
        timer_week <= 4'd1;
    end
    else if (set) begin
        // 设置模式
        timer_sec_ones <= setin_sec_ones;
        timer_sec_tens <= setin_sec_tens;
        timer_min_ones <= setin_min_ones;
        timer_min_tens <= setin_min_tens;
        timer_hour_ones <= setin_hour_ones;
        timer_hour_tens <= setin_hour_tens;
        timer_week <= setin_week;
    end
    else begin
        if (timer_sec_ones >= 4'd9) begin
            timer_sec_ones <= 4'd0;
            if (timer_sec_tens >= 4'd5) begin
                timer_sec_tens <= 4'd0;
                if (timer_min_ones >= 4'd9) begin
                    timer_min_ones <= 4'd0;
                    if (timer_min_tens >= 4'd5) begin
                        timer_min_tens <= 4'd0;
                        if ({timer_hour_tens, timer_hour_ones} >= 5'd23) begin
                            timer_hour_ones <= 4'd0;
                            timer_hour_tens <= 4'd0;
                        
                            // ===== 每过一天，星期递增 =====
                            if (timer_week == 4'd7) 
                                timer_week <= 4'd1;
                            else
                                timer_week <= timer_week + 1;
                            // =====
                            end else if (timer_hour_ones >= 4'd9) begin
                                 timer_hour_ones <= 4'd0;
                                 timer_hour_tens <= timer_hour_tens + 1;
                            end else begin
                                timer_hour_ones <= timer_hour_ones + 1;
                            end
                        end
                    else begin
                        timer_min_tens <= timer_min_tens + 1;
                    end
                end
                else if(EN) begin
                    timer_min_ones <= timer_min_ones + 1;
                end
            end
            else if(EN) begin
                timer_sec_tens <= timer_sec_tens + 1;
            end
        end
        else if(EN) begin
            timer_sec_ones <= timer_sec_ones + 1;
        end
    end
end
endmodule    
