`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   20:33:37 05/07/2025
// Design Name:   CPU
// Module Name:   C:/FPGA/FPGA_CPU_VHDL/CPU_t.v
// Project Name:  FPGA_CPU_VHDL
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: CPU
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module CPU_t;

	// Inputs
	reg clk;
	reg rst_n;
	reg tMemWrite;
	reg [15:0] ext_addr;
	reg [15:0] ext_data;
	reg test;
	reg  TestMem;
	reg start;
	parameter clk_period = 20;
	parameter delay_factor = 2;
	// Outputs
	wire [15:0] OutR;
	wire [4:0] state;
	wire [15:0] opcode;
	wire [15:0]TestMemout;
	// Instantiate the Unit Under Test (UUT)
	integer i;
	CPU uut (
		.clk(clk), 
		.rst_n(rst_n), 
		.ext_addr(ext_addr), 
		.ext_data(ext_data), 
		.test(test), 
		.start(start),
		.TestMem(TestMem),
		.tMemWrite(tMemWrite),
		.OutR(OutR), 
		.state(state), 
		.opcode(opcode),
		.TestMemout(TestMemout)
	);
	always begin
		#(clk_period/2)clk <= 1'b0;
		#(clk_period/2)clk <= 1'b1;
	end
	initial begin
		// Initialize Inputs
		clk = 0;
		rst_n = 0;
		ext_addr = 0;
		ext_data = 0;
		test = 0;
		tMemWrite = 0;
		TestMem = 0;
		start = 0;
		
		rst_n <= 1'b0;test = 1'b0;
		repeat (2) @(posedge clk)
						#(clk_period/delay_factor)rst_n <= 1'b0;
		rst_n <= 1'b1;test = 1'b1;

		write_mem(16'h0,16'b0001_0000_0000_0000); //LLI R0,0h//迴圈初始
		write_mem(16'h1,16'b1110_0000_0000_0000); //OUT R0 (0h)
		write_mem(16'h2,16'b0001_0010_0010_0101); //LLI R2,25H//地址
		write_mem(16'h3,16'b1110_0000_0100_0000); //OUT R2 (25H)
		write_mem(16'h4,16'b0001_0001_0000_0011); //LLI R1,#3//三個值
		write_mem(16'h5,16'b1110_0000_0010_0000); //OUT R1 (3H)

		//move
		write_mem(16'h6,16'b0001_1011_0100_0011); //LDR R3,R2,#3
		write_mem(16'h7,16'b1110_0000_0110_0000); //OUT R3 (7H)
		write_mem(16'h8,16'b0010_1011_0100_0000); //STR Mem\[R2+#0]<- R3//把mem的值存在暫存器
		write_mem(16'h9,16'b0011_1000_0000_0001); //ADDI R0,R0,#1
		write_mem(16'hA,16'b0011_1010_0100_0001); //ADDI R2,R2,#1
		write_mem(16'hB,16'b0100_0001_0010_0001); //SUBI R1,R1,#1
		write_mem(16'hC,16'b1100_0001_1111_1001); //BNE if R1 != 0
		//PC <- PC-7

		write_mem(16'hD,16'b0001_0000_0010_0101); //LLI R0,25H
		write_mem(16'hE,16'b0001_0001_0000_0011); //LLI R1,#3
		//read
		write_mem(16'hF,16'b0001_1010_0000_0000); //LDR R2,R0,#0
		write_mem(16'h10,16'b1110_0000_0100_0000); //OUT R2
		write_mem(16'h11,16'b0011_1000_0000_0001); //ADDI R0,R0,#1
		write_mem(16'h12,16'b0100_0001_0010_0001); //SUBI R1,R1,#1
		write_mem(16'h13,16'b1100_0001_1111_1011); //BNE if R1 != 0
		//PC <- PC-5
		write_mem(16'h28,16'h7); //data (31h, 07h)
		write_mem(16'h29,16'h8); //data (32h, 08h)
		write_mem(16'h2a,16'h9); //data (33h, 09h)

		@(posedge clk)#(clk_period/delay_factor) tMemWrite = 1'b0;
		 test = 1'b1;
		for(i = 0 ; i < 23 ; i = i + 1)
			@(posedge clk) #(clk_period/delay_factor) ext_addr = i;
		test = 1'b0;
		rst_n = 1'b1;
		repeat (2) @(posedge clk)
						#(clk_period/delay_factor) rst_n = 1'b0;
		rst_n = 1'b1;
		TestMem = 1;
		start = 1;
	end
	task write_mem;
	input [15:0] addr,data;
	begin
		@(posedge clk)#(clk_period/delay_factor)begin
			test = 1'b1;
			tMemWrite = 1'b1;
			ext_addr = addr;
			ext_data = data;
			TestMem = 1'b1;
		end
	end
	endtask
	
	initial #5000 $finish;
	//initial
		//$monitor($realtime ,"ns %h %h %h %h %h %h %h %h \n ",clk,rst_n,TestMem,test,ext_addr,ext_data,TestMemout,OutR);
      
endmodule

