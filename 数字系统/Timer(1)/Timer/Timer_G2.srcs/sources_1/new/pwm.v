`timescale 1ns / 1ps
module pwm(
    input wire in,      
    input wire clk,      
    output wire out     
);
reg q;
always @(posedge clk) begin
    q <= in;
end
assign out = in & ~q; 
endmodule