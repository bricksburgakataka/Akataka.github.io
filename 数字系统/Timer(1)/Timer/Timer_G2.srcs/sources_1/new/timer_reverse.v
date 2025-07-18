module timer_reverse(
    input clk,          // ʱ���ź�
    input reset,        // �첽��λ(����Ч)
    input [3:0] setin_sec_ones,  // ����ֵ���룺��ĸ�λ(0-9)
    input [3:0] setin_sec_tens,  // ����ֵ���룺���ʮλ(0-5)
    input [3:0] setin_min_ones,  // ����ֵ���룺�ֵĸ�λ(0-9)
    input [3:0] setin_min_tens,  // ����ֵ���룺�ֵ�ʮλ(0-5)
    input [3:0] setin_hour_ones, // ����ֵ���룺ʱ�ĸ�λ(0-9)
    input [3:0] setin_hour_tens, // ����ֵ���룺ʱ��ʮλ(0-2)
    input set,          // ����ʹ��(����Ч)   
    input EN,
    output reg [3:0] timer_sec_ones, // ��ʱ���������ĸ�λ(0-9)
    output reg [3:0] timer_sec_tens, // ��ʱ����������ʮλ(0-5)
    output reg [3:0] timer_min_ones, // ��ʱ��������ֵĸ�λ(0-9)
    output reg [3:0] timer_min_tens, // ��ʱ��������ֵ�ʮλ(0-5)
    output reg [3:0] timer_hour_ones, // ��ʱ�������ʱ�ĸ�λ(0-9)
    output reg [3:0] timer_hour_tens, // ��ʱ�������ʱ��ʮλ(0-2)
    output reg timeout
);

always @(posedge clk or posedge reset) begin
    if (reset) begin
        // �첽��λ
        timer_sec_ones <= 4'd0;
        timer_sec_tens <= 4'd0;
        timer_min_ones <= 4'd0;
        timer_min_tens <= 4'd0;
        timer_hour_ones <= 4'd0;
        timer_hour_tens <= 4'd0;
        timeout <= 1'b0;
    end
    else if (set) begin
        // ����ģʽ
        timer_sec_ones <= setin_sec_ones;
        timer_sec_tens <= setin_sec_tens;
        timer_min_ones <= setin_min_ones;
        timer_min_tens <= setin_min_tens;
        timer_hour_ones <= setin_hour_ones;
        timer_hour_tens <= setin_hour_tens;
        timeout <= 1'b0;
    end
    else if (EN && !timeout) begin
        // ����ʱ�߼�
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
                                // ����ʱ�䶼��0��������ʱ
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
