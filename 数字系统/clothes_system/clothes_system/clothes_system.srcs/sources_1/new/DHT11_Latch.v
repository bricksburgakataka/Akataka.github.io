module DHT11_Latch(
    input clk,
    input reset,
    input dht11_done,
    input [7:0] tempH,
    input [7:0] humidityH,
    output reg [7:0] locked_tempH,
    output reg [7:0] locked_humidityH
);

reg dht11_done_prev;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        locked_tempH <= 0;
        locked_humidityH <= 0;
        dht11_done_prev <= 0;
    end else begin
        dht11_done_prev <= dht11_done;
        // 仅在 dht11_done 上升沿时锁存
        if (dht11_done && !dht11_done_prev) begin
            locked_tempH <= tempH;
            locked_humidityH <= humidityH;
        end
    end
end

endmodule

