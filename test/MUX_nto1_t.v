`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   11:02:51 05/06/2025
// Design Name:   MUX_nto1
// Module Name:   C:/FPGA/FPGA_CPU_VHDL/MUX_nto1_t.v
// Project Name:  FPGA_CPU_VHDL
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: MUX_nto1
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module MUX_nto1_t;

	// Inputs
	reg [0:0] select;
	reg [15:0] in;

	// Instantiate the Unit Under Test (UUT)
	MUX_nto1 #(.N(4)) uut (
		.select(select), 
		.in(in)
	);

	initial begin
		// Initialize Inputs
		select = 0;
		in = 0;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here

	end
      
endmodule

