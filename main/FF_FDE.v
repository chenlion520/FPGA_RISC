`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:45:19 05/06/2025 
// Design Name: 
// Module Name:    FF_FDE 
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
module FF_FDE(
	 input clk,
	 input enable,
	 input data,
	 output reg q
    );
	 
	 always@(posedge clk)
	 begin
		if(!enable) q <= 1'b0;
		else			q <= data;
	 end
	 


endmodule
