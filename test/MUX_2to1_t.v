`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   11:08:31 05/06/2025
// Design Name:   MUX_2to1
// Module Name:   C:/FPGA/FPGA_CPU_VHDL/MUX_2to1_t.v
// Project Name:  FPGA_CPU_VHDL
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: MUX_2to1
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module MUX_2to1_t;

	// Inputs
	reg [15:0] in0;
	reg [15:0] in1;
	reg select;

	// Outputs
	wire [15:0]out;

	// Instantiate the Unit Under Test (UUT)
	MUX_2to1 uut (
		.in0(in0), 
		.in1(in1), 
		.select(select), 
		.out(out)
	);

	initial begin
		// Initialize Inputs
		in0 = 0;
		in1 = 0;
		select = 0;
      #10
		in0 = 1;
		in1 = 2;
		#10 
		select = 1;
		// Wait 100 ns for global reset to finish
		#100;
        $finish;
		// Add stimulus here

	end
      
endmodule

