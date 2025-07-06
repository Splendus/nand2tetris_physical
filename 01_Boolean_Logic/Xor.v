/**
 * Exclusive-or gate:
 * out = not (a == b)
 */

`default_nettype none
module Xor(
	input a,
	input b,
	output out
);

    wire orOut;
    wire nandOut;

    Or OR0(.out(orOut),.a(a),.b(b));
    Nand NAND0(.out(nandOut),.a(a),.b(b));
    And AND0(.out(out),.a(orOut),.b(nandOut));

endmodule

