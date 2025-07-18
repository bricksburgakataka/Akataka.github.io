`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/05/09 17:15:24
// Design Name: 
// Module Name: button
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


module button(
input clk, reset1, button_in, output wire out
);
    wire reset; 
    reg light_reg;
    assign reset = ~reset1;
    //synchronizer
    reg button,btemp;
    always @(posedge clk)
    {button,btemp} <= {btemp,button_in};
    //debounce push button
    wire bpressed;
    debounce db1(.clk(clk),.reset(reset),.noisy(button),.clean(bpressed));
     reg old_bpressed;  //state last clk cycle
    reg out0;
    always @(posedge clk) begin
     if (reset)
      begin out0 <= 0; old_bpressed <=0;end
     else if (old_bpressed==0 && bpressed==1)begin
     //button changed from 0 to 1
     out0 <= ~out0;
     old_bpressed <= bpressed;
    end
    else if (old_bpressed==1 && bpressed==0)begin
         //button changed from 1 to 0
         out0 <= ~out0;
         old_bpressed <= bpressed;
        end
    end
    pwm pwm1(.clk(clk),.in(out0),.out(out));
endmodule

module debounce (
    input clk,      
    input reset,    
    input noisy,     
    output reg clean 
);
    parameter COUNTER_WIDTH = 20;
    parameter MAX_COUNT = 650000; 
    reg [COUNTER_WIDTH-1:0] count; 
    reg noisy_reg; 
always @(posedge clk or posedge reset) begin
        if (reset) begin
            count <= 0;
            noisy_reg <= 0;
            clean <= 0;
        end else begin
            noisy_reg <= noisy;
            if (noisy_reg != noisy) begin
                count <= 0;
            end else if (count < MAX_COUNT) begin
                count <= count + 1;
            end else begin
                clean <= noisy_reg;
            end
        end
    end
endmodule
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
