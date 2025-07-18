//¶¥²ãÄ£¿é
module clothes_system(
    input clk,
    input rst_n,
    input reset,
    inout dht11,

    output [5:0] led_out,
    output [7:0] TempH,
    output [7:0] HumidH
);


        
    main main1(
    .sys_clk(clk),
    .rst_n(rst_n),
    .dht11(dht11),
    .TempH(TempH),
    .HumidH(HumidH)
     );
    
    clothing_advice advice (
        .temperature(TempH),
        .humidity(HumidH),
        .led_out(led_out)
    );


endmodule
