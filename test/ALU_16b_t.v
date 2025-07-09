`timescale 1ns / 1ps
module ALU_16b_t;

	// Inputs
	reg [15:0] dataA;
	reg [15:0] dataB;
	reg [1:0] sel;
	reg Cin;

	// Outputs
	wire [15:0] Sum;
	wire C;
	wire Z;
	wire N;
	wire V;

	// Instantiate the Unit Under Test (UUT)
	ALU_16b uut (
		.dataA(dataA), 
		.dataB(dataB), 
		.sel(sel), 
		.Cin(Cin), 
		.Sum(Sum), 
		.C(C), 
		.Z(Z), 
		.N(N), 
		.V(V)
	);

	initial begin
		// Initialize Inputs
		dataA = 0;
		dataB = 0;
		sel = 0;
		Cin = 0;
		$display("Time\tsel\tCin\tA\tB\t=> Sum\t C Z N V");
		
		// 代刚 ADDA + B
		#20 dataA = 16'h0003; dataB = 16'h0005; sel = 2'b00; Cin = 0;
		#20 $display("%t\t%2b\t%b\t%h\t%h\t=> %h\t%b %b %b %b", $time, sel, Cin, dataA, dataB, Sum, C, Z, N, V);

		// 代刚 ADCA + B + 1
		#20 dataA = 16'h0001; dataB = 16'h0002; sel = 2'b01; Cin = 1;
		#20 $display("%t\t%2b\t%b\t%h\t%h\t=> %h\t%b %b %b %b", $time, sel, Cin, dataA, dataB, Sum, C, Z, N, V);

		// 代刚 SUBA - B
		#20 dataA = 16'h0005; dataB = 16'h0003; sel = 2'b10; Cin = 0;
		#20 $display("%t\t%2b\t%b\t%h\t%h\t=> %h\t%b %b %b %b", $time, sel, Cin, dataA, dataB, Sum, C, Z, N, V);

		// 代刚 SUB  0
		#20 dataA = 16'h1234; dataB = 16'h1234; sel = 2'b10; Cin = 0;
		#20 $display("%t\t%2b\t%b\t%h\t%h\t=> %h\t%b %b %b %b", $time, sel, Cin, dataA, dataB, Sum, C, Z, N, V);

		// 代刚 SBBA - B - 1
		#20 dataA = 16'h0005; dataB = 16'h0003; sel = 2'b11; Cin = 1;
		#20 $display("%t\t%2b\t%b\t%h\t%h\t=> %h\t%b %b %b %b", $time, sel, Cin, dataA, dataB, Sum, C, Z, N, V);

		// 代刚 overflowタ计 + タ计 => 璽计
		#20 dataA = 16'h7FFF; dataB = 16'h0001; sel = 2'b00; Cin = 0;
		#20 $display("%t\t%2b\t%b\t%h\t%h\t=> %h\t%b %b %b %b", $time, sel, Cin, dataA, dataB, Sum, C, Z, N, V);

		// 代刚璽计搭タ计 => 璽
		#20 dataA = 16'h8000; dataB = 16'h0001; sel = 2'b10; Cin = 0;
		#20 $display("%t\t%2b\t%b\t%h\t%h\t=> %h\t%b %b %b %b", $time, sel, Cin, dataA, dataB, Sum, C, Z, N, V);
		#100;
		$finish;
	end
      
endmodule

