module Set_timer(
    input clk,          // 时钟信号
    input reset,        // 异步复位
    input up,           // 增加当前位值
    input down,         // 减少当前位值
    input left,         // 向左移动选择位
    input right,        // 向右移动选择位
    output reg [3:0] h1, // 小时十位(0-2)
    output reg [3:0] h0, // 小时个位(0-9, 当h1=2时0-3)
    output reg [3:0] m1, // 分钟十位(0-5)
    output reg [3:0] m0, // 分钟个位(0-9)
    output reg [3:0] s1, // 秒钟十位(0-5)
    output reg [3:0] s0, // 秒钟个位(0-9)
    output reg [3:0] week,//星期值(1-7)
    output reg [2:0] sel // 选择位(0-6对应s0到h1到week )
);

// 选择位移动逻辑
always @(posedge clk or posedge reset) begin
    if (reset) begin
        sel <= 3'd0;  // 默认选择秒个位
    end
    else begin
        if (left) begin
            sel <= (sel == 3'd6) ? 3'd0 : sel + 1;
        end
        else if (right) begin
            sel <= (sel == 3'd0) ? 3'd6 : sel - 1;
        end
    end
end

// 数值调整逻辑
always @(posedge clk or posedge reset) begin
    if (reset) begin
        // 复位时设置为00:00:00
        h1 <= 4'd0;
        h0 <= 4'd0;
        m1 <= 4'd0;
        m0 <= 4'd0;
        s1 <= 4'd0;
        s0 <= 4'd0;
        week <= 4'd1; //默认星期一
    end
    else begin
        case (sel)
            3'd0: begin // 秒个位(s0)
                if (up) s0 <= (s0 == 4'd9) ? 4'd0 : s0 + 1;
                if (down) s0 <= (s0 == 4'd0) ? 4'd9 : s0 - 1;
            end
            3'd1: begin // 秒十位(s1)
                if (up) s1 <= (s1 == 4'd5) ? 4'd0 : s1 + 1;
                if (down) s1 <= (s1 == 4'd0) ? 4'd5 : s1 - 1;
            end
            3'd2: begin // 分个位(m0)
                if (up) m0 <= (m0 == 4'd9) ? 4'd0 : m0 + 1;
                if (down) m0 <= (m0 == 4'd0) ? 4'd9 : m0 - 1;
            end
            3'd3: begin // 分十位(m1)
                if (up) m1 <= (m1 == 4'd5) ? 4'd0 : m1 + 1;
                if (down) m1 <= (m1 == 4'd0) ? 4'd5 : m1 - 1;
            end
            3'd4: begin // 时个位(h0)
                if (up) h0 <= ((h1 == 4'd2 && h0 == 4'd3) || h0 == 4'd9) ? 4'd0 : h0 + 1;
                if (down) h0 <= (h0 == 4'd0) ? ((h1 == 4'd2) ? 4'd3 : 4'd9) : h0 - 1;
            end
            3'd5: begin // 时十位(h1)
                if (up) h1 <= (h1 == 4'd2) ? 4'd0 : h1 + 1;
                if (down) h1 <= (h1 == 4'd0) ? 4'd2 : h1 - 1;
            end
            3'd6: begin // 星期(week: 1-7)
                if (up) week <= (week == 4'd7) ? 4'd1 : week + 1;
                if (down) week <= (week == 4'd1) ? 4'd7 : week - 1;
            end
        endcase
        if (week < 4'd1 || week > 4'd7) begin
            week <= 4'd1;    
        end
    end
end
endmodule
