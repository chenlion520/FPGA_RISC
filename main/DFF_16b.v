`timescale 1ns / 1ps

module DFF_16b(
    input [15:0]data,
	 input clk,rst_n,DFF_enable,
	 output reg [15:0]out
    );
	 always@(posedge clk or negedge rst_n)
	     if(!rst_n) out <= 16'b0;
		  else if(DFF_enable) out <= data;
		  else out <= out;
		  
endmodule
