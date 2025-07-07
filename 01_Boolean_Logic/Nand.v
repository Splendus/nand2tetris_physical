/**
* Nand gate:
* out = 0 if (a == 1 and b == 1)
*       1 else
*/

`default_nettype none
module Nand(
        input a,
        input b,
        output out
);

        // Chip is implemented using verilog primitives
        nand(out,a,b);

endmodule

