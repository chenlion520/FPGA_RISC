`timescale 1ns / 1ps
module datapath_t;
	// Inputs
	parameter clk_period = 20;
	parameter delay_factor = 2;
	reg rst_n;
	reg clk;
	
	reg MemWrite;
	reg IRWrite;
	reg Imm_5or8;
	reg RegWrite;
	reg OutREn;
	reg [1:0] ALUop;
	reg Branch;
	reg PCWrite;
	reg IorD;
	reg RegDst;
	reg [1:0] MemtoReg;
	reg LLorLH;
	reg ALUSrcA;
	reg [1:0] ALUSrcB;
	reg JAorJR;
	reg [1:0] PCSrc;
	reg [15:0] ext_addr;
	reg [15:0] ext_data;
	reg test;
	reg TestMem;
	reg PSWEn;
	// Outputs
	wire [15:0] OutR;
	wire [15:0] TestMemout;
	wire [15:0] opcode;
	integer i;
	// Instantiate the Unit Under Test (UUT)
	datapath uut (
		.rst_n(rst_n), 
		.clk(clk), 
		
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
		.ext_addr(ext_addr), 
		.ext_data(ext_data), 
		.test(test), 
		.TestMem(TestMem), 
		.OutR(OutR),
		.TestMemout(TestMemout),
		.opcode(opcode)
	);
	always begin
		#(clk_period/2)clk <= 1'b0;
		#(clk_period/2)clk <= 1'b1;
	end
	initial begin
		// Initialize Inputs
		rst_n = 0;
		clk = 0;
		
		MemWrite = 0;
		IRWrite = 0;
		Imm_5or8 = 0;
		RegWrite = 0;
		OutREn = 0;
		ALUop = 0;
		Branch = 0;
		PSWEn = 0;
		PCWrite = 0;
		IorD = 0;
		RegDst = 0;
		MemtoReg = 0;
		LLorLH = 0;
		ALUSrcA = 0;
		ALUSrcB = 0;
		JAorJR = 0;
		PCSrc = 0;
		ext_addr = 0;
		ext_data = 0;
		test = 0;
		TestMem = 0;
		
		rst_n <= 1'b0;test = 1'b0;
		repeat (2) @(posedge clk)
						#(clk_period/delay_factor)rst_n <= 1'b0;
		rst_n <= 1'b1;test = 1'b1;
		
		
		write_mem(16'h0,16'b0001_0000_0010_0101); //LLI R0,#25
		write_mem(16'h1,16'b0000_1000_0110_0011); //LHI R0,#63
		write_mem(16'h2,16'b1110_0000_0000_0000); //OUT R0 (6325H)
		
		write_mem(16'h3,16'b0001_1001_0000_0000); // LDR R1,R0,#0
		write_mem(16'h4,16'b0001_1010_0000_0001); // LDR R2,R0,#1
		write_mem(16'h5,16'b1110_0000_0010_0000); // OUT R1 (47H)
		write_mem(16'h6,16'b1110_0000_0100_0000); // OUT R2 (89H)
		write_mem(16'h7,16'b0000_0011_0010_1000); // ADD R3,R1,R2
		write_mem(16'h8,16'b1110_0000_0110_0000); // OUT R3 (D0H)
		write_mem(16'h9,16'b0000_0011_0010_1010); // SUB R3,R1,R2
		write_mem(16'hA,16'b1110_0000_0110_0000); // OUT R3 (FFBEH)
		
		///////////////test///////////////
		write_mem(16'hB,16'b0010_0100_0010_1000); // LDR R4,R1,R2
		write_mem(16'hC,16'b1110_0000_1000_0000); // OUT R4 (39H)
		write_mem(16'hD,16'b0010_1100_0000_0011); // STR R4 R0 #3(16'h28 = 39H)
		write_mem(16'hE,16'b0011_0011_0010_1000); // STR R3 R1 R2(16'hD0 = FFBEH)
		write_mem(16'hF,16'b0011_0000_0010_1001); // CMP R1 R2
		
		write_mem(16'h10,16'b0000_0011_0010_1001); // ADC R3 R1 R2
		write_mem(16'h11,16'b1110_0000_0110_0000); // OUT R3 (D0H)
		
		write_mem(16'h12,16'b1100_1110_0000_0011); // B[AL] pc = pc + 3 (to pc:16)
		write_mem(16'h16,16'b1110_0000_0100_0000); // OUT R2 (89H) 
		
		write_mem(16'h17,16'b0011_1001_0100_0011); // ADDI R1,R2 #3
		write_mem(16'h18,16'b1110_0000_0010_0000); // OUT R1 (8CH) 
		write_mem(16'h19,16'b0100_0001_0100_1001); // SUBI R1,R2 #9
		write_mem(16'h1A,16'b1110_0000_0010_0000); // OUT R1 (80H) 
		
		write_mem(16'h1B,16'b0101_1010_0010_0000); // MOV R2 R1
		write_mem(16'h1C,16'b1110_0000_0100_0000); // OUT R2 (80H)
		write_mem(16'h1D,16'b0000_0000_0010_1011); // SBB R0,R1,R2
		write_mem(16'h1E,16'b1100_0000_0000_0011); // BEQ pc = pc + 3(to pc:22)
		write_mem(16'h22,16'b1110_0000_0110_0000); // OUT R3 (D0H)
		write_mem(16'h23,16'b1000_0000_0011_0101); // JMP pc = 16'h35
		write_mem(16'h35,16'b1110_0000_0100_0000); // OUT R2 (80H)

		write_mem(16'h25,16'h47); // data (25h, 47h)
		write_mem(16'h26,16'h89); // data (26h, 89h)
		write_mem(16'hD0,16'h39); // data (D0h, 39h)
		
		@(posedge clk)#(clk_period/delay_factor) MemWrite = 1'b0;
		 test = 1'b1;
		for(i = 0 ; i < 14 ; i = i + 1)
			@(posedge clk) #(clk_period/delay_factor) ext_addr = i;
		 test = 1'b0;
		rst_n = 1'b1;
		repeat (2) @(posedge clk)
						#(clk_period/delay_factor) rst_n = 1'b0;
		rst_n = 1'b1;
		TestMem = 1;
		//LLI R0,#25//
		@(posedge clk) 
		#10 test = 0; IorD = 0; ALUSrcA = 0; ALUSrcB = 2'b01; ALUop = 2'b00; PCSrc = 2'b00;
		Branch = 0; PCWrite = 1; MemWrite = 0; IRWrite = 1; PSWEn = 0;OutREn = 0; RegWrite = 0;
		@(posedge clk) 
		#10 PCWrite = 0; IRWrite = 0;
		@(posedge clk) 
		#10 LLorLH = 0; MemtoReg = 2'b10; RegWrite = 1;
		
		//LHI R0,#63//
		@(posedge clk) 
		#10 IorD = 0; ALUSrcA = 0; ALUSrcB = 2'b01; ALUop = 2'b00; PCSrc = 2'b00;
		Branch = 0; PCWrite = 1; MemWrite = 0; IRWrite = 1; PSWEn = 0;OutREn = 0; RegWrite = 0;
		@(posedge clk) 
		#10 PCWrite = 0; IRWrite = 0;
		@(posedge clk) 
		#10 RegDst = 1;
		@(posedge clk) 
		#10 LLorLH = 1; MemtoReg = 2'b10; RegWrite = 1;
		
		//OUT R0 (6325H)//
		@(posedge clk) 
		#10 IorD = 0; ALUSrcA = 0; ALUSrcB = 2'b01; ALUop = 2'b00; PCSrc = 2'b00;
		Branch = 0; PCWrite = 1; MemWrite = 0; IRWrite = 1; PSWEn = 0;OutREn = 0; RegWrite = 0;
		@(posedge clk) 
		#10 PCWrite = 0; IRWrite = 0;
		@(posedge clk) 
		#10 OutREn = 1;
		
		// LDR R1,R0,#0
		@(posedge clk) 
		#10 IorD = 0; ALUSrcA = 0; ALUSrcB = 2'b01; ALUop = 2'b00; PCSrc = 2'b00;
		Branch = 0; PCWrite = 1; MemWrite = 0; IRWrite = 1; PSWEn = 0;OutREn = 0; RegWrite = 0;
		@(posedge clk)
		#10 PCWrite = 0; IRWrite = 0;
		@(posedge clk)
		#10 ALUSrcA = 1; ALUSrcB = 2'b10;ALUop = 2'b00;Imm_5or8 = 0;
		@(posedge clk)
		#10 IorD = 1;
		@(posedge clk)
		#10 MemtoReg = 2'b01; RegWrite = 1;
		
		
		// LDR R2,R0,#1
		@(posedge clk) 
		#10 IorD = 0; ALUSrcA = 0; ALUSrcB = 2'b01; ALUop = 2'b00; PCSrc = 2'b00;
		Branch = 0; PCWrite = 1; MemWrite = 0; IRWrite = 1; PSWEn = 0;OutREn = 0; RegWrite = 0;
		@(posedge clk)
		#10 PCWrite = 0; IRWrite = 0;
		@(posedge clk)
		#10 ALUSrcA = 1; ALUSrcB = 2'b10;ALUop = 2'b00;Imm_5or8 = 0;
		@(posedge clk)
		#10 IorD = 1;
		@(posedge clk)
		#10 MemtoReg = 2'b01; RegWrite = 1;
		// OUT R1 (47H)
		@(posedge clk) 
		#10 IorD = 0; ALUSrcA = 0; ALUSrcB = 2'b01; ALUop = 2'b00; PCSrc = 2'b00;
		Branch = 0; PCWrite = 1; MemWrite = 0; IRWrite = 1; PSWEn = 0;OutREn = 0; RegWrite = 0;
		@(posedge clk) 
		#10 PCWrite = 0; IRWrite = 0;
		@(posedge clk) 
		#10 OutREn = 1;
		
		// OUT R2 (89H)
		@(posedge clk) 
		#10 IorD = 0; ALUSrcA = 0; ALUSrcB = 2'b01; ALUop = 2'b00; PCSrc = 2'b00;
		Branch = 0; PCWrite = 1; MemWrite = 0; IRWrite = 1; PSWEn = 0;OutREn = 0; RegWrite = 0;
		@(posedge clk) 
		#10 PCWrite = 0; IRWrite = 0;
		@(posedge clk) 
		#10 OutREn = 1;
		// ADD R3,R1,R2
		@(posedge clk) 
		#10 IorD = 0; ALUSrcA = 0; ALUSrcB = 2'b01; ALUop = 2'b00; PCSrc = 2'b00;
		Branch = 0; PCWrite = 1; MemWrite = 0; IRWrite = 1; PSWEn = 0;OutREn = 0; RegWrite = 0;
		@(posedge clk)
		#10 RegDst = 0; PCWrite = 0; IRWrite = 0;
		@(posedge clk)
		#10 ALUSrcA = 1;ALUSrcB = 2'b00; ALUop = 2'b00;
		@(posedge clk)
		#10 MemtoReg = 2'b00; RegWrite = 1;
		
		// OUT R3 (D0H)
		@(posedge clk) 
		#10 IorD = 0; ALUSrcA = 0; ALUSrcB = 2'b01; ALUop = 2'b00; PCSrc = 2'b00;
		Branch = 0; PCWrite = 1; MemWrite = 0; IRWrite = 1; PSWEn = 0;OutREn = 0; RegWrite = 0;
		@(posedge clk) 
		#10 PCWrite = 0; IRWrite = 0;
		@(posedge clk) 
		#10 OutREn = 1;
		// SUB R3,R1,R2
		@(posedge clk) 
		#10 IorD = 0; ALUSrcA = 0; ALUSrcB = 2'b01; ALUop = 2'b00; PCSrc = 2'b00;
		Branch = 0; PCWrite = 1; MemWrite = 0; IRWrite = 1; PSWEn = 0;OutREn = 0; RegWrite = 0;
		@(posedge clk)
		#10 RegDst = 0; PCWrite = 0; IRWrite = 0;
		@(posedge clk)
		#10 ALUSrcA = 1;ALUSrcB = 2'b00; ALUop = 2'b10;
		@(posedge clk)
		#10 MemtoReg = 2'b00; RegWrite = 1;
		// OUT R3 (FFBEH)
		@(posedge clk) 
		#10 IorD = 0; ALUSrcA = 0; ALUSrcB = 2'b01; ALUop = 2'b00; PCSrc = 2'b00;
		Branch = 0; PCWrite = 1; MemWrite = 0; IRWrite = 1; PSWEn = 0;OutREn = 0; RegWrite = 0;
		@(posedge clk) 
		#10 PCWrite = 0; IRWrite = 0;
		@(posedge clk) 
		#10 OutREn = 1;
		
		// LDR R4,R1,R2
		@(posedge clk) 
		#10 IorD = 0; ALUSrcA = 0; ALUSrcB = 2'b01; ALUop = 2'b00; PCSrc = 2'b00;
		Branch = 0; PCWrite = 1; MemWrite = 0; IRWrite = 1; PSWEn = 0;OutREn = 0; RegWrite = 0;
		@(posedge clk)
		#10 PCWrite = 0; IRWrite = 0;
		@(posedge clk)
		#10 ALUSrcA = 1; ALUSrcB = 2'b00;ALUop = 2'b00;Imm_5or8 = 0;
		@(posedge clk)
		#10 IorD = 1;
		@(posedge clk)
		#10 MemtoReg = 2'b01; RegWrite = 1;
		// OUT R4 (39H)
		@(posedge clk) 
		#10 IorD = 0; ALUSrcA = 0; ALUSrcB = 2'b01; ALUop = 2'b00; PCSrc = 2'b00;
		Branch = 0; PCWrite = 1; MemWrite = 0; IRWrite = 1; PSWEn = 0;OutREn = 0; RegWrite = 0;
		@(posedge clk) 
		#10 PCWrite = 0; IRWrite = 0;
		@(posedge clk) 
		#10 OutREn = 1;
		// STR R4 R0 #3(16'h28 = 39H)
		@(posedge clk) 
		#10 IorD = 0; ALUSrcA = 0; ALUSrcB = 2'b01; ALUop = 2'b00; PCSrc = 2'b00;
		Branch = 0; PCWrite = 1; MemWrite = 0; IRWrite = 1; PSWEn = 0;OutREn = 0; RegWrite = 0;
		@(posedge clk)
		#10 IRWrite = 0;RegDst = 1; PCWrite = 0;
		@(posedge clk)
		#10 ALUSrcA = 1;ALUSrcB = 2'b10;ALUop = 2'b00;Imm_5or8 = 0;
		@(posedge clk)
		#10 IorD = 1;MemWrite = 1;
		// STR R3 R1 R2(16'hD0 = FFBEH)
		@(posedge clk) 
		#10 IorD = 0; ALUSrcA = 0; ALUSrcB = 2'b01; ALUop = 2'b00; PCSrc = 2'b00;
		Branch = 0; PCWrite = 1; MemWrite = 0; IRWrite = 1; PSWEn = 0;OutREn = 0; RegWrite = 0;
		@(posedge clk)
		#10 IRWrite = 0;RegDst = 0; PCWrite = 0;
		@(posedge clk)
		#10 RegDst = 1; ALUSrcA = 1;ALUSrcB = 2'b00;ALUop = 2'b00;
		@(posedge clk)
		#10 IorD = 1;MemWrite = 1;
		// CMP R1 R2
		@(posedge clk) 
		#10 IorD = 0; ALUSrcA = 0; ALUSrcB = 2'b01; ALUop = 2'b00; PCSrc = 2'b00;
		Branch = 0; PCWrite = 1; MemWrite = 0; IRWrite = 1; PSWEn = 0;OutREn = 0; RegWrite = 0;
		@(posedge clk)
		#10 IRWrite = 0; PCWrite = 0; RegDst = 0;
		@(posedge clk)
		#10 ALUSrcA = 1;ALUSrcB = 2'b00; ALUop = 2'b10; PSWEn = 1;
		
		// ADC R3 R1 R2
		@(posedge clk) 
		#10 IorD = 0; ALUSrcA = 0; ALUSrcB = 2'b01; ALUop = 2'b00; PCSrc = 2'b00;
		Branch = 0; PCWrite = 1; MemWrite = 0; IRWrite = 1; PSWEn = 0;OutREn = 0; RegWrite = 0;
		@(posedge clk)
		#10 RegDst = 0; PCWrite = 0; IRWrite = 0;
		@(posedge clk)
		#10 ALUSrcA = 1;ALUSrcB = 2'b00; ALUop = 2'b01;PSWEn = 1;
		@(posedge clk)
		#10 MemtoReg = 2'b00; RegWrite = 1; PSWEn = 0;
		
		// OUT R3 (D0H)
		@(posedge clk) 
		#10 IorD = 0; ALUSrcA = 0; ALUSrcB = 2'b01; ALUop = 2'b00; PCSrc = 2'b00;
		Branch = 0; PCWrite = 1; MemWrite = 0; IRWrite = 1; PSWEn = 0;OutREn = 0; RegWrite = 0;
		@(posedge clk) 
		#10 PCWrite = 0; IRWrite = 0;
		@(posedge clk) 
		#10 OutREn = 1;
		
		// B[AL] pc = pc + 3 (to pc:16)
		@(posedge clk) 
		#10 IorD = 0; ALUSrcA = 0; ALUSrcB = 2'b01; ALUop = 2'b00; PCSrc = 2'b00;
		Branch = 0; PCWrite = 1; MemWrite = 0; IRWrite = 1; PSWEn = 0;OutREn = 0; RegWrite = 0;
		@(posedge clk)
		#10 ALUSrcA = 0; ALUSrcB = 2'b10; Imm_5or8 = 1; ALUop = 2'b00; IRWrite = 0; PCWrite = 0;
		@(posedge clk)
		#10 PCSrc = 2'b01; Branch = 1; PCWrite = 1;
		// OUT R2 (89H) 
		@(posedge clk) 
		#10 IorD = 0; ALUSrcA = 0; ALUSrcB = 2'b01; ALUop = 2'b00; PCSrc = 2'b00;
		Branch = 0; PCWrite = 1; MemWrite = 0; IRWrite = 1; PSWEn = 0;OutREn = 0; RegWrite = 0;
		@(posedge clk) 
		#10 PCWrite = 0; IRWrite = 0;
		@(posedge clk) 
		#10 OutREn = 1;
		
		// ADDI R1,R2 #3
		@(posedge clk) 
		#10 IorD = 0; ALUSrcA = 0; ALUSrcB = 2'b01; ALUop = 2'b00; PCSrc = 2'b00;
		Branch = 0; PCWrite = 1; MemWrite = 0; IRWrite = 1; PSWEn = 0;OutREn = 0; RegWrite = 0;
		@(posedge clk)
		#10 PCWrite = 0; IRWrite = 0;
		@(posedge clk)
		#10 ALUSrcA = 1;ALUSrcB = 2'b10; Imm_5or8 = 0 ; ALUop = 2'b00;
		@(posedge clk)
		#10 MemtoReg = 2'b00; RegWrite = 1; PSWEn = 0;
		// OUT R1 (8CH) 
		@(posedge clk) 
		#10 IorD = 0; ALUSrcA = 0; ALUSrcB = 2'b01; ALUop = 2'b00; PCSrc = 2'b00;
		Branch = 0; PCWrite = 1; MemWrite = 0; IRWrite = 1; PSWEn = 0;OutREn = 0; RegWrite = 0;
		@(posedge clk) 
		#10 PCWrite = 0; IRWrite = 0;
		@(posedge clk) 
		#10 OutREn = 1;
		// SUBI R1,R2 #9
		@(posedge clk) 
		#10 IorD = 0; ALUSrcA = 0; ALUSrcB = 2'b01; ALUop = 2'b00; PCSrc = 2'b00;
		Branch = 0; PCWrite = 1; MemWrite = 0; IRWrite = 1; PSWEn = 0;OutREn = 0; RegWrite = 0;
		@(posedge clk)
		#10 PCWrite = 0; IRWrite = 0;
		@(posedge clk)
		#10 ALUSrcA = 1;ALUSrcB = 2'b10; Imm_5or8 = 0 ; ALUop = 2'b10;
		@(posedge clk)
		#10 MemtoReg = 2'b00; RegWrite = 1; PSWEn = 0;
		// OUT R1 (80H) 
		@(posedge clk) 
		#10 IorD = 0; ALUSrcA = 0; ALUSrcB = 2'b01; ALUop = 2'b00; PCSrc = 2'b00;
		Branch = 0; PCWrite = 1; MemWrite = 0; IRWrite = 1; PSWEn = 0;OutREn = 0; RegWrite = 0;
		@(posedge clk) 
		#10 PCWrite = 0; IRWrite = 0;
		@(posedge clk) 
		#10 OutREn = 1;
		
		// MOV R2 R1
		@(posedge clk) 
		#10 IorD = 0; ALUSrcA = 0; ALUSrcB = 2'b01; ALUop = 2'b00; PCSrc = 2'b00;
		Branch = 0; PCWrite = 1; MemWrite = 0; IRWrite = 1; PSWEn = 0;OutREn = 0; RegWrite = 0;
		@(posedge clk)
		#10 IRWrite = 0; PCWrite = 0;
		@(posedge clk)
		#10 ALUSrcA = 1; ALUSrcB = 2'b11; ALUop = 2'b00;
		@(posedge clk)
		#10 MemtoReg = 2'b00; RegWrite = 1;
		// OUT R2 (80H)
		@(posedge clk) 
		#10 IorD = 0; ALUSrcA = 0; ALUSrcB = 2'b01; ALUop = 2'b00; PCSrc = 2'b00;
		Branch = 0; PCWrite = 1; MemWrite = 0; IRWrite = 1; PSWEn = 0;OutREn = 0; RegWrite = 0;
		@(posedge clk) 
		#10 PCWrite = 0; IRWrite = 0;
		@(posedge clk) 
		#10 OutREn = 1;
		
		// SBB R0,R1,R2
		@(posedge clk) 
		#10 IorD = 0; ALUSrcA = 0; ALUSrcB = 2'b01; ALUop = 2'b00; PCSrc = 2'b00;
		Branch = 0; PCWrite = 1; MemWrite = 0; IRWrite = 1; PSWEn = 0;OutREn = 0; RegWrite = 0;
		@(posedge clk)
		#10 RegDst = 0; PCWrite = 0; IRWrite = 0;
		@(posedge clk)
		#10 ALUSrcA = 1;ALUSrcB = 2'b00; ; ALUop = 2'b11; PSWEn = 1;
		@(posedge clk)
		#10 MemtoReg = 2'b00; RegWrite = 1; PSWEn = 0;
		// BEQ pc = pc + 3(to pc:22)
		@(posedge clk) 
		#10 IorD = 0; ALUSrcA = 0; ALUSrcB = 2'b01; ALUop = 2'b00; PCSrc = 2'b00;
		Branch = 0; PCWrite = 1; MemWrite = 0; IRWrite = 1; PSWEn = 0;OutREn = 0; RegWrite = 0;
		@(posedge clk)
		#10 ALUSrcA = 0; ALUSrcB = 2'b10; Imm_5or8 = 1; ALUop = 2'b00; IRWrite = 0; PCWrite = 0;
		@(posedge clk)
		#10 PCSrc = 2'b01; Branch = 1; 
		// OUT R0 (00H)
		@(posedge clk) 
		#10 IorD = 0; ALUSrcA = 0; ALUSrcB = 2'b01; ALUop = 2'b00; PCSrc = 2'b00;
		Branch = 0; PCWrite = 1; MemWrite = 0; IRWrite = 1; PSWEn = 0;OutREn = 0; RegWrite = 0;
		@(posedge clk) 
		#10 PCWrite = 0; IRWrite = 0;
		@(posedge clk) 
		#10 OutREn = 1;
		// JMP pc = 16'h35
		@(posedge clk)
		#10 IorD = 0; ALUSrcA = 0; ALUSrcB = 2'b01; ALUop = 2'b00; PCSrc = 2'b00;
		Branch = 0; PCWrite = 1; MemWrite = 0; IRWrite = 1; PSWEn = 0;OutREn = 0; RegWrite = 0;
		@(posedge clk)
		#10 PCWrite = 0; IRWrite = 0;
		@(posedge clk)
		#10 PCSrc = 10;PCWrite = 1;
		// OUT R2 (80H)
		@(posedge clk) 
		#10 IorD = 0; ALUSrcA = 0; ALUSrcB = 2'b01; ALUop = 2'b00; PCSrc = 2'b00;
		Branch = 0; PCWrite = 1; MemWrite = 0; IRWrite = 1; PSWEn = 0;OutREn = 0; RegWrite = 0;
		@(posedge clk) 
		#10 PCWrite = 0; IRWrite = 0;
		@(posedge clk) 
		#10 OutREn = 1;
	end
	task write_mem;
	input [15:0] addr,data;
	begin
		@(posedge clk)#(clk_period/delay_factor)begin
			test = 1'b1;
			MemWrite = 1;
			TestMem = 1'b1;ext_addr = addr;
			ext_data = data;
		end
	end
	endtask
	
	initial #3500 $finish;
	initial
		$monitor($realtime ,"ns %h %h %h %h %h %h %h %h \n ",clk,rst_n,TestMem,test,ext_addr,ext_data,TestMemout,OutR);
	
	
endmodule

