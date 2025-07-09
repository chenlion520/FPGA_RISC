`timescale 1ns / 1ps
module RF_16b_t;
	reg [2:0] read_register0;
	reg [2:0] read_register1;
	reg [2:0] write_register;
	reg RegWrite;
	reg clk;
	reg rst_n;
	reg [15:0] write_data;
	wire [15:0] read_data0;
	wire [15:0] read_data1;
	RF_16b uut (
		.read_register0(read_register0), 
		.read_register1(read_register1), 
		.write_register(write_register), 
		.RegWrite(RegWrite), 
		.clk(clk), 
		.rst_n(rst_n), 
		.write_data(write_data), 
		.read_data0(read_data0), 
		.read_data1(read_data1)
	);
   always begin
	    #25 clk = ~clk;
	end
	initial begin
		read_register0 = 0;
		read_register1 = 0;
		write_register = 0;
		RegWrite = 0;
		clk = 0;
		rst_n = 0;
		write_data = 0;
		#100 rst_n = 1;RegWrite = 1;write_register = 3;write_data = 16'hAAAA;
		#50 RegWrite = 0;
		#50 RegWrite = 1;write_register = 5;write_data = 16'h5555;
		#50 RegWrite = 0;
		#50 RegWrite = 1;write_register = 2;write_data = 16'hffff;
		#50 RegWrite = 0;
		#50 RegWrite = 1;write_register = 1;write_data = 16'ha5a5;
		#50 RegWrite = 0;
		#50 read_register0 = 3;read_register1 = 5;
		#50 read_register0 = 2;read_register1 = 1;
    #100 $stop;
	end
endmodule

