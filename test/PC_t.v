`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   11:51:58 05/05/2025
// Design Name:   PC
// Module Name:   C:/FPGA/FPGA_CPU_VHDL/PC_t.v
// Project Name:  FPGA_CPU_VHDL
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: PC
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module PC_t;

	// Inputs
	reg clk;
	reg rst_n;
	reg PC_enable;
	reg [15:0] PC_next;

	// Outputs
	wire [15:0] PC_result;

	// Instantiate the Unit Under Test (UUT)
	PC uut (
		.clk(clk), 
		.rst_n(rst_n), 
		.PC_enable(PC_enable), 
		.PC_next(PC_next), 
		.PC_result(PC_result)
	);
	always #20 clk = ~clk;
	initial begin
		// Initialize Inputs
		clk = 0;
		rst_n = 0;
		PC_enable = 0;
		PC_next = 0;

		#60;
		rst_n = 1;
		
		PC_next = 16'd3;
		PC_enable = 1;
		#60;


		PC_next = 16'd8;
		#60;

	
		PC_enable = 0;
		PC_next = 16'd100; 
		#100;
		$finish;
        
		// Add stimulus here

	end
      
endmodule

