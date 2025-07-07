/**
 * 4-way demultiplexor:
 * {a, b, c, d} = {in, 0, 0, 0} if sel == 00
 *                {0, in, 0, 0} if sel == 01
 *                {0, 0, in, 0} if sel == 10
 *                {0, 0, 0, in} if sel == 11
 */

`default_nettype none
module DMux4Way(
	input in,
	input [1:0] sel,
    output a,
	output b,
	output c,
	output d
);

    wire ab, cd;  // split into intermediate wires

    DMux DMUXABCD(.a(ab),.b(cd),.in(in),.sel(sel[1]));  // sel[1] chooses between AB and CD

    DMux DMUXAB(.a(a),.b(b),.in(ab),.sel(sel[0]));  // sel[0] chooses between a and b
    DMux DMUXCD(.a(c),.b(d),.in(cd),.sel(sel[0]));  // sel[0] chooses between c and d

endmodule

