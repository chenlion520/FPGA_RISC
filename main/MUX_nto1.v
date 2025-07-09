`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    13:45:29 05/05/2025 
// Design Name: 
// Module Name:    MUX_nto1 
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
module MUX_nto1
    #(parameter N = 2)//nto1
	  (input [$clog2(N)-1:0]select,
		input [15:0]in[N],
		output reg [15:0]out
    );

	 assign out = in[select];
endmodule
