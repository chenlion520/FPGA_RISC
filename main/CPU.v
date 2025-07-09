`timescale 1ns / 1ps
module CPU(
    input clk,
	 input rst_n,
	 input [15:0]ext_addr,
	 input [15:0]ext_data,
	 input test,
	 input tMemWrite,
	 input  TestMem,
	 input start,
	 output [15:0]OutR,
	 output [4:0]state,
	 output [15:0]opcode,
	 output [15:0]TestMemout
    );
	 wire MemWrite				;
	 wire IRWrite	   		;
	 wire Imm_5or8			   ;
	 wire RegWrite			   ;
	 wire OutREn	   		;
	 wire [1:0]ALUop 		   ;
	 wire Branch				;
	                        
	 wire PSWEn			      ;
	 wire PCWrite			   ;
	 wire IorD				   ;
	 wire RegDst			   ;
	 wire [1:0]MemtoReg		;
	 wire LLorLH			   ;
	 wire ALUSrcA			   ;
	 wire [1:0]ALUSrcB	   ;
	 wire JAorJR			   ;
	 wire [1:0]PCSrc		   ;
	 wire test_memwirte;
	 assign dp_memwrite = test?tMemWrite:MemWrite;
	 datapath dp(
	 .rst_n(rst_n)				,
	 .clk(clk)					,
	 .MemWrite(dp_memwrite)	,	
	 .IRWrite(IRWrite)	   ,	
	 .Imm_5or8(Imm_5or8)		,	
	 .RegWrite(RegWrite)		,	
	 .OutREn(OutREn)	   	,	
	 .ALUop(ALUop) 			,	
	 .Branch(Branch)			,
	 .PSWEn(PSWEn)				,
	 .PCWrite(PCWrite)		,
	 .IorD(IorD)				,
	 .RegDst(RegDst)			,
    .MemtoReg(MemtoReg)		,
	 .LLorLH(LLorLH)			,
	 .ALUSrcA(ALUSrcA)		,
	 .ALUSrcB(ALUSrcB)		,
	 .JAorJR(JAorJR)			,
	 .PCSrc(PCSrc)				,
	 .ext_addr(ext_addr)		,
	 .ext_data(ext_data)		,
	 .test(test)				,
	 .TestMem(TestMem)		,
	 .OutR(OutR)				,
	 .TestMemout(TestMemout),
	 .opcode(opcode)
	 );
	 
	 wire clk_n = ~clk;
	 controller ctr(
	 .rst_n(rst_n)				,
	 .clk(clk_n)				,
	 .start(start)				,
	 .opcode(opcode)			,
	 .MemWrite(MemWrite)		,
	 .IRWrite(IRWrite)		,
	 .Imm_5or8(Imm_5or8)		,
	 .RegWrite(RegWrite)		,
	 .OutREn(OutREn)	   	,
	 .ALUop(ALUop) 			,
	 .Branch(Branch)			,
	 .PSWEn(PSWEn)				,
	 .PCWrite(PCWrite)		,
	 .IorD(IorD)				,
	 .RegDst(RegDst)			,
	 .MemtoReg(MemtoReg)		,
	 .LLorLH(LLorLH)			,
	 .ALUSrcA(ALUSrcA)		,
	 .ALUSrcB(ALUSrcB)		,
	 .JAorJR(JAorJR)			,
	 .PCSrc(PCSrc)				,
	 .state(state)
	 );
	 
endmodule
