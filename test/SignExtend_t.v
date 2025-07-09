`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   12:57:02 05/05/2025
// Design Name:   SignExtend
// Module Name:   C:/FPGA/FPGA_CPU_VHDL/SignExtend_t.v
// Project Name:  FPGA_CPU_VHDL
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: SignExtend
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module SignExtend_t;

	// Inputs
	reg [7:0] imm_8b;
	reg [4:0] imm_5b;
	reg imm_5or8;

	// Outputs
	wire [15:0] out;

	// Instantiate the Unit Under Test (UUT)
	SignExtend uut (
		.imm_8b(imm_8b), 
		.imm_5b(imm_5b), 
		.imm_5or8(imm_5or8), 
		.out(out)
	);

	initial begin
		// Initialize Inputs
		imm_8b = 0;
		imm_5b = 0;
		imm_5or8 = 0;
      #10
		imm_5b = 8'b0_0101;
		#10
		imm_5b = 8'b1_0101;
		#10 
		imm_5or8 = 1;
		imm_8b = 8'b1010_0101;
		#10
		imm_8b = 8'b0010_0101;
		
		// Wait 100 ns for global reset to finish
		#100;
      $finish;
		// Add stimulus here

	end
      
endmodule

