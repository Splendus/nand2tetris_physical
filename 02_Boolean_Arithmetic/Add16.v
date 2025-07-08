/**
 * Adds two 16-bit values.
 * The most significant carry bit is ignored.
 * out = a + b (16 bit)
 */

`default_nettype none
module Add16(
	input [15:0] a,
	input [15:0] b,
	output [15:0] out
);

    // Indeed, one could simply do
    // assign out = a + b;
    
    wire [16:0] c;  // internal carries. Final carry is ignored
    assign c[0] = 0;  // initial carry in

    genvar i;
    generate
        for (i=0; i < 16; i = i + 1) begin
            FullAdder FA (.sum(out[i]),.carry(c[i+1]),.a(a[i]),.b(b[i]),.c(c[i]));
        end
    endgenerate

endmodule
