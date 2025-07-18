module DP1(
    input clk,clk_1s, reset, up, down, left, right,setEN, sEN,displayMUX,     
    output [3:0] h1,        
    output [3:0] h0,         
    output [3:0] m1,       
    output [3:0] m0,    
    output [3:0] s1,         
    output [3:0] s0,
    output [3:0] week      
);
    wire [3:0] sh1, sh0, sm1, sm0, ss1, ss0, sw; // sw:设置的星期
    wire [3:0] th1, th0, tm1, tm0, ts1, ts0, tw; // tw:计时器的星期

    Set_timer set1 (
        .clk       (clk),      
        .reset     (reset),   
        .up        (up),     
        .down      (down),    
        .left      (left),    
        .right     (right), 
        .h1        (sh1),      
        .h0        (sh0),      
        .m1        (sm1),       
        .m0        (sm0),    
        .s1        (ss1),   
        .s0        (ss0),
        .week      (sw)     
    );

    timer tim (
        .clk               (clk_1s),              
        .reset             (reset),          
        .set               (setEN),          
        .EN                (1),               
        .setin_hour_tens   (sh1),              
        .setin_hour_ones   (sh0),              
        .setin_min_tens    (sm1),            
        .setin_min_ones    (sm0),          
        .setin_sec_tens    (ss1),             
        .setin_sec_ones    (ss0),    
        .setin_week        (sw),         
        .timer_hour_tens   (th1),              
        .timer_hour_ones   (th0),              
        .timer_min_tens    (tm1),             
        .timer_min_ones    (tm0),          
        .timer_sec_tens    (ts1),              
        .timer_sec_ones    (ts0),  
        .timer_week        (tw)            
    );

    MUX mux5 (
        .in0       (th1),     
        .in1       (sh1),       
        .S         (displayMUX),
        .out       (h1)        
    );
    
    MUX mux4 (
        .in0       (th0),    
        .in1       (sh0),      
        .S         (displayMUX),
        .out       (h0)      
    );
    
    MUX mux3 (
        .in0       (tm1),      
        .in1       (sm1),       
        .S         (displayMUX),
        .out       (m1)      
    );
    
    MUX mux2 (
        .in0       (tm0),     
        .in1       (sm0),      
        .S         (displayMUX),
        .out       (m0)       
    );
    
    MUX mux1 (
        .in0       (ts1),      
        .in1       (ss1),      
        .S         (displayMUX),
        .out       (s1)      
    );
    
    MUX mux0 (
        .in0       (ts0),      
        .in1       (ss0),      
        .S         (displayMUX),
        .out       (s0)        
    );
    
    MUX mux_week (
        .in0 (tw),         // 计时器输出的星期
        .in1 (sw),         // 设置值中的星期
        .S   (displayMUX),
        .out (week)        // 输出到 Top
    );
endmodule
