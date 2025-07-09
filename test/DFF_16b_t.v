`timescale 1ns / 1ps
module DFF_16b_t;
	reg [15:0] data;
	reg clk;
	reg rst_n;
	reg DFF_enable;
	wire [15:0] out;
	DFF_16b uut (
		.data(data), 
		.clk(clk), 
		.rst_n(rst_n), 
		.DFF_enable(DFF_enable), 
		.out(out)
	);
	always begin
	    #10 clk = ~clk;
	end
	initial begin
		data = 0;
		clk = 0;
		rst_n = 0;
		DFF_enable = 0;
      #35
		rst_n = 1;
		data = 10;
		#35
		data = 20;
		#35
		data = 30;
		#35
		DFF_enable = 1;
		data = 40;
		#35
		data = 10;
		#35
		rst_n = 0;
		data = 20;
		#35
		rst_n = 1;
		data = 10;
		#100;
      $finish;
	end
endmodule

