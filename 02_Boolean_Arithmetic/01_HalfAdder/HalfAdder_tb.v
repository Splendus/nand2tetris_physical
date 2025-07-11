`default_nettype none
module HalfAdder_tb();

	// IN,OUT
	reg a,b;
	wire sum,cout;

	// Part
	HalfAdder HALFADDER(
		.a(a),
		.b(b),
		.sum(sum),
		.cout(cout)
	);

	// Compare
	wire [1:0] out_cmp;
	assign out_cmp = a+b;
	
	reg fail = 0;
	task check;
		#1
		if ({cout,sum} != out_cmp) 
			begin
				$display("FAIL: a=%1b, b=%1b, sum=%1b, cout=%1b",a,b,sum,cout);
				fail=1;
			end
	endtask
	  
  	initial begin
  		$dumpfile("build/HalfAdder_tb.vcd");
  		$dumpvars(0, HalfAdder_tb);
		
		$display("------------------------");
		$display("Testbench: HalfAdder");
		
		a=0;b=0;check();
		a=0;b=1;check();
		a=1;b=0;check();
		a=1;b=1;check();
		
		if (fail==0) $display("passed");
		$display("------------------------");
		$finish;
	end

endmodule
