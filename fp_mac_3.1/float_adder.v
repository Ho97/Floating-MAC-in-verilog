`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    22:39:36 12/16/2022 
// Design Name: 
// Module Name:    float_adder 
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
module float_adder(A, B, result, clock, resetn);
	//Half precision floating point format : 16bit
	//1 bit	: sign
	//8 bits	: exponent >> 2^(exponent-127)  // bias=127
	//23bits : Fraction >> 241bits significant = (1+fraction)
	input clock, resetn;

	input [31:0] A, B;
	
	output [31:0] result;
	
	
	////////////////////////////STEP1 - Compare exponents & shift smaller number right////////////////////////////////////////////////////////////////
	
	wire s_A = A[31];							//sign of A
	wire [7:0] ex_A = A[30:23];			//exponent of A
	wire [23:0] sg_A = {1'b1, A[22:0]};	//significand of A
	
	wire s_B = B[31];							//sign of B
	wire [7:0] ex_B = B[30:23];			//exponent of B
	wire [23:0] sg_B = {1'b1, B[22:0]};	//significand of B
	
	
	//step1 output//////////////////////////////	
	wire	[23:0] step1_in1, step1_in2;
	wire	step1_sign_in1, step1_sign_in2;
	wire	[7:0] step1_current_ex;
	////////////////////////////////////////////

	wire ex_compare;
	wire [7:0] ex_diff;
	
	ex_comparison C1 ( .ex_A(ex_A), .ex_B(ex_B), .ex_compare(ex_compare), .ex_diff(ex_diff)); 
	
	step1_adder_status AS1 (.clock(clock), .resetn(resetn), .s_A(s_A), .s_B(s_B), .ex_A(ex_A), .ex_B(ex_B), .ex_compare(ex_compare), .sign_in1(step1_sign_in1), .sign_in2(step1_sign_in2), .current_ex(step1_current_ex));
	
	fr_shifter S1(.clock(clock), .resetn(resetn), .A(sg_A), .B(sg_B),  .comp(ex_compare), .diff(ex_diff), .out_in1(step1_in1), .out_in2(step1_in2));

	/////////////////////////////STEP2 - ADD//////////////////////////////////////////////////////////////////
	
	//step2 output///////////////////////////////
	wire	[23:0] step2_adder_out; 
	wire	step2_ov_sign;
	wire	step2_adder_out_sign;
	wire	step2_sign_in1, step2_sign_in2;
	wire	[7:0] step2_current_ex;
	/////////////////////////////////////////////
	
	fr_adder A1(.clock(clock), .resetn(resetn), .in1(step1_in1), .sign_in1(step1_sign_in1), .in2(step1_in2), .sign_in2(step1_sign_in2), .out(step2_adder_out), .adder_out_sign(step2_adder_out_sign), .overflow_signal(step2_ov_sign));
	
	step2_adder_status AS2 (.clock(clock), .resetn(resetn), .in_sign_in1(step1_sign_in1), .in_sign_in2(step1_sign_in2), .in_current_ex(step1_current_ex), .out_sign_in1(step2_sign_in1), .out_sign_in2(step2_sign_in2), .out_current_ex(step2_current_ex));
	
	
	///////////////step3 - firstone location//////////////////////////
	
	//step3_output///////////////////////////
	wire [23:0] step3_adder_out;
	wire step3_ov_sign;
	wire step3_adder_out_sign;
	wire [7:0] step3_current_ex;
	wire [7:0] step3_count;
	//////////////////////////////////////////
	
	
	fr_firstone FO1(.clock(clock), .resetn(resetn), .nor_input(step2_adder_out), .count(step3_count));
	
	step3_adder_status AS3(.clock(clock), .resetn(resetn), .in_adder_out(step2_adder_out), .in_ov_sign(step2_ov_sign), .in_adder_out_sign(step2_adder_out_sign), .in_sign_in1(step2_sign_in1), .in_sign_in2(step2_sign_in2), .in_current_ex(step2_current_ex), .out_adder_out(step3_adder_out), .out_ov_sign(step3_ov_sign), .out_adder_out_sign(step3_adder_out_sign), .out_current_ex(step3_current_ex)); 
	
	
	
	/////////////////////////////STEP4 - Normalize/////////////////////////////////////////////////////////////
	
	//step4 output///////////////////////////////////
	wire	[24:0] step4_significand;	//Normalizr output significand - 반올림 안된 데이터라 1자리 더 추가됨 - 25비트
	wire	[7:0] step4_exponent;
	wire	step4_output_sign;
	wire	step4_ov_sign;
	//////////////////////////////////////////
	
	
	fr_normalize N1(.clock(clock), .resetn(resetn), .count(step3_count), .nor_input(step3_adder_out), .nor_ov_sig(step3_ov_sign), .current_ex(step3_current_ex), .nor_out_significand(step4_significand), .nor_out_exponent(step4_exponent));
	
	step4_adder_status AS4 (.clock(clock), .resetn(resetn), .in_current_sign(step3_adder_out_sign), .in_ov_sign(step3_ov_sign), .out_sign(step4_output_sign), .out_ov_sign(step4_ov_sign));
	
	
	////////////////////////////STEP5 - Rounding & Normalize///////////////////////////
	//Normalize까지 한 fraction 마지막 자리에서 반올림
	//반올림 했는데 자리수가 바뀔 수도 있으니 Normalize 한번 더 진행
	//반올림은 마지막 자리가 1이면 1 올리고 마지막 자리가 0 이면 버림 
	
	//step4 output////////////////////////////////
	wire [23:0] step5_significand;
	wire [7:0] step5_exponent;
	wire step5_output_sign;
	////////////////////////////////////////////
	
	fr_round R1(.clock(clock), .resetn(resetn), .in_significand(step4_significand), .in_exponent(step4_exponent), .in_ov_sig(step4_ov_sign), .out_significand(step5_significand), .out_exponent(step5_exponent));
	
	step5_adder_status AS5 (.clock(clock), .resetn(resetn), .in_current_sign(step4_output_sign), .out_sign(step5_output_sign));
	
	
	///////////////////////////Result///////////////////////////////////////
	wire [31:0] fp_adder_out;
	
	result_adder_status ARS1 (.clock(clock), .resetn(resetn), .sign(step5_output_sign), .exponent(step5_exponent), .significand(step5_significand), .fp_adder_output(fp_adder_out));
	
	assign result = fp_adder_out;
	
	
	
	
	
endmodule
