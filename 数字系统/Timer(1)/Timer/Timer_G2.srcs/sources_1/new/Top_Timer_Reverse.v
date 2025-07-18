module Top_Timer_Reverse(
    input clk,           
    input reset,       
    input ok,              
    input ok_long,      
    input up,                 
    input down,          
    input left,              
    input right,        
    output [3:0] h1,        
    output [3:0] h0,        
    output [3:0] m1,          
    output [3:0] m0,        
    output [3:0] s1,         
    output [3:0] s0        
);
    wire setEN;             
    wire displayMUX;        
    wire sEN;               
    wire timeout;          
   
    FSM0 fsm0 (
        .clk(clk),
        .reset(reset),
        .ok(ok),
        .ok_long(ok_long),
        .timeout(timeout),
        .setEN(setEN),
        .displayMUX(displayMUX),
        .sEN(sEN)
    );
    
    DP0 dp (
        .clk(clk),
        .reset(reset),
        .up(up),
        .down(down),
        .left(left),
        .right(right),
        .setEN(setEN),
        .sEN(sEN),
        .displayMUX(displayMUX),
        .timeout(timeout),
        .h1(h1),
        .h0(h0),
        .m1(m1),
        .m0(m0),
        .s1(s1),
        .s0(s0)
    );
endmodule
