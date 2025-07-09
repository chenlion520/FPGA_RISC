`timescale 1ns / 1ps
module full_adder(
    input A,B,Cin,
	 output reg Sum,Cout
    );
    always@(*)begin
	     Sum = A^B^Cin;
		  Cout = (A&B)|((A^B)&Cin);
	 end

endmodule
