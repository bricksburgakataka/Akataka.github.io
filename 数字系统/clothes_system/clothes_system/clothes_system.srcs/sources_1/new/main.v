module main(
    input       sys_clk,      // ϵͳʱ��(50MHz)
    input       rst_n,        // �͵�ƽ��λ
    inout       dht11,        // DHT11������
    output reg [7:0] TempH,   // �¶���������
    output reg [7:0] TempL,   // �¶�С������
    output reg [7:0] HumidH,  // ʪ����������
    output reg [7:0] HumidL   // ʪ��С������
);

    // DHT11�ӿ��ź�
    wire done;                // ���ݲɼ���ɱ�־
    wire [7:0] TempH0;       // �¶�����(ԭʼ)
    wire [7:0] TempL0;       // �¶�С��(ԭʼ)
    wire [7:0] HumidH0;      // ʪ������(ԭʼ)
    wire [7:0] HumidL0;      // ʪ��С��(ԭʼ)
    
    // �ɼ������ź�
    reg dht11_req;           // �ɼ������ź�
    reg [30:0] sample_timer; // �������������(Լ1��).ԭ:23���֣�30��Լ2s��

    // DHT11����ģ��ʵ����
    DHT11 DHT11_HP(
        .sys_clk      (sys_clk),
        .rst_n        (rst_n),
        .dht11_req    (dht11_req),
        .dht11_done   (done),
        .dht11_error  (),      // �����ź�(δʹ��)
        .tempH        (TempH0),
        .tempL        (TempL0),
        .humidityH    (HumidH0),
        .humidityL    (HumidL0),
        .dht11        (dht11)
    );

    // �����������(Լ1��һ��)
    always @(posedge sys_clk or negedge rst_n) begin
        if (!rst_n) begin
            sample_timer <= 30'd0; //ԭ��24
            dht11_req <= 1'b0;
        end else begin
            // 50MHzʱ���£�50,000,000������=1�룻100MHZ
            if (sample_timer == 30'd100_000_000) begin 
                dht11_req <= 1'b1;      // �����ɼ�����
                sample_timer <= 30'd0;   // ���ü�����
            end else begin
                dht11_req <= 1'b0;       // ���ֵ͵�ƽ
                sample_timer <= sample_timer + 1'b1; // ����������
            end
        end
    end

    // ���������߼�
    always @(posedge sys_clk or negedge rst_n) begin
        if (!rst_n) begin
            // ��λʱ����
            TempH <= 8'd0;
            TempL <= 8'd0;
            HumidH <= 8'd0;
            HumidL <= 8'd0;
        end else if (done) begin
            // �ɼ����ʱ��������
            TempH <= TempH0;
            TempL <= TempL0;
            HumidH <= HumidH0;
            HumidL <= HumidL0;
        end
    end

endmodule