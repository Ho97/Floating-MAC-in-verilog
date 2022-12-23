`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:46:29 12/22/2022 
// Design Name: 
// Module Name:    fa_step1 
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
module fa_step1(CLK, RESETn, A, B, out_sign, current_ex, out_input1, out_input2, ov_yn);
	input CLK, RESETn;
	input [31:0] A, B;
	
	output reg out_sign;
	output reg [7:0] current_ex;
	output reg [23:0] out_input1, out_input2;
	output reg ov_yn;
	
	wire s_A = A[31];							//sign of A
	wire [7:0] ex_A = A[30:23];			//exponent of A
	wire [23:0] sg_A = {1'b1, A[22:0]};	//significand of A
	
	wire s_B = B[31];							//sign of B
	wire [7:0] ex_B = B[30:23];			//exponent of B
	wire [23:0] sg_B = {1'b1, B[22:0]};	//significand of B
	
	
	//EX comparison/////////////////////////////////////////////
	
	wire ex_comp = (ex_A > ex_B) ? 0:1;
	wire [7:0] bigger = (ex_comp) ? ex_B : ex_A;
	wire [7:0] smaller = (ex_comp) ? ex_A : ex_B;
	
	wire [7:0] ex_diff = bigger-smaller;
	wire [7:0] current_exponent = bigger;
	
	//shifting////////////////////////////////////////////////
	//in1 - exponent 작은 애 - shift right
	//in2 - exponent 큰 애 - 그대로
	
	wire [23:0] in1 = (ex_comp) ? sg_A >> ex_diff : sg_B >> ex_diff;
	wire [23:0] in2 = (ex_comp) ? sg_B : sg_A;
	wire sign_in2 = (ex_comp) ? s_B : s_A;
	wire sign_in1 = (ex_comp) ? s_A : s_B;
	
	//Addition prepare///////////////////////
	//같은 부호일 경우 output 부호 그대로 significand만 덧셈 -ov 판별
	//다른 부호일 경우 output 부호는 significand 절대값 큰 쪽 -ov 없음
	
	wire output_sign = (s_A == s_B) ? s_A : (in1 == in2) ? 0 : (in1 > in2) ? sign_in1 : sign_in2;
	wire ov_YN = (sign_in1 == sign_in2) ? 1 : 0;
	
	//다른 부호일 경우 significand 작은 쪽을 2's complement 진행
	wire [23:0] input1 = (s_A == s_B) ? in1 : (output_sign == sign_in1) ? in1 : ~in1+1;
	wire [23:0] input2 = (s_A == s_B) ? in2 : (output_sign == sign_in2) ? in2 : ~in2+1;
		
	
	//////////////////////////////////////////////////
	
	always@(posedge CLK, negedge RESETn)begin
		if(!RESETn)begin
			out_sign <= 0;
			current_ex <= 0;
			out_input1 <= 0;
			out_input2 <= 0;
			ov_yn <= 0;
		end
		else begin
			out_sign <= output_sign;
			current_ex <= current_exponent;
			out_input1 <= input1;
			out_input2 <= input2;
			ov_yn <= ov_YN;
		end
	end

endmodule
