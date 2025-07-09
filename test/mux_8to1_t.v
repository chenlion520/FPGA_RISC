`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   14:55:46 05/01/2025
// Design Name:   mux_8to1
// Module Name:   C:/FPGA/FPGA_CPU_VHDL/mux_8to1_t.v
// Project Name:  FPGA_CPU_VHDL
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: mux_8to1
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module mux_8to1_t;

	// Inputs
	reg [2:0] sel;
	reg [15:0] in0;
	reg [15:0] in1;
	reg [15:0] in2;
	reg [15:0] in3;
	reg [15:0] in4;
	reg [15:0] in5;
	reg [15:0] in6;
	reg [15:0] in7;

	// Outputs
	wire [15:0] out;

	// Instantiate the Unit Under Test (UUT)
	mux_8to1 uut (
		.sel(sel), 
		.in0(in0), 
		.in1(in1), 
		.in2(in2), 
		.in3(in3), 
		.in4(in4), 
		.in5(in5), 
		.in6(in6), 
		.in7(in7), 
		.out(out)
	);

	initial begin
		// Initialize Inputs
		sel = 0;
		in0 = 5;
		in1 = 6;
		in2 = 12;
		in3 = 16;
		in4 = 9;
		in5 = 10;
		in6 = 25;
		in7 = 33;
		#10
		sel = 1;
		in0 = 5;
		in1 = 6;
		in2 = 12;
		in3 = 16;
		in4 = 9;
		in5 = 10;
		in6 = 25;
		in7 = 33;
		#10
		sel = 2;
		in0 = 5;
		in1 = 6;
		in2 = 12;
		in3 = 16;
		in4 = 9;
		in5 = 10;
		in6 = 25;
		in7 = 33;
		#10
		sel = 3;
		in0 = 5;
		in1 = 6;
		in2 = 12;
		in3 = 16;
		in4 = 9;
		in5 = 10;
		in6 = 25;
		in7 = 33;
		#10
		sel = 4;
		in0 = 5;
		in1 = 6;
		in2 = 12;
		in3 = 16;
		in4 = 9;
		in5 = 10;
		in6 = 25;
		in7 = 33;
		#10
		sel = 5;
		in0 = 5;
		in1 = 6;
		in2 = 12;
		in3 = 16;
		in4 = 9;
		in5 = 10;
		in6 = 25;
		in7 = 33;
		#10
		sel = 6;
		in0 = 5;
		in1 = 6;
		in2 = 12;
		in3 = 16;
		in4 = 9;
		in5 = 10;
		in6 = 25;
		in7 = 33;
		#10
		sel = 7;
		in0 = 5;
		in1 = 6;
		in2 = 12;
		in3 = 16;
		in4 = 9;
		in5 = 10;
		in6 = 25;
		in7 = 33;
		// Wait 100 ns for global reset to finish
		#100;
      $finish;
		// Add stimulus here

	end
      
endmodule

