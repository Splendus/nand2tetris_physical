/**
 * Computes the sum of two bits and an additional carry-in bits
 * using two half adders and an Or gate.
 */

`default_nettype none
module FullAdder(
	input a,		// 1-bit input
	input b,		// 1-bit input
	input cin,		// 1-bit carry-in input
	output sum,		// Right bit of a + b + cin
	output cout	// Left bit of a + b + cin
);

    wire sumAB;
    wire coutAB;
    wire cout1;  // carry of HalfAdder 1

    HalfAdder HA0(.sum(sumAB),.cout(coutAB),.a(a),.b(b));
    HalfAdder HA1(.sum(sum),.cout(cout1),.a(cin),.b(sumAB));
    Or ORSUM(.out(cout),.a(coutAB),.b(cout1));

endmodule

