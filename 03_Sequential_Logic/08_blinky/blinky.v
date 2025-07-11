// Test to run on fpga with 100 MHz
`default_nettype none
module blinky(
	input CLK=0,
    input [1:0] BUT,
	output [1:0] LED
);

    wire pre_reset = ~BUT[0];    // reset for prescaler
    wire reset = ~BUT[1];        // reset for counter
	wire [15:0] prescaler;
	wire clk;


    // Since the least significant bit will increment too fast, we prescale by
    // taking as clock input to the counter a more significant bit
	PC PRESCALER(.clk(CLK),.load(1'b0),.in(16'b0),.reset(pre_reset),.inc(1'b1),.out(prescaler));
    `ifdef SIM
        assign clk = prescaler[2];
    `else
        Buffer 	CLOCK(.in(prescaler[10]),.out(clk));
    `endif

	wire [15:0] counter;
	PC COUNTER(.clk(clk),.load(1'b0),.in(16'b0),.reset(reset),.inc(1'b1),.out(counter));
    `ifdef SIM
        Buffer BUF1(.in(counter[6]),.out(LED[1]));
        Buffer BUF2(.in(counter[7]),.out(LED[0]));
    `else
        Buffer BUF1(.in(counter[15]),.out(LED[1]));
        Buffer BUF2(.in(counter[14]),.out(LED[0]));
    `endif

endmodule
