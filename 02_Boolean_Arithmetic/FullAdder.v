/**
 * Computes the sum of two bits and an additional carry-in bits
 * using two half adders and an Or gate.
 */

`default_nettype none
module FullAdder(
	input a,		// 1-bit input
	input b,		// 1-bit input
	input c,		// 1-bit carry-in input
	output sum,		// Right bit of a + b + c
	output carry	// Left bit of a + b + c
);

    wire sumAB;
    wire carryAB;
    wire carry1;  // carry of HalfAdder 1

    HalfAdder HA0(.sum(sumAB),.carry(carryAB),.a(a),.b(b));
    HalfAdder HA1(.sum(sum),.carry(carry1),.a(c),.b(sumAB));
    Or ORSUM(.out(carry),.a(carryAB),.b(carry1));

endmodule

