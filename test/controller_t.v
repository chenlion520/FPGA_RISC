`timescale 1ns / 1ps
module controller_t;
	parameter clk_period = 20;
	// Inputs
	reg rst_n;
	reg clk;
	reg [15:0] opcode;
	// Outputs
	wire MemWrite;
	wire IRWrite;
	wire Imm_5or8;
	wire RegWrite;
	wire OutREn;
	wire [1:0] ALUop;
	wire Branch;
	wire PSWEn;
	wire PCWrite;
	wire IorD;
	wire RegDst;
	wire [1:0] MemtoReg;
	wire LLorLH;
	wire ALUSrcA;
	wire [1:0] ALUSrcB;
	wire JAorJR;
	wire [1:0] PCSrc;
	wire [4:0] state;
	// Instantiate the Unit Under Test (UUT)
	controller uut (
		.rst_n(rst_n), 
		.clk(clk), 
		.opcode(opcode), 
		.MemWrite(MemWrite), 
		.IRWrite(IRWrite), 
		.Imm_5or8(Imm_5or8), 
		.RegWrite(RegWrite), 
		.OutREn(OutREn), 
		.ALUop(ALUop), 
		.Branch(Branch), 
		.PSWEn(PSWEn), 
		.PCWrite(PCWrite), 
		.IorD(IorD), 
		.RegDst(RegDst), 
		.MemtoReg(MemtoReg), 
		.LLorLH(LLorLH), 
		.ALUSrcA(ALUSrcA), 
		.ALUSrcB(ALUSrcB), 
		.JAorJR(JAorJR), 
		.PCSrc(PCSrc), 
		.state(state)
	);
	always begin
		#(clk_period/2)clk <= 1'b0;
		#(clk_period/2)clk <= 1'b1;
	end
	initial begin
    $monitor(
        "T=%0t | state=%0d | opcode=%b | MemWrite=%b | IRWrite=%b | Imm_5or8=%b | RegWrite=%b | OutREn=%b | ALUop=%b | Branch=%b | PSWEn=%b | PCWrite=%b | IorD=%b | RegDst=%b | MemtoReg=%b | LLorLH=%b | ALUSrcA=%b | ALUSrcB=%b | JAorJR=%b | PCSrc=%b",
        $time, state, opcode, MemWrite, IRWrite, Imm_5or8, RegWrite, OutREn, ALUop, Branch, PSWEn, PCWrite, IorD, RegDst, MemtoReg, LLorLH, ALUSrcA, ALUSrcB, JAorJR, PCSrc
    );
	end
	initial begin
		// Initialize Inputs
		rst_n = 0;
		clk = 0;
		opcode = 0;
		#40
		rst_n = 1;
		repeat (3) @(posedge clk) 	opcode = 16'b0001_0000_0010_0101;// LLI R0,#25
		repeat (3) @(posedge clk) 	opcode = 16'b0000_1000_0110_0011;// LHI R0,#63
		repeat (3) @(posedge clk)	opcode = 16'b1110_0000_0000_0000;// OUT R0 (6325H)
		repeat (5) @(posedge clk)	opcode = 16'b0001_1001_0000_0000;// LDR R1,R0,#0
		repeat (5) @(posedge clk)	opcode = 16'b0001_1010_0000_0001;// LDR R2,R0,#1
		repeat (3) @(posedge clk)	opcode = 16'b1110_0000_0010_0000;// OUT R1 (47H)
		repeat (3) @(posedge clk)	opcode = 16'b1110_0000_0100_0000;// OUT R2 (89H)
		repeat (4) @(posedge clk)	opcode = 16'b0000_0011_0010_1000;// ADD R3,R1,R2
		repeat (3) @(posedge clk)	opcode = 16'b1110_0000_0110_0000;// OUT R3 (D0H)
		repeat (4) @(posedge clk)	opcode = 16'b0000_0011_0010_1010;// SUB R3,R1,R2
		repeat (3) @(posedge clk)	opcode = 16'b1110_0000_0110_0000;// OUT R3 (FFBEH)
		repeat (5) @(posedge clk)	opcode = 16'b0010_0100_0010_1000;// LDR R4,R1,R2
		repeat (3) @(posedge clk)	opcode = 16'b1110_0000_1000_0000;// OUT R4 (39H)
		repeat (4) @(posedge clk)	opcode = 16'b0010_1100_0000_0011;// STR R4 R0 #3(16'h28 = 39H)
		repeat (4) @(posedge clk)	opcode = 16'b0011_0011_0010_1000;// STR R3 R1 R2(16'hD0 = FFBEH)
		repeat (3) @(posedge clk)	opcode = 16'b0011_0000_0010_1001;// CMP R1 R2
		repeat (4) @(posedge clk)	opcode = 16'b0000_0011_0010_1001;// ADC R3 R1 R2
		repeat (3) @(posedge clk)	opcode = 16'b1110_0000_0110_0000;// OUT R3 (D0H)
		repeat (3) @(posedge clk)	opcode = 16'b1100_1110_0000_0011;// B[AL] pc = pc + 3 (to pc:16)
		repeat (3) @(posedge clk)	opcode = 16'b1110_0000_0100_0000;// OUT R2 (89H)  
		repeat (4) @(posedge clk)	opcode = 16'b0011_1001_0100_0011;// ADDI R1,R2 #3 
		repeat (3) @(posedge clk)	opcode = 16'b1110_0000_0010_0000;// OUT R1 (8CH) 
		repeat (4) @(posedge clk)	opcode = 16'b0100_0001_0100_1001;// SUBI R1,R2 #9 
		repeat (3) @(posedge clk)	opcode = 16'b1110_0000_0010_0000;// OUT R1 (80H)  
		repeat (4) @(posedge clk)	opcode = 16'b0101_1010_0010_0000;// MOV R2 R1
		repeat (3) @(posedge clk)	opcode = 16'b1110_0000_0100_0000;// OUT R2 (80H) 
		repeat (4) @(posedge clk)	opcode = 16'b0000_0000_0010_1011;// SBB R0,R1,R2 
		repeat (3) @(posedge clk)	opcode = 16'b1100_0000_0000_0011;// BEQ pc = pc + 3(to pc:22) 
		repeat (3) @(posedge clk)	opcode = 16'b1110_0000_0110_0000;// OUT R3 (D0H)  
		repeat (3) @(posedge clk)	opcode = 16'b1000_0000_0011_0101;// JMP pc = 16'h35 
		repeat (3) @(posedge clk)	opcode = 16'b1110_0000_0100_0000;// OUT R2 (80H)  
		#100;
      $finish;
	end
      
endmodule

