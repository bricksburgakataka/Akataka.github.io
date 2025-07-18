module FSM0(
    input clk,
    input reset,
    input ok,
    input ok_long,
    input timeout,
    output reg setEN,      
    output reg displayMUX, 
    output reg sEN        
);

parameter set = 0;
parameter start = 1;
parameter stop = 2;
parameter final = 3;

reg [2:0] state, next_state;

always@(*) begin
    if (reset) begin 
        next_state = set; // 复位时进入设置状�?
    end else begin
        case (state)
            set: 
                if(ok) next_state = start; // 短按OK，从设置进入启动状�??
                else next_state = set;     // 保持当前状�??
                
            start: 
                if(ok) next_state = stop;      // 短按OK，从启动进入暂停状�??
                else if(timeout) next_state = final; // 计时结束，进入结束状�?
                else next_state = start;     // 保持当前状�??
                
            stop: 
                if(ok) next_state = start;     // 短按OK，从暂停恢复计时
                else if(ok_long) next_state = set; // 长按OK，返回设置状�?
                else next_state = stop;      // 保持当前状�??
                
            final: 
                if(ok) next_state = set;     // 短按OK，从结束返回设置状�??
                else next_state = final;    // 保持当前状�??
                
            default: next_state = set;      // 默认状�?�为设置状�?�，防止出现未定义状�?
        endcase
    end
end

// 状�?�寄存器更新逻辑（时序�?�辑，使用非阻塞赋�?�）
always@(posedge clk) begin
    if (reset) begin
        state <= set; // 复位时进入设置状�?
    end else begin
        state <= next_state; // 时钟上升沿更新状�?
    end
end

always@(*) begin
    case (state)
        set: begin
            displayMUX = 1; 
            setEN = 1;      
            sEN = 0;      
        end
        
        start: begin
            displayMUX = 0; 
            setEN = 0;      
            sEN = 1;        
        end
        
        stop: begin
            displayMUX = 0; 
            setEN = 0;     
            sEN = 0;       
        end
        
        final: begin
            displayMUX = 0; // 显示剩余时间（应�?0�?
            setEN = 0;     
            sEN = 0;       
        end
        
        default: begin
            displayMUX = 1; 
            setEN = 0;      
            sEN = 0;     
        end
    endcase
end

endmodule