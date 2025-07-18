module display(
    input clk,
    input reset,
    input [3:0] in3,  
    input [3:0] in2,
    input [3:0] in1,
    input [3:0] in0,  
    output [3:0] an,  
    output a,b,c,d,e,f,g  
);
    wire [1:0] pick;  
    wire [3:0] out;  
    
    clk_div_1 div1(
        .clk(clk),
        .reset(reset),  
        .pick(pick)
    );
    
    select select_inst(
        .in3(in3),
        .in2(in2),
        .in1(in1),
        .in0(in0),
        .pick(pick),
        .an(an),
        .out(out)
    );
    
    pin pin_inst(
        .din(out),
        .a(a),.b(b),.c(c),.d(d),.e(e),.f(f),.g(g)
    );
endmodule
