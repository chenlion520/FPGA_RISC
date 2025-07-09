`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   11:11:45 05/06/2025
// Design Name:   MUX_4to1
// Module Name:   C:/FPGA/FPGA_CPU_VHDL/MUX_4to1_t.v
// Project Name:  FPGA_CPU_VHDL
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: MUX_4to1
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module MUX_4to1_t;

	// Inputs
	reg [15:0] in0;
	reg [15:0] in1;
	reg [15:0] in2;
	reg [15:0] in3;
	reg [1:0] select;

	// Outputs
	wire [15:0] out;

	// Instantiate the Unit Under Test (UUT)
	MUX_4to1 uut (
		.in0(in0), 
		.in1(in1), 
		.in2(in2), 
		.in3(in3), 
		.select(select), 
		.out(out)
	);

	initial begin
		// Initialize Inputs
		in0 = 0;
		in1 = 0;
		in2 = 0;
		in3 = 0;
		select = 0;
      #10
		in0 = 1;
		in1 = 2;
		in2 = 3;
		in3 = 4;
		#10
		select = 1;
		#10
		select = 2;
		#10
		select = 3;
		// Wait 100 ns for global reset to finish
		#100;
        $finish;
		// Add stimulus here

	end
      
endmodule

