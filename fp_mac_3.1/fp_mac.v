`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    22:11:27 12/16/2022 
// Design Name: 
// Module Name:    fp_mac 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module fp_mac(clock, resetn, A, B, C, Y);
	input clock, resetn;
	
	input [15:0] A, B;	//new data
	input [31:0] C;		//data from previous MAC
	
	output [31:0] Y;
	
	wire [31:0] mul_out;
	wire [31:0] aged_C;
	wire [31:0] result;
	
	float_multiplier FM1(.clock(clock), .resetn(resetn), .A(A), .B(B), .result(mul_out));
	
	sum_out_buffer SB1(.clock(clock), .resetn(resetn), .input_data(C), .output_data(aged_C));
	
	float_adder FA1(.clock(clock), .resetn(resetn), .A(mul_out), .B(aged_C), .result(result));

	assign Y = result;

	text_write TW1(.clock(clock), .resetn(resetn), .in_result(result));

endmodule
