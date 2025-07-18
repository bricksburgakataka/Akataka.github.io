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
