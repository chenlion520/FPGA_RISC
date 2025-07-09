`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   15:37:53 05/01/2025
// Design Name:   decoder_3to8
// Module Name:   C:/FPGA/FPGA_CPU_VHDL/decoder_3to8_t.v
// Project Name:  FPGA_CPU_VHDL
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: decoder_3to8
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module decoder_3to8_t;

	// Inputs
	reg [2:0] in;
	reg decoder_enable;

	// Outputs
	wire [7:0] out;

	// Instantiate the Unit Under Test (UUT)
	decoder_3to8 uut (
		.in(in), 
		.decoder_enable(decoder_enable), 
		.out(out)
	);

	initial begin
		// Initialize Inputs
		in = 0;
		decoder_enable = 0;
		#10;in = 1;
		#10;in = 2;
		#10;in = 3;
		decoder_enable = 1;
		#10;in = 4;
		#10;in = 5;
		#10;in = 6;
		#10;in = 7;
		#100
		// Wait 100 ns for global reset to finish
		$finish;


        
		// Add stimulus here

	end
      
endmodule

