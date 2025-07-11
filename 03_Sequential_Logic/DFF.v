/**
* Data-Flip-Flop
* out[t+1] = in[t]
*/

`default_nettype none
module DFF(
		input clk,
		input in,
		output reg out          // registers reg store and output values

);

	// No need to implement this chip
	// This chip is implemented in verilog using reg-variables
	always @(posedge clk)       // executing on the rising edge of clk
        out <= in;              // non blocking assignments like '<=' update LHS at the end of the current simulation cycle

endmodule
