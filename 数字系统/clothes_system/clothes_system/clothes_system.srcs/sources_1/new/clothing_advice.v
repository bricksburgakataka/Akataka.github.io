//���½���
module clothing_advice(
    input [7:0] temperature,
    input [7:0] humidity,
    output reg [5:0] led_out  // led_out[4:0]���½��飬led_out[5]�Ƿ��ɡ
);
    always @(*) begin
        // Ĭ��ȫ��
        led_out = 6'b000000;
        
        // ���½����жϣ�ֻ��һ��LED��
        if (temperature > 30)
            led_out[0] = 1;  // ����
        else if (temperature > 20)
            led_out[1] = 1;  // ����
        else if (temperature > 15)
            led_out[2] = 1;  // ������
        else if (temperature > 5)
            led_out[3] = 1;  // ������
        else
            led_out[4] = 1;  // ���޷�

    // ʪ���ж�
        if ( humidity >= 75 )
            led_out[5] = 1;  // ���Ѵ�ɡ
    end
endmodule