/**
 * 8-way demultiplexor:
 * {a, b, c, d, e, f, g, h} = {in, 0, 0, 0, 0, 0, 0, 0} if sel == 000
 *                            {0, in, 0, 0, 0, 0, 0, 0} if sel == 001
 *                            etc.
 *                            {0, 0, 0, 0, 0, 0, 0, in} if sel == 111
 */

`default_nettype none
module DMux8Way(
	input in,
	input [2:0] sel,
    output a,
	output b,
	output c,
	output d,
	output e,
	output f,
	output g,
	output h
);

    wire abcd, efgh;  // split into two intermediate wires

    DMux DMUX0(.a(abcd),.b(efgh),.in(in),.sel(sel[2]));

    DMux4Way DMUX4W0(.a(a),.b(b),.c(c),.d(d),.in(abcd),.sel(sel[1:0]));
    DMux4Way DMUX4W1(.a(e),.b(f),.c(g),.d(h),.in(efgh),.sel(sel[1:0]));

endmodule
