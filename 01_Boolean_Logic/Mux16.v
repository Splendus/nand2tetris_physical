/**
 * 16-bit multiplexor: 
 * for i = 0..15 out[i] = a[i] if sel == 0 
 *                        b[i] if sel == 1
 */

`default_nettype none
module Mux16(
	input [15:0] a,
	input [15:0] b,
   	input sel,
	output [15:0] out
);

    // verilog would also supply the short hand
    // assign out = sel ? b : a;

    wire [15:0] sel16;

	wire [15:0] notSel;
    wire [15:0] aAndNotSel;
    wire [15:0] bAndSel;

    assign sel16 = {16{sel}};

    Not16 NOT0(.out(notSel),.in(sel16));
    And16 AND0(.out(aAndNotSel),.a(a),.b(notSel));
    And16 AND1(.out(bAndSel),.a(sel16),.b(b));
    Or16 OR0(.out(out),.a(aAndNotSel),.b(bAndSel));

endmodule

