module onoff(input clk, reset1, button_in, output wire out);
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
     pwm pwm1(.clk(clk),.in(out0),.out(out));
     
    always @(posedge clk) begin
         if (reset) begin 
            out0 <= 0; old_bpressed <=0;
         end else if (old_bpressed==0 && bpressed==1) begin
            //button changed from 0 to 1
            out0 <= ~out0;
            old_bpressed <= bpressed;
        end else if (old_bpressed==1 && bpressed==0) begin
            //button changed from 1 to 0
            out0 <= ~out0;
            old_bpressed <= bpressed;
        end
    end
    
endmodule
