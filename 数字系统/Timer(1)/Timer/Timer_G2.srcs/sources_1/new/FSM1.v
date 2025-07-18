module FSM1(
    input clk,
    input reset,
    input ok,
    input ok_long,
    output reg setEN,      
    output reg displayMUX
);

parameter set = 0;
parameter start = 1;
reg [2:0] state, next_state;

always@(*) begin
    if (reset) begin 
        next_state = set; 
    end else begin
        case (state)
            set: 
                if(ok) next_state = start;
                else next_state = set;     
                
            start: 
                if(ok_long) next_state = set;
                else next_state = start;   
                
            default: next_state = set;      
        endcase
    end
end
always@(posedge clk) begin
    if (reset) begin
        state <= set; 
    end else begin
        state <= next_state; 
    end
end

always@(*) begin
    case (state)
        set: begin
            displayMUX = 1; 
            setEN = 1;      
        end
        
        start: begin
            displayMUX = 0; 
            setEN = 0;   
        end
        
        default: begin
            displayMUX = 1;
            setEN = 0;    
        end
    endcase
end
endmodule