`timescale 1ns / 1ps
module PC(
    input clk,rst_n,PC_enable,
	 input [15:0]PC_next,
	 output reg [15:0]PC_result
    );
	 always@(posedge clk or negedge rst_n)begin
	     if(!rst_n)PC_result <= 0;
		  else if(PC_enable)PC_result <= PC_next ;
    end

endmodule
