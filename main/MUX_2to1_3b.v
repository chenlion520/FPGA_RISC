`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    11:34:57 05/06/2025 
// Design Name: 
// Module Name:    MUX_2to1_3b 
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
module MUX_2to1_3b(
    input [2:0]in0,in1,
	 input select,
	 output reg [2:0]out
    );
	 always@(*)
	     case(select)
		      1'b0:out = in0;
				1'b1:out = in1;
		  endcase

endmodule