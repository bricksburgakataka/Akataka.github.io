module main(
    input       sys_clk,      // 系统时钟(50MHz)
    input       rst_n,        // 低电平复位
    inout       dht11,        // DHT11数据线
    output reg [7:0] TempH,   // 温度整数部分
    output reg [7:0] TempL,   // 温度小数部分
    output reg [7:0] HumidH,  // 湿度整数部分
    output reg [7:0] HumidL   // 湿度小数部分
);

    // DHT11接口信号
    wire done;                // 数据采集完成标志
    wire [7:0] TempH0;       // 温度整数(原始)
    wire [7:0] TempL0;       // 温度小数(原始)
    wire [7:0] HumidH0;      // 湿度整数(原始)
    wire [7:0] HumidL0;      // 湿度小数(原始)
    
    // 采集控制信号
    reg dht11_req;           // 采集请求信号
    reg [30:0] sample_timer; // 采样间隔计数器(约1秒).原:23；现：30（约2s）

    // DHT11驱动模块实例化
    DHT11 DHT11_HP(
        .sys_clk      (sys_clk),
        .rst_n        (rst_n),
        .dht11_req    (dht11_req),
        .dht11_done   (done),
        .dht11_error  (),      // 错误信号(未使用)
        .tempH        (TempH0),
        .tempL        (TempL0),
        .humidityH    (HumidH0),
        .humidityL    (HumidL0),
        .dht11        (dht11)
    );

    // 采样间隔控制(约1秒一次)
    always @(posedge sys_clk or negedge rst_n) begin
        if (!rst_n) begin
            sample_timer <= 30'd0; //原：24
            dht11_req <= 1'b0;
        end else begin
            // 50MHz时钟下，50,000,000个周期=1秒；100MHZ
            if (sample_timer == 30'd100_000_000) begin 
                dht11_req <= 1'b1;      // 发出采集请求
                sample_timer <= 30'd0;   // 重置计数器
            end else begin
                dht11_req <= 1'b0;       // 保持低电平
                sample_timer <= sample_timer + 1'b1; // 计数器递增
            end
        end
    end

    // 数据锁存逻辑
    always @(posedge sys_clk or negedge rst_n) begin
        if (!rst_n) begin
            // 复位时清零
            TempH <= 8'd0;
            TempL <= 8'd0;
            HumidH <= 8'd0;
            HumidL <= 8'd0;
        end else if (done) begin
            // 采集完成时更新数据
            TempH <= TempH0;
            TempL <= TempL0;
            HumidH <= HumidH0;
            HumidL <= HumidL0;
        end
    end

endmodule