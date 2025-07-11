/**
* 9 bit Shiftregister (shifts to right)
* if      (load == 1)  out[t+1] = in[t]
* else if (shift == 1) out[t+1] = out[t]>>1 | (inMSB<<8)
* (shift one position to right and insert inMSB as most significant bit)
*/

`default_nettype none
module BitShift9R(
	input clk,
	input [8:0] in,
	input inMSB,
	input load,
	input shift,
	output [8:0] out
);

    wire [8:0] shift_out, load_out;
    wire load_bit;


    Mux mux_shift0 (.out(shift_out[0]),.a(out[0]),.b(out[1]),.sel(shift));
    Mux mux_shift1 (.out(shift_out[1]),.a(out[1]),.b(out[2]),.sel(shift));
    Mux mux_shift2 (.out(shift_out[2]),.a(out[2]),.b(out[3]),.sel(shift));
    Mux mux_shift3 (.out(shift_out[3]),.a(out[3]),.b(out[4]),.sel(shift));
    Mux mux_shift4 (.out(shift_out[4]),.a(out[4]),.b(out[5]),.sel(shift));
    Mux mux_shift5 (.out(shift_out[5]),.a(out[5]),.b(out[6]),.sel(shift));
    Mux mux_shift6 (.out(shift_out[6]),.a(out[6]),.b(out[7]),.sel(shift));
    Mux mux_shift7 (.out(shift_out[7]),.a(out[7]),.b(out[8]),.sel(shift));
    Mux mux_shift8 (.out(shift_out[8]),.a(out[8]),.b(inMSB),.sel(shift));

    Mux mux_load0 (.out(load_out[0]),.a(shift_out[0]),.b(in[0]),.sel(load));
    Mux mux_load1 (.out(load_out[1]),.a(shift_out[1]),.b(in[1]),.sel(load));
    Mux mux_load2 (.out(load_out[2]),.a(shift_out[2]),.b(in[2]),.sel(load));
    Mux mux_load3 (.out(load_out[3]),.a(shift_out[3]),.b(in[3]),.sel(load));
    Mux mux_load4 (.out(load_out[4]),.a(shift_out[4]),.b(in[4]),.sel(load));
    Mux mux_load5 (.out(load_out[5]),.a(shift_out[5]),.b(in[5]),.sel(load));
    Mux mux_load6 (.out(load_out[6]),.a(shift_out[6]),.b(in[6]),.sel(load));
    Mux mux_load7 (.out(load_out[7]),.a(shift_out[7]),.b(in[7]),.sel(load));
    Mux mux_load8 (.out(load_out[8]),.a(shift_out[8]),.b(in[8]),.sel(load));

    Or or_load (.out(load_bit),.a(shift),.b(load));

    Bit bit_out0 (.out(out[0]),.in(load_out[0]),.clk(clk),.load(load_bit));
    Bit bit_out1 (.out(out[1]),.in(load_out[1]),.clk(clk),.load(load_bit));
    Bit bit_out2 (.out(out[2]),.in(load_out[2]),.clk(clk),.load(load_bit));
    Bit bit_out3 (.out(out[3]),.in(load_out[3]),.clk(clk),.load(load_bit));
    Bit bit_out4 (.out(out[4]),.in(load_out[4]),.clk(clk),.load(load_bit));
    Bit bit_out5 (.out(out[5]),.in(load_out[5]),.clk(clk),.load(load_bit));
    Bit bit_out6 (.out(out[6]),.in(load_out[6]),.clk(clk),.load(load_bit));
    Bit bit_out7 (.out(out[7]),.in(load_out[7]),.clk(clk),.load(load_bit));
    Bit bit_out8 (.out(out[8]),.in(load_out[8]),.clk(clk),.load(load_bit));

endmodule

