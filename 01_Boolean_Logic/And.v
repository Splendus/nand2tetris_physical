/**
 * And gate: 
 * out = 1 if (a == 1 and b == 1)
 *       0 otherwise
 */

`default_nettype none
module And(
	input a,
	input b,
	output out
);

    wire nOut;

    Nand NAND(.out(nOut),.a(a),.b(b));
    Not NOT(.out(out),.in(nOut));

endmodule

