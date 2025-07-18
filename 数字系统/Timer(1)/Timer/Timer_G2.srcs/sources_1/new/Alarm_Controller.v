module Alarm_Controller(
    input clk_1s,
    input reset,
    input trigger,
    input silent_mode,
    output reg alarm
);
    reg active;             
    reg [23:0] counter;     

    parameter DURATION = 4'd10; // 提醒维持时间:10s（可调）

    always @(posedge clk_1s or posedge reset) begin
        if (reset) begin
            alarm <= 0;
            active <= 0;
            counter <= 0;
        end
        else begin
            if (trigger && !silent_mode) begin
                active <= 1;
                counter <= DURATION;
            end
            else if (active) begin
                if (counter > 0)
                    counter <= counter - 1;
                else
                    active <= 0;
            end
            alarm <= active;
        end
    end
endmodule
