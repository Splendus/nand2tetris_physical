`default_nettype none
module top(
	input BUT1,
	input BUT2,
	output LED1,
	output LED2
);

	HalfAdder HA(.a(BUT1),.b(BUT2),.sum(LED1),.cout(LED2));
	
endmodule
