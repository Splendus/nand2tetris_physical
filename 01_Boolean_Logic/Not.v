/**
 * Not gate:
 * out = not in
 */

`default_nettype none
module Not(
	input in,
	output out
);

        Nand NAND0(.a(in),.b(in),.out(out));

endmodule

