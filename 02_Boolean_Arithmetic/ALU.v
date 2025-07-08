/**
 * The ALU (Arithmetic Logic Unit).
 * Computes one of the following functions:
 * x+y, x-y, y-x, 0, 1, -1, x, y, -x, -y, !x, !y,
 * x+1, y+1, x-1, y-1, x&y, x|y on two 16-bit inputs, 
 * according to 6 input bits denoted zx,nx,zy,ny,f,no.
 * In addition, the ALU computes two 1-bit outputs:
 * if the ALU output == 0, zr is set to 1; otherwise zr is set to 0;
 * if the ALU output < 0, ng is set to 1; otherwise ng is set to 0.
 */

// Implementation: the ALU logic manipulates the x and y inputs
// and operates on the resulting values, as follows:
// if (zx == 1) set x = 0        // 16-bit constant
// if (nx == 1) set x = !x       // bitwise not
// if (zy == 1) set y = 0        // 16-bit constant
// if (ny == 1) set y = !y       // bitwise not
// if (f == 1)  set out = x + y  // integer 2's complement addition
// if (f == 0)  set out = x & y  // bitwise and
// if (no == 1) set out = !out   // bitwise not
// if (out == 0) set zr = 1
// if (out < 0) set ng = 1

`default_nettype none
module ALU(
	input [15:0] x,		    // input x (16 bit)
        input [15:0] y,		// input y (16 bit)
    input zx, 				// zero the x input?
    input nx, 				// negate the x input?
    input zy, 				// zero the y input?
    input ny, 				// negate the y input?
    input f,  				// compute out = x + y (if 1) or x & y (if 0)
    input no, 				// negate the out output?
    output [15:0] out, 		// 16-bit output
    output zr, 				// 1 if (out == 0), 0 otherwise
    output ng 				// 1 if (out < 0),  0 otherwise
);

/*
* The following version is fully functioning but a bit overblown. Below
* I implement a more efficient verilog version
*
*   wire [15:0] preprocX;
*   wire [15:0] notPreprocX;
*   wire [15:0] procX;
*
*   wire [15:0] preprocY;
*   wire [15:0] notPreprocY;
*   wire [15:0] procY;
*
*   wire [15:0] andXY;
*   wire [15:0] addXY;
*   wire [15:0] fXY;
*   wire [15:0] notFXY;
*
*   wire rightNotZero;
*   wire leftNotZero;
*
*   wire outNotZero;
*
*   Mux16 MUX_X0(.out(preprocX),.a(x),.b(16'd0),.sel(zx));
*   Not16 NOT_X(.out(notPreprocX),.in(preprocX));
*   Mux16 MUX_X1(.out(procX),.a(preprocX),.b(notPreprocX),.sel(nx));
*
*   Mux16 MUX_Y0(.out(preprocY),.a(y),.b(16'd0),.sel(zy));
*   Not16 NOT_Y(.out(notPreprocY),.in(preprocY));
*   Mux16 MUX_Y1(.out(procY),.a(preprocY),.b(notPreprocY),.sel(ny));
*
*   And16 AND_XY(.out(andXY),.a(procX),.b(procY));
*   Add16 ADD_XY(.out(addXY),.a(procX),.b(procY));
*   Mux16 MUX_XY0(.out(fXY),.a(andXY),.b(addXY),.sel(f));

*   Not16 NOT_FXY(.out(notFXY),.in(fXY));
*   Mux16 MUX_XY1(.out(out),.a(fXY),.b(notFXY),.sel(no));

*   // Check for all zeros
*   Or8Way OR_L(.out(rightNotZero),.in(out[7:0]));
*   Or8Way OR_R(.out(leftNotZero),.in(out[15:8]));
*   Or OR_OUT(.out(outNotZero),.a(rightNotZero),.b(leftNotZero));
*   Not NOT_OUT(.out(zr),.in(outNotZero));
*
*   // negative output is specified by most significant bit
*   assign ng = out[15];
*/

// 1) preprocess x and y 
    wire [15:0] zx_x = zx ? 16'd0 : x;      // if zx, zero x else x
    wire [15:0] nx_x = nx ? ~zx_x : zx_x;   // if nx, negate zx else zx

    // same for y
    wire [15:0] zy_y = zy ? 16'd0 : y;
    wire [15:0] ny_y = ny ? ~zy_y : zy_y;

// 2) compute fXY
    wire [15:0] f_xy = f ? nx_x + ny_y : nx_x & ny_y;

// 3) final out
    assign out = no ? ~f_xy : f_xy;

// 4) flags
    assign zr = ~|out;      // out is zero if no bit is 1
    assign ng = out[15];    // out is negative if MSB is 1

endmodule

