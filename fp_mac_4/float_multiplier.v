`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:10:48 12/22/2022 
// Design Name: 
// Module Name:    float_multiplier 
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
module float_multiplier(CLK, RESETn, A, B, result);
	//Half precision floating point format : 16bit
	//1 bit	: sign
	//5 bits	: exponent >> 2^(exponent-15)  // bias=15
	//10bits : Fraction >> 11bits significant = (1+fraction)
	input CLK, RESETn;

	input [15:0] A, B;
	
	output [31:0] result;
	
	//single precision : 32bit
	//1bit :  sign
	//8bit : exponent >> 2^(exponent - 127) // bias = 127
	//23bit : fraction >> 24bits significant 
   /////////////////////////////////////////////////////////////////////////////
	
			
	////Step1 - exponent add, array multiplier 1st summation
	//in - A, B
	//out - ex_added, out_sign, temp_p_r1, temp_s_r1
	
	wire [7:0] fm1_ex_added;
	wire fm1_out_sign;
	wire [21:0] fm1_temp_p_r1[10:2];
	wire [21:0] fm1_temp_s_r1;
		
	fm_step1 FM1(.CLK(CLK), .RESETn(RESETn), .A(A), .B(B), .ex_add(fm1_ex_added), .out_sign(fm1_out_sign), .temp_p_r1_2(fm1_temp_p_r1[2]), .temp_p_r1_3(fm1_temp_p_r1[3]), .temp_p_r1_4(fm1_temp_p_r1[4]), .temp_p_r1_5(fm1_temp_p_r1[5]), .temp_p_r1_6(fm1_temp_p_r1[6]), .temp_p_r1_7(fm1_temp_p_r1[7]), .temp_p_r1_8(fm1_temp_p_r1[8]), .temp_p_r1_9(fm1_temp_p_r1[9]), .temp_p_r1_10(fm1_temp_p_r1[10]), .temp_s_r1(fm1_temp_s_r1));
	
	////////////////////////////////////////////////////////
	
	
	///Step2 - array multiplier 2nd summation - 9th summation//////////
	// in - temp_p_r1, temp_s_r1
	// out - temp_p_r9, temp_s_r9
	// transfer - ex_added, out_sign
	
	wire [7:0] fm2_ex_added;
	wire fm2_out_sign;
	
	wire [21:0] fm2_temp_p_r9;
	wire [21:0] fm2_temp_s_r9;
	
	fm_step2 FM2(.CLK(CLK), .RESETn(RESETn), .in_ex(fm1_ex_added), .in_sign(fm1_out_sign), .temp_p_r1_2(fm1_temp_p_r1[2]), .temp_p_r1_3(fm1_temp_p_r1[3]), .temp_p_r1_4(fm1_temp_p_r1[4]), .temp_p_r1_5(fm1_temp_p_r1[5]), .temp_p_r1_6(fm1_temp_p_r1[6]), .temp_p_r1_7(fm1_temp_p_r1[7]), .temp_p_r1_8(fm1_temp_p_r1[8]), .temp_p_r1_9(fm1_temp_p_r1[9]), .temp_p_r1_10(fm1_temp_p_r1[10]), .temp_s_r1(fm1_temp_s_r1), .out_ex(fm2_ex_added), .out_sign(fm2_out_sign), .temp_p_r9(fm2_temp_p_r9), .temp_s_r9(fm2_temp_s_r9));
	
	/////////////////////////////////////////////////////////////////////
	
	
	///Step3 - array multiplier 10th summation & finding first one of mul_out/////
	//in - temp_p_r9, temp_s_r9
	//out - mul_out, firstone_count
	//transfer - ex_added, out_sign
	
	wire [7:0] fm3_ex_added;
	wire fm3_out_sign;
	
	wire [21:0] fm3_mul_out;
	wire [4:0] fm3_count;
	
	fm_step3 FM3(.CLK(CLK), .RESETn(RESETn), .in_ex(fm2_ex_added), .in_sign(fm2_out_sign), .temp_p_r9(fm2_temp_p_r9), .temp_s_r9(fm2_temp_s_r9), .out_ex(fm3_ex_added), .out_sign(fm3_out_sign), .mul_out(fm3_mul_out), .count(fm3_count));
	
	//////////////////////////////////////////////////////////////////////////

	
	///STEP4 - normalize & make result
	//in - mul_out, ex_added, count, out_sign
	//out - result
	
	wire [31:0] output_result;

	fm_step4 FM4(.CLK(CLK), .RESETn(RESETn), .ex_added(fm3_ex_added), .out_sign(fm3_out_sign), .mul_out(fm3_mul_out), .count(fm3_count), .result(output_result));

	assign result = output_result;


endmodule 




















