`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    12:38:01 05/05/2025 
// Design Name: 
// Module Name:    SignExtend 
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
module SignExtend(//for LDR STR ADDI SUBI B JAL
    input [7:0]imm_8b,
	 input [4:0]imm_5b,
	 input imm_5or8,//5 == 0 ,8 == 1
	 output [15:0]out
    );
	 
	 assign out = (imm_5or8) ? {{8{imm_8b[7]}},imm_8b}:{{11{imm_5b[4]}},imm_5b};


endmodule
