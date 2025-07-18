`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/05/25 19:43:17
// Design Name: 
// Module Name: clk_1HZ
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


// 分频模块：将100MHz分频为1Hz（1秒）输出
module clk_1Hz(
    input clk,
    input reset,
    output reg clk_1s
);
    reg [26:0] count;  // 2^27 > 100_000_000
    parameter MAX = 100_000_000;  // 100MHz -> 1Hz

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            count <= 0;
            clk_1s <= 0;
        end else if (count == MAX/2 - 1) begin
            clk_1s <= ~clk_1s;
            count <= 0;
        end else begin
            count <= count + 1;
        end
    end
endmodule
