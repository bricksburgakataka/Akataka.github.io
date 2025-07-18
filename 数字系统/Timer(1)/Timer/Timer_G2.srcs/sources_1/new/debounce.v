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
