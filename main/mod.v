`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:18:09 05/13/2025 
// Design Name: 
// Module Name:    mod 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module mod(
	input clk,enable,rst,
	output reg [1:0]count,
	output reg clk3
    );
	 wire c;
	 assign c = (count == 2'd2); 
	 assign clk3 = (c) ? ~clk3 : clk3;
	 always @(posedge clk)begin
		if(rst)begin
			count <= 2'd0;
			clk3 <= clk;
			end
		else if(enble) if(c) count <= 2'd0;else count <= count + 1;
	 end


endmodule
