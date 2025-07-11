`default_nettype none
module And16_tb();
	
	// IN,OUT	
	reg [15:0] a,b;
	wire [15:0] out;

	// Part
	And16 AND16(
		.a(a),
		.b(b),
		.out(out)
	);
	
	// Compare
	wire [15:0] out_cmp;
	assign out_cmp = a&b;

	reg fail = 0;
	reg [15:0] n = 0;
	task check;
		#1
		if (out != out_cmp) 
			begin
				$display("FAIL: a=%16b, b=%16b, out=%16b",a,b,out);
				fail=1;
			end
	endtask
	  
	// Test
  	initial begin
  		$dumpfile("build/And16_tb.vcd");
  		$dumpvars(0, And16_tb);
		
		$display("------------------------");
		$display("Testbench: And16");
				
		for (n=0; n<10000;n=n+1) 
			begin
				a=$random;
				b=$random;
				check();
		
			end
		
		if (fail==0) $display("passed");
		$display("------------------------");
		$finish;
	end

endmodule
