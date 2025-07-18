module clk_div_1(
    input clk,
    input reset,
    output reg [1:0] pick 
);
    reg [19:0] count;      
    parameter MAXCOUNT = 100000;  
    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            count <= 0;
            pick <= 0;      
        end
        else begin
            if (count < MAXCOUNT-1) 
                count <= count + 1;
            else begin
                count <= 0;
                pick <= pick + 1;  
            end
        end
    end
endmodule
