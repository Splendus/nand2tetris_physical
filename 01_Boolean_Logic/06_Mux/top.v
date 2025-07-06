`default_nettype none
module top(
	input a,
	input b,
	input sel,
	output out
);

    Mux MUX(.out(out),.a(a),.b(b),.sel(sel));    

endmodule

