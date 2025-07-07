/**
 * 8-way Or: 
 * out = (in[0] or in[1] or ... or in[7])
 */

`default_nettype none
module Or8Way(
	input [7:0] in,
	output out
);

    // using verilog built-in operators this could also be achieved with
    // assign out = |in
    // which sets `out` to 1 for any 1 in `in`
    
    // balanced or tree implementation:
    wire [3:0] o2;
    wire [1:0] o4;


    Or OR20(.out(o2[0]),.a(in[0]),.b(in[1]));
    Or OR21(.out(o2[1]),.a(in[2]),.b(in[3]));
    Or OR22(.out(o2[2]),.a(in[4]),.b(in[5]));
    Or OR23(.out(o2[3]),.a(in[6]),.b(in[7]));

    Or OR40(.out(o4[0]),.a(o2[0]),.b(o2[1]));
    Or OR41(.out(o4[1]),.a(o2[2]),.b(o2[3]));

    Or ORFINAL(.out(out),.a(o4[0]),.b(o4[1]));

endmodule

