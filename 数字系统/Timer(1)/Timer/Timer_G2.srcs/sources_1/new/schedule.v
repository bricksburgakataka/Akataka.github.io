module schedule(
    input clk,
    input reset,
    input [3:0] sh1, sh0,
    input [3:0] sm1, sm0,
    input [3:0] ss1, ss0,
    input [3:0] th1, th0,
    input [3:0] tm1, tm0,
    input set,
    output reg timeeq,
    output reg [5:0] sche
);

reg [15:0] time_reg [59:0];
integer i;
reg found; // 新增标志位

always @(posedge clk) begin
    if (reset) begin
        for (i = 0; i < 60; i = i + 1)
            time_reg[i] <= 16'h0000;
    end
    else if (set) begin
        time_reg[{ss1, ss0}] <= {sh1, sh0, sm1, sm0};
    end
end

always @(*) begin
    timeeq = 0;
    sche = 0;
    found = 0; // 初始化标志位
    
    for (i = 0; i < 60; i = i + 1) begin
        if (!found && ({th1, th0, tm1, tm0} == time_reg[i])) begin
            timeeq = 1;
            sche = i;
            found = 1; // 设置标志位代替break
        end
    end
end
    set_schedule setclass();
endmodule