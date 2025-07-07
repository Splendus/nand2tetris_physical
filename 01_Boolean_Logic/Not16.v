/**
 * 16-bit Not:
 * for i=0..15: out[i] = not in[i]
 */

`default_nettype none
module Not16(
	input [15:0] in,
	output [15:0] out
);

    assign out = ~in; // which under the hood inverts every bit independently

endmodule
