/**
 * 16-bit incrementer:
 * out = in + 1 (arithmetic addition)
 */

`default_nettype none
module Inc16(
	input [15:0] in,
	output [15:0] out
);

    // `assign out = in + 1;` would probably do the same
    wire [15:0] one;
    assign one = 16'd1;

    Add16 ADD(.out(out),.a(in),.b(one));

endmodule

