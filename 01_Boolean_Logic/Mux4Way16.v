/**
 * 16-bit 4 way multiplexor: 
 * for i = 0..15 out[i] = a[i] if sel == 00
 *                        b[i] if sel == 01
 *                        c[i] if sel == 10
 *                        d[i] if sel == 11
 */

`default_nettype none
module Mux4Way16(
	input [15:0] a,
	input [15:0] b,
	input [15:0] c,
	input [15:0] d,
   	input [1:0] sel,
	output [15:0] out
);
	
    wire [15:0] muxAB;
    wire [15:0] muxCD;
    wire [15:0] sel116;
    wire [15:0] notSel1;
    wire [15:0] muxABAndNotSel1;
    wire [15:0] muxCDAndSel1;

    assign sel116 = {16{sel[1]}};

    Mux16 MUXAB(.out(muxAB),.a(a),.b(b),.sel(sel[0]));
    Mux16 MUXCD(.out(muxCD),.a(c),.b(d),.sel(sel[0]));

    Not16 NOT1(.out(notSel1),.in(sel116));

    And16 ANDAB(.out(muxABAndNotSel1),.a(muxAB),.b(notSel1)); 
    And16 ANDCD(.out(muxCDAndSel1),.a(muxCD),.b(sel116)); 

    Or16 OROUT(.out(out),.a(muxABAndNotSel1),.b(muxCDAndSel1));

endmodule

