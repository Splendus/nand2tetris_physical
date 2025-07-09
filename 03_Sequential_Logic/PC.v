/**
 * A 16-bit counter with load and reset control bits.
 * if      (reset[t] == 1) out[t+1] = 0
 * else if (load[t] == 1)  out[t+1] = in[t]
 * else if (inc[t] == 1)   out[t+1] = out[t] + 1  (integer addition)
 * else                    out[t+1] = out[t]
 */

`default_nettype none
module PC(
	input clk,
	input [15:0] in,
	input load,
	input inc,
	input reset,
	output [15:0] out
);	
    
    wire [15:0] inc_out;
    wire [15:0] out_plus1;

    wire [15:0] load_out;

    wire [15:0] res_out;

    wire or_inc_load;
    wire or_all;

    Inc16 out_inc (.out(out_plus1),.in(out));

	Mux16 inc_mux (.out(inc_out),.a(out),.b(out_plus1),.sel(inc));
	Mux16 load_mux (.out(load_out),.a(inc_out),.b(in),.sel(load));
	Mux16 reset_mux (.out(res_out),.a(load_out),.b(16'b0),.sel(reset));

    Or or1 (.out(or_inc_load),.a(inc),.b(load));
    Or or2 (.out(or_all),.a(reset),.b(or_inc_load));

    Register pc_out (.out(out),.in(res_out),.clk(clk),.load(or_all));

endmodule

