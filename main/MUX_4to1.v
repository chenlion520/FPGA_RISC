`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    11:10:44 05/06/2025 
// Design Name: 
// Module Name:    MUX_4to1 
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
module MUX_4to1(
    input [15:0]in0,in1,in2,in3,
	 input [1:0]select,
	 output reg [15:0]out
    );
	 always@(*)
	     case(select)
		      2'b00:out = in0;
				2'b01:out = in1;
				2'b10:out = in2;
				2'b11:out = in3;
		  endcase

endmodule
