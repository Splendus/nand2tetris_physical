/**
* RAM3840 implements 3840 Bytes of RAM addressed from 0 - 3839
* out = M[address]
* if (load =i= 1) M[address][t+1] = in[t]
*/

`default_nettype none
module RAM3840(
	input clk,
	input [11:0] address,
	input [15:0] in,
	input load,
	output [15:0] out
);

    wire load1, load2, load3, load4, load5, load6, load7, load8;
    wire [15:0] out1, out2, out3, out4, out5, out6, out7, out8;

    DMux8Way dm_load(.in(load),.sel(address[11:9]),.a(load1),.b(load2),.c(load3),.d(load4),.e(load5),.f(load6),.g(load7),.h(load8));
	
    // We have enough space for 7 512 Byte RAM blocks
    RAM512 ram1 (.clk(clk),.address(address[8:0]),.in(in),.load(load1),.out(out1));
    RAM512 ram2 (.clk(clk),.address(address[8:0]),.in(in),.load(load2),.out(out2));
    RAM512 ram3 (.clk(clk),.address(address[8:0]),.in(in),.load(load3),.out(out3));
    RAM512 ram4 (.clk(clk),.address(address[8:0]),.in(in),.load(load4),.out(out4));
    RAM512 ram5 (.clk(clk),.address(address[8:0]),.in(in),.load(load5),.out(out5));
    RAM512 ram6 (.clk(clk),.address(address[8:0]),.in(in),.load(load6),.out(out6));
    RAM512 ram7 (.clk(clk),.address(address[8:0]),.in(in),.load(load7),.out(out7));
    // and one 256 Byte RAM block

    RAM256 ram8 (.clk(clk),.address(address[7:0]),.in(in),.load(load8),.out(out8));

    Mux8Way16 mux_out (
        .a(out1),.b(out2),.c(out3),.d(out4),.e(out5),.f(out6),.g(out7),.h(out8),.sel(address[11:9]),.out(out)
    );

endmodule

