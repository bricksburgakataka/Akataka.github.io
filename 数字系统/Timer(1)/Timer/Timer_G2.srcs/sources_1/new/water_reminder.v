//�ж�����10��
module water_reminder(    
    input clk_1s,
    input reset,
    input [3:0] week,   // ���ڣ�1~7��
    input [3:0] h1, h0,
    input [3:0] m1, m0,
    input [3:0] s1, s0,
    output reg remind_trigger
);
    always @(posedge clk_1s or posedge reset) begin
        if (reset) begin
            remind_trigger <= 0;
        end else begin
            // ����10:00:00����
            if (week == 4'd7 &&
                h1 == 4'd1 && h0 == 4'd0 && // 10
                m1 == 4'd0 && m0 == 4'd0 &&
                s1 == 4'd0 && s0 == 4'd0) begin
                remind_trigger <= 1;
            end else begin
                remind_trigger <= 0;
            end
        end
    end
endmodule


