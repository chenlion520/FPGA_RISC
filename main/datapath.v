`timescale 1ns / 1ps
module datapath(
	 input rst_n,clk,
	 input MemWrite		,		
	 input IRWrite	   	,	
	 input Imm_5or8		,		
	 input RegWrite		,		
	 input OutREn	   	,	
	 input [1:0]ALUop 	,	
	 input Branch			,
	 input PSWEn			,
	 input PCWrite			,
	 input IorD				,
	 input RegDst			,
	 input [1:0]MemtoReg	,
	 input LLorLH			,
	 input ALUSrcA			,
	 input [1:0]ALUSrcB	,
	 input JAorJR			,
	 input [1:0]PCSrc		,
	 input [15:0]ext_addr,
	 input [15:0]ext_data,
	 input test,
	 input TestMem,
	 output [15:0]OutR,
	 output [15:0]TestMemout,
	 output [15:0]opcode
    );
	 wire [15:0]tomemaddr;
	 wire [15:0]tomemdata;
	 wire [15:0]PCout;
	 wire [15:0]pcnext;
	 wire PCEn;
	 wire [15:0]IorDout;
	 wire [15:0]adr;
	 wire [15:0]ALUout;
	 wire [15:0]Memout;
	 wire [15:0]Instr;
	 wire [15:0]Data;
	 wire [2:0]Rn;
	 wire [15:0]LLLHout;
	 wire [15:0]toreg;
	 wire [15:0]Regout0;
	 wire [15:0]Regout1;
	 wire [15:0]RA;
	 wire [15:0]RB;
	 wire [15:0]OutR;
	 wire [15:0]SrcA;
	 wire [15:0]Signout;
	 wire [15:0]SrcB;
	 wire N_flag,V_flag;
	 wire tmpc,tmpz;
	 wire toALU;
	 wire[15:0]ALUResult;
	 wire [15:0]JAJRout;
	 //pc//
	 assign PCEn = (PCWrite | (Branch & ((Instr[8]) ? ((Instr[9]) ? ~C_flag:~Z_flag):((Instr[9]) ? C_flag:Z_flag))));
	 PC pc(.clk(clk),.rst_n(rst_n),.PC_enable(PCEn),.PC_next(pcnext),.PC_result(PCout));
	
	 //IorD//
	 MUX_2to1 mux2to10(.in0(PCout),.in1(ALUout),.select(IorD),.out(adr));
	 
	 //mem//
	 //assign testmemwrite = test ? 1'b1:MemWrite;
	 MEM_256to16 mem256to16(.clk(clk),.addr(tomemaddr[7:0]),.data(tomemdata),.MemWrite(MemWrite),.out(Memout));
	
	 DFF_16b dff6(.clk(clk),.rst_n(rst_n),.data(Memout),.DFF_enable(TestMem),.out(TestMemout));
	 //irwrite//
	 DFF_16b dff0(.clk(clk),.rst_n(rst_n),.data(Memout),.DFF_enable(IRWrite),.out(Instr));
	 assign opcode = Instr;
	 DFF_16b dff1(.clk(clk),.rst_n(rst_n),.data(Memout),.DFF_enable(1'b1),.out(Data));
	 
	 //regdst¡Bmemtoreg//
	 MUX_2to1_3b mux2to13b(.in0(Instr[4:2]),.in1(Instr[10:8]),.select(RegDst),.out(Rn));
	 
	 MUX_4to1 mux4to10(.in0(ALUout),.in1(Data),.in2(LLLHout),.in3(PCout),.select(MemtoReg),.out(toreg));
	 
	 //registerfile//
	 RF_16b rf(.clk(clk),.rst_n(rst_n),.read_register0(Instr[7:5]),.read_register1(Rn),.write_register(Instr[10:8]),.write_data(toreg),.RegWrite(RegWrite),.read_data0(Regout0),.read_data1(Regout1));
	 
	 //LLLH//
	 MUX_2to1 mux2to12(.in0({8'h0,Instr[7:0]}),.in1({Instr[7:0],RB[7:0]}),.select(LLorLH),.out(LLLHout));
	 
	 //RA RB//
	 DFF_16b dff2(.clk(clk),.rst_n(rst_n),.data(Regout0),.DFF_enable(1'b1),.out(RA));
	 DFF_16b dff3(.clk(clk),.rst_n(rst_n),.data(Regout1),.DFF_enable(1'b1),.out(RB));
	 
	 //outr//
	 DFF_16b dff4(.clk(clk),.rst_n(rst_n),.data(Regout0),.DFF_enable(OutREn),.out(OutR));
	 
	 //ALUSrcA/B//
	 MUX_2to1 mux2to11(.in0(PCout),.in1(RA),.select(ALUSrcA),.out(SrcA));
	 MUX_4to1 mux4to11(.in0(RB),.in1(16'b1),.in2(Signout),.in3(16'b0),.select(ALUSrcB),.out(SrcB));
	 
	 //signextend//
	 SignExtend se(.imm_5b(Instr[4:0]),.imm_8b(Instr[7:0]),.imm_5or8(Imm_5or8),.out(Signout));
	 
	 //ALU//
	 wire C_flag,Z_flag;
	 DFF_16b dff7(.clk(clk),.rst_n(rst_n),.data(tmpz),.DFF_enable(PSWEn),.out(Z_flag));
	 DFF_16b dff8(.clk(clk),.rst_n(rst_n),.data(tmpc),.DFF_enable(PSWEn),.out(C_flag));
	 MUX_2to1_1b mux2to11b(.in0(1'b0),.in1(tmpc),.select(ALUop[0]),.out(toALU));
	 ALU_16b alu16b(.dataA(SrcA),.dataB(SrcB),.Cin(toALU),.sel(ALUop),.Sum(ALUResult),.C(tmpc),.Z(tmpz),.N(N_flag),.V(V_flag));
	 DFF_16b dff5(.clk(clk),.rst_n(rst_n),.data(ALUResult),.DFF_enable(1'b1),.out(ALUout));
	 
	 //JAorJR¡Bpcsrc//
	 MUX_4to1 mux4to12(.in0(ALUResult),.in1(ALUout),.in2({PCout[15:11],Instr[10:0]}),.in3(JAJRout),.select(PCSrc),.out(pcnext));
	 MUX_2to1 mux2to13(.in0(RA),.in1(RB),.select(JAorJR),.out(JAJRout));
	 
	 //testmem&data//
	 MUX_2to1 mux2to14(.in0(adr),.in1(ext_addr),.select(test),.out(tomemaddr));
	 MUX_2to1 mux2to15(.in0(RB),.in1(ext_data),.select(test),.out(tomemdata));
	 
endmodule
