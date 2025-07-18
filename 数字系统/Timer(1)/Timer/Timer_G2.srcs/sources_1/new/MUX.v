module MUX(
    input [3:0]in0,
    input [3:0]in1,
    input S,
    output [3:0]out
    );

    assign out = S ? in1 : in0; 
endmodule