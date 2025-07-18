module Set_timer(
    input clk,          // ʱ���ź�
    input reset,        // �첽��λ
    input up,           // ���ӵ�ǰλֵ
    input down,         // ���ٵ�ǰλֵ
    input left,         // �����ƶ�ѡ��λ
    input right,        // �����ƶ�ѡ��λ
    output reg [3:0] h1, // Сʱʮλ(0-2)
    output reg [3:0] h0, // Сʱ��λ(0-9, ��h1=2ʱ0-3)
    output reg [3:0] m1, // ����ʮλ(0-5)
    output reg [3:0] m0, // ���Ӹ�λ(0-9)
    output reg [3:0] s1, // ����ʮλ(0-5)
    output reg [3:0] s0, // ���Ӹ�λ(0-9)
    output reg [3:0] week,//����ֵ(1-7)
    output reg [2:0] sel // ѡ��λ(0-6��Ӧs0��h1��week )
);

// ѡ��λ�ƶ��߼�
always @(posedge clk or posedge reset) begin
    if (reset) begin
        sel <= 3'd0;  // Ĭ��ѡ�����λ
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

// ��ֵ�����߼�
always @(posedge clk or posedge reset) begin
    if (reset) begin
        // ��λʱ����Ϊ00:00:00
        h1 <= 4'd0;
        h0 <= 4'd0;
        m1 <= 4'd0;
        m0 <= 4'd0;
        s1 <= 4'd0;
        s0 <= 4'd0;
        week <= 4'd1; //Ĭ������һ
    end
    else begin
        case (sel)
            3'd0: begin // ���λ(s0)
                if (up) s0 <= (s0 == 4'd9) ? 4'd0 : s0 + 1;
                if (down) s0 <= (s0 == 4'd0) ? 4'd9 : s0 - 1;
            end
            3'd1: begin // ��ʮλ(s1)
                if (up) s1 <= (s1 == 4'd5) ? 4'd0 : s1 + 1;
                if (down) s1 <= (s1 == 4'd0) ? 4'd5 : s1 - 1;
            end
            3'd2: begin // �ָ�λ(m0)
                if (up) m0 <= (m0 == 4'd9) ? 4'd0 : m0 + 1;
                if (down) m0 <= (m0 == 4'd0) ? 4'd9 : m0 - 1;
            end
            3'd3: begin // ��ʮλ(m1)
                if (up) m1 <= (m1 == 4'd5) ? 4'd0 : m1 + 1;
                if (down) m1 <= (m1 == 4'd0) ? 4'd5 : m1 - 1;
            end
            3'd4: begin // ʱ��λ(h0)
                if (up) h0 <= ((h1 == 4'd2 && h0 == 4'd3) || h0 == 4'd9) ? 4'd0 : h0 + 1;
                if (down) h0 <= (h0 == 4'd0) ? ((h1 == 4'd2) ? 4'd3 : 4'd9) : h0 - 1;
            end
            3'd5: begin // ʱʮλ(h1)
                if (up) h1 <= (h1 == 4'd2) ? 4'd0 : h1 + 1;
                if (down) h1 <= (h1 == 4'd0) ? 4'd2 : h1 - 1;
            end
            3'd6: begin // ����(week: 1-7)
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
