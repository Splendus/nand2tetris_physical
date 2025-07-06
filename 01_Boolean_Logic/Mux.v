/** 
 * Multiplexor:
 * out = a if sel == 0
 *       b otherwise
 */

`default_nettype none
module Mux(
	input a,
	input b,
	input sel,
	output out
);

	wire notSel;
    wire aAndNotSel;
    wire bAndSel;

    Not NOT0(.out(notSel),.in(sel));
    And AND0(.out(aAndNotSel),.a(a),.b(notSel));
    And AND1(.out(bAndSel),.a(sel),.b(b));
    Or OR0(.out(out),.a(aAndNotSel),.b(bAndSel));

endmodule

