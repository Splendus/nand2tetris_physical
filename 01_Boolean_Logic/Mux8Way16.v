/**
 * 16-bit 8 way multiplexor: 
 * for i = 0..15 out[i] = a[i] if sel == 000
 *                        b[i] if sel == 001
 *                        c[i] if sel == 010
 *                        d[i] if sel == 011
 *                        e[i] if sel == 100
 *                        f[i] if sel == 101
 *                        g[i] if sel == 110
 *                        h[i] if sel == 111
 */

`default_nettype none
module Mux8Way16(
	input [15:0] a,
	input [15:0] b,
	input [15:0] c,
	input [15:0] d,
	input [15:0] e,
	input [15:0] f,
	input [15:0] g,
	input [15:0] h,
   	input [2:0] sel,
	output [15:0] out
);

    wire [15:0] muxABCD;
    wire [15:0] muxEFGH;

    Mux4Way16 MUXABCD(.out(muxABCD),.a(a),.b(b),.c(c),.d(d),.sel(sel[1:0]));
    Mux4Way16 MUXEFGH(.out(muxEFGH),.a(e),.b(f),.c(g),.d(h),.sel(sel[1:0]));

    Mux16 MUXFINAL(.out(out),.a(muxABCD),.b(muxEFGH),.sel(sel[2]));

endmodule

