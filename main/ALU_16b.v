module ALU_16b(
    input [15:0] dataA, dataB,
    input [1:0] sel,
    input Cin,
    output [15:0] Sum,
    output C,
    output Z, N, V
);
    wire [15:0] B;
    wire cin;

    wire [14:0] cout;
    
    assign cin = (sel == 2'b10) ? 1'b1 : //SUB
					  (sel == 2'b11) ? ~Cin : //SBB
					  (sel == 2'b01) ? Cin :  //ADC
					  1'b0;
    genvar i;
    generate
        for (i = 0; i < 16; i = i + 1) begin : gen_xor
            xor (B[i], dataB[i], sel[1]);
        end
    endgenerate
    full_adder fa0 (.A(dataA[0]), .B(B[0]), .Cin(cin),     .Sum(Sum[0]), .Cout(cout[0]));
    full_adder fa1 (.A(dataA[1]), .B(B[1]), .Cin(cout[0]), .Sum(Sum[1]), .Cout(cout[1]));
    full_adder fa2 (.A(dataA[2]), .B(B[2]), .Cin(cout[1]), .Sum(Sum[2]), .Cout(cout[2]));
    full_adder fa3 (.A(dataA[3]), .B(B[3]), .Cin(cout[2]), .Sum(Sum[3]), .Cout(cout[3]));
    full_adder fa4 (.A(dataA[4]), .B(B[4]), .Cin(cout[3]), .Sum(Sum[4]), .Cout(cout[4]));
    full_adder fa5 (.A(dataA[5]), .B(B[5]), .Cin(cout[4]), .Sum(Sum[5]), .Cout(cout[5]));
    full_adder fa6 (.A(dataA[6]), .B(B[6]), .Cin(cout[5]), .Sum(Sum[6]), .Cout(cout[6]));
    full_adder fa7 (.A(dataA[7]), .B(B[7]), .Cin(cout[6]), .Sum(Sum[7]), .Cout(cout[7]));
    full_adder fa8 (.A(dataA[8]), .B(B[8]), .Cin(cout[7]), .Sum(Sum[8]), .Cout(cout[8]));
    full_adder fa9 (.A(dataA[9]), .B(B[9]), .Cin(cout[8]), .Sum(Sum[9]), .Cout(cout[9]));
    full_adder fa10(.A(dataA[10]),.B(B[10]),.Cin(cout[9]),.Sum(Sum[10]),.Cout(cout[10]));
    full_adder fa11(.A(dataA[11]),.B(B[11]),.Cin(cout[10]),.Sum(Sum[11]),.Cout(cout[11]));
    full_adder fa12(.A(dataA[12]),.B(B[12]),.Cin(cout[11]),.Sum(Sum[12]),.Cout(cout[12]));
    full_adder fa13(.A(dataA[13]),.B(B[13]),.Cin(cout[12]),.Sum(Sum[13]),.Cout(cout[13]));
    full_adder fa14(.A(dataA[14]),.B(B[14]),.Cin(cout[13]),.Sum(Sum[14]),.Cout(cout[14]));
    full_adder fa15(.A(dataA[15]),.B(B[15]),.Cin(cout[14]),.Sum(Sum[15]),.Cout(C));
    assign Z = (Sum == 16'b0)?1'b1:1'b0;
    assign N = Sum[15];
    assign V = (dataA[15] & B[15] & ~Sum[15]) | (~dataA[15] & ~B[15] & Sum[15]);
endmodule
