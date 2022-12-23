`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    22:29:12 12/16/2022 
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
module float_multiplier(A, B, result, clock, resetn);
	//Half precision floating point format : 16bit
	//1 bit	: sign
	//5 bits	: exponent >> 2^(exponent-15)  // bias=15
	//10bits : Fraction >> 11bits significant = (1+fraction)
	input clock, resetn;

	input [15:0] A, B;
	
	output [31:0] result;
	
	//single precision : 32bit
	//1bit :  sign
	//8bit : exponent >> 2^(exponent - 127) // bias = 127
	//23bit : fraction >> 24bits significant 
   
	////////////////////////Step1 Add exponents//////////////////////////
	
	wire s_A = A[15];							//sign of A
	wire [4:0] ex_A = A[14:10];			//exponent of A
	wire [10:0] sg_A = {1'b1, A[9:0]};	//significand of A
	
	wire s_B = B[15];							//sign of B
	wire [4:0] ex_B = B[14:10];			//exponent of B
	wire [10:0] sg_B = {1'b1, B[9:0]};	//significand of B
	
	//step1 output////////////////////////////////
	wire [7:0] step1_ex_add_out;
	wire step1_out_sign;
	wire [10:0] step1_sg_A, step1_sg_B;
	///////////////////////////////////////////////
	
	ex_adder EA1(.clock(clock), .resetn(resetn), .ex_A(ex_A), .ex_B(ex_B), .out_ex(step1_ex_add_out));
	
	sign_determine SD1(.clock(clock), .resetn(resetn), .s_A(s_A), .s_B(s_B), .out_sign(step1_out_sign));
	
	step1_status SS1(.clock(clock), .resetn(resetn), .in_significand_A(sg_A), .in_significand_B(sg_B), .out_significand_A(step1_sg_A), .out_significand_B(step1_sg_B));
	
	
	
	////////////////////////step2 significand multiply//////////////////////////
	
	//step2 output////////////////////////////////
	wire [7:0] step2_ex_add_out;
	wire step2_out_sign;
	wire [21:0] step2_significand_mul_out; 
	/////////////////////////////////////////////
	
	step2_status SS2(.clock(clock), .resetn(resetn), .in_ex_add_out(step1_ex_add_out), .in_out_sign(step1_out_sign), .out_ex_add_out(step2_ex_add_out), .out_out_sign(step2_out_sign));
	
	sg_multiplier SM1(.clock(clock), .resetn(resetn), .in_sg_A(step1_sg_A), .in_sg_B(step1_sg_B), .multiplier_out(step2_significand_mul_out));
	
	
	////////////////////////step3 firt one detect///////////////////////////////
	
	//step3 output/////////////////////////////
	wire step3_out_sign;
	wire [7:0] step3_ex_add_out;
	wire [21:0] step3_significand_mul_out;
	wire [4:0] step3_count;
	/////////////////////////////////////////
	
	step3_status SS3(.clock(clock), .resetn(resetn), .in_out_sign(step2_out_sign), .in_ex_add_out(step2_ex_add_out), .in_sig_mul_out(step2_significand_mul_out), .out_out_sign(step3_out_sign), .out_ex_add_out(step3_ex_add_out), .out_sig_mul_out(step3_significand_mul_out));
	
	sg_firstone SF1(.clock(clock), .resetn(resetn), .in_sig_mul_out(step2_significand_mul_out), .out_count(step3_count));
	
	///////////////////////step4 normalize/////////////////////////////////////
	
	//step4 output ////////////////////////////////
	wire step4_out_sign;
	wire [7:0] step4_out_exponent;
	wire [23:0] step4_out_significand;
	////////////////////////////////////////////////
	
	step4_status SS4(.clock(clock), .resetn(resetn), .in_out_sign(step3_out_sign), .out_out_sign(step4_out_sign));
	
	sg_normalizer SN1(.clock(clock), .resetn(resetn), .in_ex(step3_ex_add_out), .in_mul_out_sig(step3_significand_mul_out), .in_count(step3_count), .out_ex(step4_out_exponent), .sig_nor_out(step4_out_significand));
	
	
	////////////////////Result//////////////////////////////////////////////////
	
	wire [31:0] fp_mul_out;
	
	result_status RS(.clock(clock), .resetn(resetn), .out_sign(step4_out_sign), .out_exponent(step4_out_exponent), .out_significand(step4_out_significand), .fp_mul_out(fp_mul_out));
	
	assign result = fp_mul_out;
	
	

endmodule 