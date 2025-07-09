`timescale 1ns / 1ps
module RF_16b(
    input [2:0]read_register0,read_register1,write_register,
	 input RegWrite,clk,rst_n,
	 input [15:0]write_data,
	 output [15:0]read_data0,read_data1
    );
	 wire [7:0]DFF_enable;
	 wire [15:0]read_data[7:0];
    decoder_3to8 decoder(.in(write_register),.decoder_enable(RegWrite),.out(DFF_enable));
	 DFF_16b DFF0(.data(write_data),.clk(clk),.rst_n(rst_n),.DFF_enable(DFF_enable[0]),.out(read_data[0]));
	 DFF_16b DFF1(.data(write_data),.clk(clk),.rst_n(rst_n),.DFF_enable(DFF_enable[1]),.out(read_data[1]));
	 DFF_16b DFF2(.data(write_data),.clk(clk),.rst_n(rst_n),.DFF_enable(DFF_enable[2]),.out(read_data[2]));
	 DFF_16b DFF3(.data(write_data),.clk(clk),.rst_n(rst_n),.DFF_enable(DFF_enable[3]),.out(read_data[3]));
	 DFF_16b DFF4(.data(write_data),.clk(clk),.rst_n(rst_n),.DFF_enable(DFF_enable[4]),.out(read_data[4]));
	 DFF_16b DFF5(.data(write_data),.clk(clk),.rst_n(rst_n),.DFF_enable(DFF_enable[5]),.out(read_data[5]));
	 DFF_16b DFF6(.data(write_data),.clk(clk),.rst_n(rst_n),.DFF_enable(DFF_enable[6]),.out(read_data[6]));
	 DFF_16b DFF7(.data(write_data),.clk(clk),.rst_n(rst_n),.DFF_enable(DFF_enable[7]),.out(read_data[7]));
	 mux_8to1 mux0(.sel(read_register0),.in0(read_data[0]),.in1(read_data[1]),.in2(read_data[2]),.in3(read_data[3]),.in4(read_data[4]),.in5(read_data[5]),.in6(read_data[6]),.in7(read_data[7]),.out(read_data0));
	 mux_8to1 mux1(.sel(read_register1),.in0(read_data[0]),.in1(read_data[1]),.in2(read_data[2]),.in3(read_data[3]),.in4(read_data[4]),.in5(read_data[5]),.in6(read_data[6]),.in7(read_data[7]),.out(read_data1));

endmodule
