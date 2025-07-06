 /**
 * Or gate:
 * out = 1 if (a == 1 or b == 1)
 *       0 otherwise
 */

`default_nettype none
module Or(
	input a,
	input b,
	output out
);

    wire na;  // not a
    wire nb;  // not b
    
    Not NOTA(.out(na),.in(a));
    Not NOTB(.out(nb),.in(b));
    Nand NANDAB(.out(out),.a(na),.b(nb));

endmodule

