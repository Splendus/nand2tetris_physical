`define SIM
`timescale 1ns/1ns
`default_nettype none
module blinky_tb();

	// IN,OUT
	reg CLK=1;
    reg[1:0] BUT;
	wire[1:0] LED;

	// Part
	blinky blinky(
		.CLK(CLK),
        .BUT(BUT),
		.LED(LED)
	);
	
	// Simulate
	always #1 CLK=~CLK;

  	initial begin
  		$dumpfile("build/blinky_tb.vcd");
  		$dumpvars(0, blinky_tb);
        // resets are inverted in blinky as buttons drive low
        BUT[0] = 0;     // pre_reset
        BUT[1] = 0;     // reset
        #20;
        BUT[0] = 1;
        #20;
        BUT[1] = 1;
		#100000;
		$finish;
	end

endmodule
