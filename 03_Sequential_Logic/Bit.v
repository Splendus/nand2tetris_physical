/**
 * 1-bit register:
 * If load[t] == 1 then out[t+1] = in[t]
 *    else out does not change (out[t+1] = out[t])
 */

`default_nettype none
module Bit(
	input clk,
	input in,
	input load,
	output out
);

    wire dff_in;
    reg dff;

    Mux load_mux(.out(dff_in),.a(out),.b(in),.sel(load));
    DFF bit_register(.out(out),.in(dff_in),.clk(clk));


endmodule

