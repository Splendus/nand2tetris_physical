/**
 * 16-bit register:
 * If load[t] == 1 then out[t+1] = in[t]
 * else out does not change
 */

`default_nettype none

module Register(
	input clk,
	input [15:0] in,
	input load,
	output [15:0] out
);

    parameter N_BITS=16;

    genvar i;
    generate 
        for (i=0; i < N_BITS; i = i +1) begin
            Bit b(.clk(clk),.in(in[i]),.load(load),.out(out[i]));
        end
    endgenerate

endmodule

