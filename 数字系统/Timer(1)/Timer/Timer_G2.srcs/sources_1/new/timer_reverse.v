module timer_reverse(
    input clk,          // 时钟信号
    input reset,        // 异步复位(高有效)
    input [3:0] setin_sec_ones,  // 设置值输入：秒的个位(0-9)
    input [3:0] setin_sec_tens,  // 设置值输入：秒的十位(0-5)
    input [3:0] setin_min_ones,  // 设置值输入：分的个位(0-9)
    input [3:0] setin_min_tens,  // 设置值输入：分的十位(0-5)
    input [3:0] setin_hour_ones, // 设置值输入：时的个位(0-9)
    input [3:0] setin_hour_tens, // 设置值输入：时的十位(0-2)
    input set,          // 设置使能(高有效)   
    input EN,
    output reg [3:0] timer_sec_ones, // 计时器输出：秒的个位(0-9)
    output reg [3:0] timer_sec_tens, // 计时器输出：秒的十位(0-5)
    output reg [3:0] timer_min_ones, // 计时器输出：分的个位(0-9)
    output reg [3:0] timer_min_tens, // 计时器输出：分的十位(0-5)
    output reg [3:0] timer_hour_ones, // 计时器输出：时的个位(0-9)
    output reg [3:0] timer_hour_tens, // 计时器输出：时的十位(0-2)
    output reg timeout
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
        timeout <= 1'b0;
    end
    else if (set) begin
        // 设置模式
        timer_sec_ones <= setin_sec_ones;
        timer_sec_tens <= setin_sec_tens;
        timer_min_ones <= setin_min_ones;
        timer_min_tens <= setin_min_tens;
        timer_hour_ones <= setin_hour_ones;
        timer_hour_tens <= setin_hour_tens;
        timeout <= 1'b0;
    end
    else if (EN && !timeout) begin
        // 倒计时逻辑
        if (timer_sec_ones > 0) begin
            timer_sec_ones <= timer_sec_ones - 1;
        end
        else begin
            if (timer_sec_tens > 0) begin
                timer_sec_tens <= timer_sec_tens - 1;
                timer_sec_ones <= 4'd9;
            end
            else begin
                timer_sec_ones <= 4'd9;
                timer_sec_tens <= 4'd5;
                
                if (timer_min_ones > 0) begin
                    timer_min_ones <= timer_min_ones - 1;
                end
                else begin
                    if (timer_min_tens > 0) begin
                        timer_min_tens <= timer_min_tens - 1;
                        timer_min_ones <= 4'd9;
                    end
                    else begin
                        timer_min_ones <= 4'd9;
                        timer_min_tens <= 4'd5;
                        
                        if (timer_hour_ones > 0) begin
                            timer_hour_ones <= timer_hour_ones - 1;
                        end
                        else begin
                            if (timer_hour_tens > 0) begin
                                timer_hour_tens <= timer_hour_tens - 1;
                                timer_hour_ones <= 4'd9;
                            end
                            else begin
                                // 所有时间都到0，触发超时
                                timeout <= 1'b1;
                                timer_sec_ones <= 4'd0;
                                timer_sec_tens <= 4'd0;
                                timer_min_ones <= 4'd0;
                                timer_min_tens <= 4'd0;
                                timer_hour_ones <= 4'd0;
                                timer_hour_tens <= 4'd0;
                            end
                        end
                    end
                end
            end
        end
    end
end
endmodule    
