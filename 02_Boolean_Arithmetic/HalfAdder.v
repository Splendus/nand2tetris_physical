/**
 * Computes the sum of two bits.
 */

`default_nettype none
module HalfAdder(
	input a,		// 1-bit input
	input b,		// 1-bit input
	output sum,	    // Right bit of a + b, which equals an XOR gate
	output cout	// Lef bit of a + b, which equals an AND gate
);

    Xor XORSUM(.out(sum),.a(a),.b(b));
    And ANDCARRY(.out(cout),.a(a),.b(b));

endmodule
