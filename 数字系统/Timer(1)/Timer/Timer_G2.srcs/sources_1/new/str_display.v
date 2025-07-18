`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/05/19 19:27:54
// Design Name: 
// Module Name: display
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module str_display(
    input clk,
    input reset,
    input [3:0] di7,  // ???¦Ë????
    input [3:0] di6,
    input [3:0] di5,
    input [3:0] di4,
    input [3:0] di3,
    input [3:0] di2,
    input [3:0] di1,
    input [3:0] di0,  // ???¦Ë????
    output [3:0] an1, // ??4¦Ë?????¦Ë?
    output [3:0] an0, // ??4¦Ë?????¦Ë?
    output a1,b1,c1,d1,e1,f1,g1, // ??4¦Ë???
    output a0,b0,c0,d0,e0,f0,g0  // ??4¦Ë???
);
    // ???????????????????????reset???
    display display_high(
        .clk(clk),
        .reset(reset),  // ??????????reset
        .in3(di7),
        .in2(di6),
        .in1(di5),
        .in0(di4),
        .an(an1),
        .a(a1),.b(b1),.c(c1),.d(d1),.e(e1),.f(f1),.g(g1)
    );
    
    display display_low(
        .clk(clk),
        .reset(reset),  // ??????????reset
        .in3(di3),
        .in2(di2),
        .in1(di1),
        .in0(di0),
        .an(an0),
        .a(a0),.b(b0),.c(c0),.d(d0),.e(e0),.f(f0),.g(g0)
    );
endmodule

// ???????????
module display(
    input clk,
    input reset,
    input [3:0] in3,  // ????????(???¦Ë)
    input [3:0] in2,
    input [3:0] in1,
    input [3:0] in0,  // ????????(???¦Ë)
    output [3:0] an,  // ¦Ë????
    output a,b,c,d,e,f,g  // ??????
);
    wire [1:0] pick;  // ???????????
    wire [3:0] out;   // ??????????
    
    // ????¦Ë??????????
    clk_div_1 div1(
        .clk(clk),
        .reset(reset),  // ???????
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

// ???????÷Ï????—¥
module clk_div_1(
    input clk,
    input reset,
    output reg [1:0] pick  // ???????????
);
    reg [19:0] count;      // 20¦Ë??????
    parameter MAXCOUNT = 100000;  // ??????
    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            count <= 0;
            pick <= 0;      // ??¦Ë???0???
        end
        else begin
            // ???????????????????
            if (count < MAXCOUNT-1) 
                count <= count + 1;
            else begin
                count <= 0;
                pick <= pick + 1;  // ???????????
            end
        end
    end
endmodule

// ??????????÷Ï?????????
module select(
    input [3:0] in3,
    input [3:0] in2,
    input [3:0] in1,
    input [3:0] in0,
    input [1:0] pick,
    output reg [3:0] an,
    output reg [3:0] out
);
    always @(*) begin
        case(pick)
            2'b00: out = in0;
            2'b01: out = in1;
            2'b10: out = in2;
            2'b11: out = in3;
            default: out = 4'b0000;
        endcase
        
        an[0] = ~pick[1] & ~pick[0];
        an[1] = ~pick[1] & pick[0];
        an[2] = pick[1] & ~pick[0];
        an[3] = pick[1] & pick[0];
    end
endmodule

// ?????????÷Ï?????????
module pin(
    input [3:0] din,
    output reg a,b,c,d,e,f,g
);
    always @(*) begin
        case(din)
            4'b0000: {a,b,c,d,e,f,g} = 7'b1111110;  // 0
            4'b0001: {a,b,c,d,e,f,g} = 7'b0110000;  // 1
            4'b0010: {a,b,c,d,e,f,g} = 7'b1101101;  // 2
            4'b0011: {a,b,c,d,e,f,g} = 7'b1111001;  // 3
            4'b0100: {a,b,c,d,e,f,g} = 7'b0110011;  // 4
            4'b0101: {a,b,c,d,e,f,g} = 7'b1011011;  // 5
            4'b0110: {a,b,c,d,e,f,g} = 7'b1011111;  // 6
            4'b0111: {a,b,c,d,e,f,g} = 7'b1110000;  // 7
            4'b1000: {a,b,c,d,e,f,g} = 7'b1111111;  // 8
            4'b1001: {a,b,c,d,e,f,g} = 7'b1111011;  // 9
            default: {a,b,c,d,e,f,g} = 7'b1111110;  // ??????0
        endcase
    end
endmodule
