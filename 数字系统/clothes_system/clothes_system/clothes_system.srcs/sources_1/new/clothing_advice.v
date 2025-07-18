//穿衣建议
module clothing_advice(
    input [7:0] temperature,
    input [7:0] humidity,
    output reg [5:0] led_out  // led_out[4:0]穿衣建议，led_out[5]是否带伞
);
    always @(*) begin
        // 默认全灭
        led_out = 6'b000000;
        
        // 穿衣建议判断（只亮一个LED）
        if (temperature > 30)
            led_out[0] = 1;  // 短袖
        else if (temperature > 20)
            led_out[1] = 1;  // 长袖
        else if (temperature > 15)
            led_out[2] = 1;  // 薄外套
        else if (temperature > 5)
            led_out[3] = 1;  // 厚外套
        else
            led_out[4] = 1;  // 羽绒服

    // 湿度判断
        if ( humidity >= 75 )
            led_out[5] = 1;  // 提醒带伞
    end
endmodule