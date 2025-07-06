/**
 * Buffer:
 * out = in
 */

`default_nettype none
module Buffer(
	input in,
	output out
);

    buf buffer(out, in);

endmodule
