`default_nettype none
module FullAdder_tb();

	// IN,OUT
	reg a,b,cin;
	wire sum,cout;

	// Part
	FullAdder FULLADDER(
		.a(a),
		.b(b),
		.cin(cin),
		.sum(sum),
		.cout(cout)
	);

	// Compare
	wire [1:0] out_cmp;
	assign out_cmp = a+b+cin;

	reg fail = 0;
	task check;
		#1
		if ({cout,sum} != out_cmp) 
			begin
				$display("FAIL: a=%1b, b=%1b, cin=%1b, sum=%1b, cout=%1b",a,b,cin,sum,cout);
				fail=1;
			end
	endtask
	  
  	initial begin
  		$dumpfile("build/FullAdder_tb.vcd");
  		$dumpvars(0, FullAdder_tb);
		
		$display("------------------------");
		$display("Testbench: FullAdder");
		
		a=0;b=0;cin=0;check();
		a=0;b=0;cin=1;check();
		a=0;b=1;cin=0;check();
		a=0;b=1;cin=1;check();
		a=1;b=0;cin=0;check();
		a=1;b=0;cin=1;check();
		a=1;b=1;cin=0;check();
		a=1;b=1;cin=1;check();
		
		if (fail==0) $display("passed");
		$display("------------------------");
		$finish;
	end

endmodule
