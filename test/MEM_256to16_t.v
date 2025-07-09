`timescale 1ns / 1ps
module MEM_256to16_t;
	// Inputs
	reg [7:0] addr;
	reg [15:0] data;
	reg MemWrite;
	reg clk;
	// Outputs
	wire [15:0] out;
	// Instantiate the Unit Under Test (UUT)
	MEM_256to16 uut (
		.addr(addr), 
		.data(data), 
		.MemWrite(MemWrite), 
		.clk(clk), 
		.out(out)
	);
	always begin
	    #22.5 clk = ~clk;
	end
	initial begin
		// Initialize Inputs
		addr = 0;
		data = 0;
		MemWrite = 0;
		clk = 0;
		// === Write 0x1234 to address 0x01 ===
		#45 addr = 8'h01; data = 16'h1234;MemWrite = 1;
		#45  // write occurs here
		MemWrite = 0;
		#45;
		addr = 8'h01;
		#45
		$display("READ @01 = %h (expected: 1234)", out);
		// === Write 0xABCD to address 0x02 ===
		#45 addr = 8'h02;data = 16'hABCD;MemWrite = 1;
		#45 
		MemWrite = 0;
		#45
		addr = 8'h02;
		#45
		$display("READ @02 = %h (expected: ABCD)", out);
		// === Read uninitialized address 0xFF ===
		#45
		addr = 8'hFF;
		#45
		$display("READ @FF = %h (expected: 0000)", out);
		$finish;
	end
endmodule

