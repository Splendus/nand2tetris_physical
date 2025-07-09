/**
* RAM512 implements 512 Bytes of RAM addressed from 0 - 511
* out = M[address]
* if (load =i= 1) M[address][t+1] = in[t]
*/

`default_nettype none
module RAM512(
	input clk,
	input [8:0] address,
	input [15:0] in,
	input load,
	output [15:0] out
);
    
    wire load_hi, load_lo;

    wire [15:0] out_hi, out_lo;

    // if load: if address[8] load_hi else load_lo
    DMux dm_load (.in(load),.sel(address[8]),.a(load_lo),.b(load_hi));

    RAM256 ram_lo (.clk(clk),.address(address[7:0]),.in(in),.load(load_lo),.out(out_lo));
    RAM256 ram_hi (.clk(clk),.address(address[7:0]),.in(in),.load(load_hi),.out(out_hi));

    Mux16 mux_out (.a(out_lo),.b(out_hi),.sel(address[8]),.out(out));

endmodule

