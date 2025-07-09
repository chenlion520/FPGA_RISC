`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   17:47:19 05/06/2025
// Design Name:   FF_FDE
// Module Name:   C:/FPGA/FPGA_CPU_VHDL/FF_FDE_t.v
// Project Name:  FPGA_CPU_VHDL
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: FF_FDE
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module FF_FDE_t;

	// Inputs
	reg clk;
	reg enable;
	reg data;

	// Outputs
	wire q;

	// Instantiate the Unit Under Test (UUT)
	FF_FDE uut (
		.clk(clk), 
		.enable(enable), 
		.data(data), 
		.q(q)
	);
	always begin
		#20 clk = ~clk;
	end
	initial begin
		// Initialize Inputs
		clk = 0;
		enable = 0;
		data = 0;
		
		#40
		data = 1;
		#40 
		enable = 1;
		#40 
		data = 0;
		#40 
		enable = 0;
		// Wait 100 ns for global reset to finish
		#100;
        $finish;
		// Add stimulus here

	end
      
endmodule

