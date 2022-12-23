`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:32:23 12/22/2022 
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
module float_adder(CLK, RESETn, A, B, result);
	input CLK, RESETn;
	input [31:0] A, B;
	
	output [31:0] result;
	
	////STEP1 - ex_comparison, shifter, input1 과 input2로 치환////////////////
	//in - A, B
	//out - out_sign, current_ex, input1, input2, ov_yn
	
	wire fa1_out_sign;
	wire [7:0] fa1_current_ex;
	wire [23:0] fa1_input1, fa1_input2;
	wire fa1_ov_yn;
	
	fa_step1 FA1(.CLK(CLK), .RESETn(RESETn), .A(A), .B(B), .out_sign(fa1_out_sign), .current_ex(fa1_current_ex), .out_input1(fa1_input1), .out_input2(fa1_input2), .ov_yn(fa1_ov_yn));
	///////////////////////////////////////////////////////////
	
	//KS Adder information- 24bit
	//G0 i:i 		P0 i:i
	//G1 i:i-1		P1 i:i-1
	//G2 i:i-3		P2 i:i-3
	//G3 i:i-7		P2 i:i-7
	//G4 i:i-15		P4 i:i-15
	//GG i:0
	//S[i] = P0[i] ^ GG[i-1]
	
	///STEP2 P0, G0 생성, KS Adder 2line 진행
	//in - input1, input2
	//out - P0, P2, G2, GG
	//transfer - out_sign, current_ex, ov_yn
	
	wire [24:0] fa2_P0;
	wire [24:0] fa2_P2;
	wire [24:0] fa2_G2;
	wire [24:0] fa2_GG;
	
	wire fa2_out_sign;
	wire [7:0] fa2_current_ex;
	wire fa2_ov_yn;
	
	fa_step2 FA2(.CLK(CLK), .RESETn(RESETn), .in_sign(fa1_out_sign), .in_ex(fa1_current_ex), .in_yn(fa1_ov_yn), .input1(fa1_input1), .input2(fa1_input2), .out_P0(fa2_P0), .out_P2(fa2_P2), .out_G2(fa2_G2), .out_GG(fa2_GG), .out_sign(fa2_out_sign), .out_ex(fa2_current_ex), .out_yn(fa2_ov_yn));
	//////////////////////////////////////////////////////////////////////
	
	
	///STEP3 P0와 GG[23:0] 생성까지
	//in  - P0, P2, G2, GG[3:0]까지
	//out - P0, GG
	//transfer - out-sign, current_ex, ov_yn
	
	wire [24:0] fa3_P0, fa3_GG;
	
	wire fa3_out_sign, fa3_ov_yn;
	wire [7:0] fa3_current_ex;
	
   fa_step3 FA3(.CLK(CLK), .RESETn(RESETn), .in_sign(fa2_out_sign), .in_ex(fa2_current_ex), .in_yn(fa2_ov_yn), .P0(fa2_P0), .P2(fa2_P2), .G2(fa2_G2), .in_GG(fa2_GG), .out_sign(fa3_out_sign), .out_ex(fa3_current_ex), .out_yn(fa3_ov_yn), .out_P0(fa3_P0), .out_GG(fa3_GG));
	////////////////////////////////////////////////////////////////
	
	
	//STEP4 Adder Summation 완성, Firstone determine
	//overflow signal - ov_yn 활용 (yn=0 - Cout 상관없이 overflow 없음, yn=1 - Cout=overflow)
	//in  - P0, GG, ov_yn
	//out - sum, overflow, count
	//transfer - out_sign, current_ex
	
	wire [23:0] fa4_sum;
	wire fa4_ov;
	
	wire fa4_out_sign;
	wire [7:0] fa4_current_ex;
	wire [4:0] fa4_count;
	
	fa_step4 FA4(.CLK(CLK), .RESETn(RESETn), .in_sign(fa3_out_sign), .in_ex(fa3_current_ex), .in_yn(fa3_ov_yn), .P0(fa3_P0), .GG(fa3_GG), .sum(fa4_sum), .ov(fa4_ov), .out_sign(fa4_out_sign), .out_ex(fa4_current_ex), .count(fa4_count));
	
	
	//STEP5 NORMALIZE & Round & noramlzie >> result//////////////////////////
	//in  - out_sign, current_ex, sum, overflow, count
	//out - out_sign, out_ex, out_sg
	
	wire fa5_out_sign;
	wire [7:0] fa5_out_exponent;
	wire [23:0] fa5_out_significand;
	
	fa_step5 FA5(.CLK(CLK), .RESETn(RESETn), .out_sign(fa4_out_sign), .current_ex(fa4_current_ex), .sum(fa4_sum), .ov(fa4_ov), .count(fa4_count), .out_s(fa5_out_sign), .out_ex(fa5_out_exponent), .out_sg(fa5_out_significand));

	
	assign result = {fa5_out_sign, fa5_out_exponent, fa5_out_significand[22:0]};
	

endmodule
