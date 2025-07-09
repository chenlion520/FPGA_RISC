`timescale 1ns / 1ps
module MEM_256to16(
    input [7:0]addr,
	 input [15:0]data,
	 input MemWrite,clk,
	 output [15:0]out
    );
	 
	 reg [15:0]mem[0:255];
	 assign out = mem[addr];
	 always @(posedge clk)
	     if(MemWrite) mem[addr] <= data;
endmodule
