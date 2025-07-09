`timescale 1ns / 1ps
module controller(
	 input rst_n,clk				,
	 input [15:0]opcode			,
	 input start					,
	 output reg MemWrite			,
	 output reg IRWrite	   	,
	 output reg Imm_5or8			,
	 output reg RegWrite			,
	 output reg OutREn	   	,
	 output reg [1:0]ALUop 		,
	 output reg Branch			,
 
	 output reg PSWEn				,
	 output reg PCWrite			,
	 output reg IorD				,
	 output reg RegDst			,
	 output reg [1:0]MemtoReg	,
	 output reg LLorLH			,
	 output reg ALUSrcA			,
	 output reg [1:0]ALUSrcB	,
	 output reg JAorJR			,
	 output reg [1:0]PCSrc		,
	 
	 output reg [4:0]state
    );
	 //設定指令的opcode//
	 parameter LHI	= 5'b00001			;
	 parameter LLI	= 5'b00010			;
	 parameter LDR_imm = 5'b00011		;
	 parameter LDR	= 5'b00100 			;
	 parameter STR_imm = 5'b00101		;
	 parameter STR	= 5'b00110			;
	 parameter ADD	= 5'b00000			;
	 parameter ADC	= 5'b00000			;
	 parameter SUB	= 5'b00000			;
	 parameter SBB	= 5'b00000			;
	 parameter CMP	= 5'b00110			;
	 parameter ADDI = 5'b00111			;	
	 parameter SUBI = 5'b01000			;	
	 parameter MOV	= 5'b01011			;
	 parameter BCC	= 8'b1100_0011		;
	 parameter BCS	= 8'b1100_0010		;
	 parameter BNE	= 8'b1100_0001		;
	 parameter BEQ	= 8'b1100_0000		;
	 parameter BAL	= 8'b1100_1110		;
	 parameter JMP	= 5'b10000			;
	 parameter JAL_label	= 5'b10001	;
	 parameter JAL	= 5'b10010			;
	 parameter JR = 5'b10011			;
	 parameter OutR = 5'b11100			;


	
	always @(posedge clk)begin
		if(!rst_n || !start) state <= 5'd0;
		else
		begin
		    case(state)
			     5'd0:
				      state <= 5'd1;
				  5'd1:
				      if(opcode[15:11] == LHI || opcode[15:11] == LDR_imm || opcode[15:11] == STR_imm || opcode[15:11] == JR)begin
						    state <= 5'd2;
						end
						else if(opcode[15:11] == LLI)begin
						    state <= 5'd8;
						end
						else if(opcode[15:11] == LDR || (opcode[15:11] == STR && opcode[1:0] == 2'b00))begin
						    state <= 5'd9;
						end
						else if(opcode[15:11] == ADD && opcode[1:0] == 2'b00)begin
						    state <= 5'd12;
						end
						else if(opcode[15:11] == ADC && opcode[1:0] == 2'b01)begin
						    state <= 5'd14;
						end
						else if((opcode[15:11] == SUB && opcode[1:0] == 2'b10)|| (opcode[15:11] == CMP && opcode[1:0] == 2'b01))begin
						    state <= 5'd15;
						end
						else if(opcode[15:11] == SBB && opcode[1:0] ==2'b11)begin
						    state <= 5'd16;
						end
						else if(opcode[15:11] == ADDI)begin
						    state <= 5'd17;
						end
						else if(opcode[15:11] == SUBI)begin
						    state <= 5'd18;
						end
						else if(opcode[15:11] == MOV)begin
						    state <= 5'd19;
						end
						else if(opcode[15:8] == BCC || opcode[15:8] == BCS || opcode[15:8] == BNE || opcode[15:8] == BEQ)begin
						    state <= 5'd20;
						end
						else if(opcode[15:8] == BAL)begin
						    state <= 5'd21;
						end
						else if(opcode[15:11] == JMP)begin
						    state <= 5'd22;
						end
						else if(opcode[15:11] == JAL_label)begin
						    state <= 5'd23;
						end
						else if(opcode[15:11] == JAL)begin
						    state <= 5'd24;
						end
						else if(opcode[15:11] == OutR)begin
						    state <= 5'd25;
						end
				 5'd2:
				      if(opcode[15:11] == LHI)begin
						    state <= 5'd3;
					   end
						else if(opcode[15:11] == LDR_imm)begin
							 state <= 5'd4;
						end
						else if(opcode[15:11] == STR_imm)begin
							 state <= 5'd6;
						end
						else if(opcode[15:11] == JR)begin
							 state <= 5'd7;
					   end
				 5'd4:
				      state <= 5'd5;
				 5'd9:
						if(opcode[15:11] == LDR)begin
						    state <= 5'd10;
						end
						else if(opcode[15:11] == STR)begin
						    state <= 5'd11;
						end
				 5'd10:
						state <= 5'd5;
				 5'd12,5'd14,5'd16,5'd17,5'd18,5'd19:
						state <= 5'd13;
				 5'd15:
						if(opcode[15:11] == SUB)begin
						    state <= 5'd13;
						end
						else if(opcode[15:11] == CMP)begin
						    state <= 5'd0;
						end
				 default: 
					state <= 5'd0;
			 endcase
		end
	end
	always @(state)begin
		 Imm_5or8 = 0;
		 IorD = 0;
		 ALUSrcA = 0;
		 ALUSrcB = 2'b00;
		 ALUop = 2'b00;
		 PCSrc = 2'b00;
		 Branch = 0;
		 PCWrite = 0;
		 MemWrite = 0;
		 IRWrite = 0;
		 PSWEn = 0;
		 OutREn = 0;
		 RegWrite = 0;
		 RegDst = 0;
		 MemtoReg = 2'b00;
		 LLorLH = 0;
		 JAorJR = 0;
	    case(state)
		     5'd0:
			      begin
			          IorD = 0; ALUSrcA = 0; ALUSrcB = 2'b01; ALUop = 2'b00; PCSrc = 2'b00;
						 Branch = 0; PCWrite = 1; MemWrite = 0; IRWrite = 1; PSWEn = 0;OutREn = 0; RegWrite = 0;
					end
			  5'd1:
			      begin
					    Imm_5or8 = 1;IorD = 0;ALUSrcA = 0;ALUSrcB = 2'b10;ALUop = 2'b00;PCSrc = 2'b00;Branch = 0;PCWrite = 0;
						 MemWrite = 0;IRWrite = 0;PSWEn = 0;OutREn = 0;RegWrite = 0;RegDst = 0;MemtoReg = 2'b00;LLorLH = 0;JAorJR = 0;
					end
			  5'd2:
					begin
					    Imm_5or8 = 0;IorD = 0;ALUSrcA = 1;ALUSrcB = 2'b10;ALUop = 2'b00;PCSrc = 2'b00;Branch = 0;PCWrite = 0;
						 MemWrite = 0;IRWrite = 0;PSWEn = 0;OutREn = 0;RegWrite = 0;RegDst = 1;MemtoReg = 2'b00;LLorLH = 0;JAorJR = 0;
					end
			  5'd3:
					begin
					    Imm_5or8 = 0;IorD = 0;ALUSrcA = 0;ALUSrcB = 2'b00;ALUop = 2'b00;PCSrc = 2'b00;Branch = 0;PCWrite = 0;
						 MemWrite = 0;IRWrite = 0;PSWEn = 0;OutREn = 0;RegWrite = 1;RegDst = 0;MemtoReg = 2'b10;LLorLH = 1;JAorJR = 0;
					end
			  5'd4:
					begin
					    Imm_5or8 = 0;IorD = 1;ALUSrcA = 0;ALUSrcB = 2'b00;ALUop = 2'b00;PCSrc = 2'b00;Branch = 0;PCWrite = 0;
						 MemWrite = 0;IRWrite = 0;PSWEn = 0;OutREn = 0;RegWrite = 0;RegDst = 0;MemtoReg = 2'b00;LLorLH = 0;JAorJR = 0;
					end
			  5'd5:
					begin
					    Imm_5or8 = 0;IorD = 0;ALUSrcA = 0;ALUSrcB = 2'b00;ALUop = 2'b00;PCSrc = 2'b00;Branch = 0;PCWrite = 0;
						 MemWrite = 0;IRWrite = 0;PSWEn = 0;OutREn = 0;RegWrite = 1;RegDst = 0;MemtoReg = 2'b01;LLorLH = 0;JAorJR = 0;
					end
			  5'd6:
					begin
					    Imm_5or8 = 0;IorD = 1;ALUSrcA = 0;ALUSrcB = 2'b00;ALUop = 2'b00;PCSrc = 2'b00;Branch = 0;PCWrite = 0;
						 MemWrite = 1;IRWrite = 0;PSWEn = 0;OutREn = 0;RegWrite = 0;RegDst = 0;MemtoReg = 2'b00;LLorLH = 0;JAorJR = 0;
					end
			  5'd7:
					begin
					    Imm_5or8 = 0;IorD = 0;ALUSrcA = 0;ALUSrcB = 2'b00;ALUop = 2'b00;PCSrc = 2'b11;Branch = 0;PCWrite = 1;
						 MemWrite = 0;IRWrite = 0;PSWEn = 0;OutREn = 0;RegWrite = 0;RegDst = 0;MemtoReg = 2'b00;LLorLH = 0;JAorJR = 1;
					end
			  5'd8:
					begin
					    Imm_5or8 = 0;IorD = 0;ALUSrcA = 0;ALUSrcB = 2'b00;ALUop = 2'b00;PCSrc = 2'b00;Branch = 0;PCWrite = 0;
						 MemWrite = 0;IRWrite = 0;PSWEn = 0;OutREn = 0;RegWrite = 1;RegDst = 0;MemtoReg = 2'b10;LLorLH = 0;JAorJR = 0;
					end
			  5'd9:
					begin
					    Imm_5or8 = 0;IorD = 0;ALUSrcA = 1;ALUSrcB = 2'b00;ALUop = 2'b00;PCSrc = 2'b00;Branch = 0;PCWrite = 0;
						 MemWrite = 0;IRWrite = 0;PSWEn = 0;OutREn = 0;RegWrite = 0;RegDst = 1;MemtoReg = 2'b00;LLorLH = 0;JAorJR = 0;
					end
			  5'd10:
					begin
					    Imm_5or8 = 0;IorD = 1;ALUSrcA = 0;ALUSrcB = 2'b00;ALUop = 2'b00;PCSrc = 2'b00;Branch = 0;PCWrite = 0;
						 MemWrite = 0;IRWrite = 0;PSWEn = 0;OutREn = 0;RegWrite = 0;RegDst = 0;MemtoReg = 2'b00;LLorLH = 0;JAorJR = 0;
					end
			  5'd11:
					begin
					    Imm_5or8 = 0;IorD = 1;ALUSrcA = 0;ALUSrcB = 2'b00;ALUop = 2'b00;PCSrc = 2'b00;Branch = 0;PCWrite = 0;
						 MemWrite = 1;IRWrite = 0;PSWEn = 0;OutREn = 0;RegWrite = 0;RegDst = 0;MemtoReg = 2'b00;LLorLH = 0;JAorJR = 0;
					end
			  5'd12:
					begin
					    Imm_5or8 = 0;IorD = 0;ALUSrcA = 1;ALUSrcB = 2'b00;ALUop = 2'b00;PCSrc = 2'b00;Branch = 0;PCWrite = 0;
						 MemWrite = 0;IRWrite = 0;PSWEn = 1;OutREn = 0;RegWrite = 0;RegDst = 0;MemtoReg = 2'b00;LLorLH = 0;JAorJR = 0;
					end
			  5'd13:
					begin
					    Imm_5or8 = 0;IorD = 0;ALUSrcA = 0;ALUSrcB = 2'b00;ALUop = 2'b00;PCSrc = 2'b00;Branch = 0;PCWrite = 0;
						 MemWrite = 0;IRWrite = 0;PSWEn = 0;OutREn = 0;RegWrite = 1;RegDst = 0;MemtoReg = 2'b00;LLorLH = 0;JAorJR = 0;
					end
			  5'd14:
					begin
					    Imm_5or8 = 0;IorD = 0;ALUSrcA = 1;ALUSrcB = 2'b00;ALUop = 2'b01;PCSrc = 2'b00;Branch = 0;PCWrite = 0;
						 MemWrite = 0;IRWrite = 0;PSWEn = 1;OutREn = 0;RegWrite = 0;RegDst = 0;MemtoReg = 2'b00;LLorLH = 0;JAorJR = 0;
					end
			  5'd15:
					begin
					    Imm_5or8 = 0;IorD = 0;ALUSrcA = 1;ALUSrcB = 2'b00;ALUop = 2'b10;PCSrc = 2'b00;Branch = 0;PCWrite = 0;
						 MemWrite = 0;IRWrite = 0;PSWEn = 1;OutREn = 0;RegWrite = 0;RegDst = 0;MemtoReg = 2'b00;LLorLH = 0;JAorJR = 0;
					end
			  5'd16:
					begin
					    Imm_5or8 = 0;IorD = 0;ALUSrcA = 1;ALUSrcB = 2'b00;ALUop = 2'b11;PCSrc = 2'b00;Branch = 0;PCWrite = 0;
						 MemWrite = 0;IRWrite = 0;PSWEn = 1;OutREn = 0;RegWrite = 0;RegDst = 0;MemtoReg = 2'b00;LLorLH = 0;JAorJR = 0;
					end
			  5'd17:
					begin
					    Imm_5or8 = 0;IorD = 0;ALUSrcA = 1;ALUSrcB = 2'b10;ALUop = 2'b00;PCSrc = 2'b00;Branch = 0;PCWrite = 0;
						 MemWrite = 0;IRWrite = 0;PSWEn = 1;OutREn = 0;RegWrite = 0;RegDst = 0;MemtoReg = 2'b00;LLorLH = 0;JAorJR = 0;
					end
			  5'd18:
					begin
					    Imm_5or8 = 0;IorD = 0;ALUSrcA = 1;ALUSrcB = 2'b10;ALUop = 2'b10;PCSrc = 2'b00;Branch = 0;PCWrite = 0;
						 MemWrite = 0;IRWrite = 0;PSWEn = 1;OutREn = 0;RegWrite = 0;RegDst = 0;MemtoReg = 2'b00;LLorLH = 0;JAorJR = 0;
					end
			  5'd19:
					begin
					    Imm_5or8 = 0;IorD = 0;ALUSrcA = 1;ALUSrcB = 2'b11;ALUop = 2'b00;PCSrc = 2'b00;Branch = 0;PCWrite = 0;
						 MemWrite = 0;IRWrite = 0;PSWEn = 0;OutREn = 0;RegWrite = 0;RegDst = 0;MemtoReg = 2'b00;LLorLH = 0;JAorJR = 0;
					end
			  5'd20:
					begin
					    Imm_5or8 = 0;IorD = 0;ALUSrcA = 0;ALUSrcB = 2'b00;ALUop = 2'b00;PCSrc = 2'b01;Branch = 1;PCWrite = 0;
						 MemWrite = 0;IRWrite = 0;PSWEn = 0;OutREn = 0;RegWrite = 0;RegDst = 0;MemtoReg = 2'b00;LLorLH = 0;JAorJR = 0;
					end
			  5'd21:
					begin
					    Imm_5or8 = 0;IorD = 0;ALUSrcA = 0;ALUSrcB = 2'b00;ALUop = 2'b00;PCSrc = 2'b01;Branch = 1;PCWrite = 1;
						 MemWrite = 0;IRWrite = 0;PSWEn = 0;OutREn = 0;RegWrite = 0;RegDst = 0;MemtoReg = 2'b00;LLorLH = 0;JAorJR = 0;
					end
			  5'd22:
					begin
					    Imm_5or8 = 0;IorD = 0;ALUSrcA = 0;ALUSrcB = 2'b00;ALUop = 2'b00;PCSrc = 2'b10;Branch = 0;PCWrite = 1;
						 MemWrite = 0;IRWrite = 0;PSWEn = 0;OutREn = 0;RegWrite = 0;RegDst = 0;MemtoReg = 2'b00;LLorLH = 0;JAorJR = 0;
					end
			  5'd23:
					begin
					    Imm_5or8 = 1;IorD = 0;ALUSrcA = 0;ALUSrcB = 2'b10;ALUop = 2'b00;PCSrc = 2'b00;Branch = 0;PCWrite = 1;
						 MemWrite = 0;IRWrite = 0;PSWEn = 0;OutREn = 0;RegWrite = 1;RegDst = 0;MemtoReg = 2'b11;LLorLH = 0;JAorJR = 0;
					end
			  5'd24:
					begin
					    Imm_5or8 = 0;IorD = 0;ALUSrcA = 0;ALUSrcB = 2'b00;ALUop = 2'b00;PCSrc = 2'b11;Branch = 0;PCWrite = 1;
						 MemWrite = 0;IRWrite = 0;PSWEn = 0;OutREn = 0;RegWrite = 1;RegDst = 0;MemtoReg = 2'b11;LLorLH = 0;JAorJR = 0;
					end
			  5'd25:
					begin
					    Imm_5or8 = 0;IorD = 0;ALUSrcA = 0;ALUSrcB = 2'b00;ALUop = 2'b00;PCSrc = 2'b00;Branch = 0;PCWrite = 0;
						 MemWrite = 0;IRWrite = 0;PSWEn = 0;OutREn = 1;RegWrite = 0;RegDst = 0;MemtoReg = 2'b00;LLorLH = 0;JAorJR = 0;
					end
			  default: 
			      begin
						 Imm_5or8 = 0;
						 IorD = 0;
						 ALUSrcA = 0;
						 ALUSrcB = 2'b00;
						 ALUop = 2'b00;
						 PCSrc = 2'b00;
						 Branch = 0;
						 PCWrite = 0;
						 MemWrite = 0;
						 IRWrite = 0;
						 PSWEn = 0;
						 OutREn = 0;
						 RegWrite = 0;
						 RegDst = 0;
						 MemtoReg = 2'b00;
						 LLorLH = 0;
						 JAorJR = 0;
					end
		 endcase
	end

endmodule