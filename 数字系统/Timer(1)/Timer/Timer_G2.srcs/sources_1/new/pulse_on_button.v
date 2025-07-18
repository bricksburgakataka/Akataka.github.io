module pulse_on_button (
    input clk,
    input reset,
    input noisy,         // ԭʼ������ť�ź�
    output pulse         // ÿ�ΰ������һ��ʱ����������
);
    wire clean;          // ȥ������İ�ť״̬
    reg clean_dly;       // ��һ��ʱ�����ڵİ�ť״̬

    // ȥ��������
    debounce db_inst (
        .clk(clk),
        .reset(reset),
        .noisy(noisy),
        .clean(clean)
    );

    // ���ؼ�⣺�����أ���0��1��ʱ���1��������
    always @(posedge clk or posedge reset) begin
        if (reset)
            clean_dly <= 0;
        else
            clean_dly <= clean;
    end

    assign pulse = (clean == 1 && clean_dly == 0);  // �����ؼ��

endmodule
