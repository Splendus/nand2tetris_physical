`default_nettype none
module top(
    input BUT1,
    input BUT2,
    output LED1
);
    
    Nand NAND(.a(BUT1),.b(BUT2),.out(LED1));

endmodule

