/**
 * Demultiplexor:
 * {a, b} = {in, 0} if sel == 0
 *          {0, in} if sel == 1
 */

`default_nettype none
module DMux(
	input in,
	input sel,
    output a,
	output b
);

    wire notSel;

    Not NOT0(.out(notSel),.in(sel));

    And ANDA(.out(a),.a(in),.b(notSel));
    And ANDB(.out(b),.a(in),.b(sel));
    
endmodule

