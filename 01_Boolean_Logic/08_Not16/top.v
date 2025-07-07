`default_nettype none
module top(
    input [15:0] in,
    output [15:0] out
);

    Not16 NOT16(.out(out),.in(in));

endmodule

