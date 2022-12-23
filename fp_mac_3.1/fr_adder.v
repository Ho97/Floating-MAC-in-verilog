`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    22:43:28 12/16/2022 
// Design Name: 
// Module Name:    fr_adder 
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
module fr_adder(clock, resetn, in1, sign_in1, in2, sign_in2, out, adder_out_sign, overflow_signal);
	input clock, resetn;
	
	input [23:0] in1, in2;
	input sign_in1, sign_in2;
	
	output [23:0] out;
	output adder_out_sign;
	output overflow_signal;
	
	///////kogge_stone_adder//////////////////
	//	6 step
	//	bw = 24
	//	입력은 KS0에서 input1과 input2로 바뀐 후 G0, P0로 변환되어 다음 step으로 전달
	//	입력 : [23:0] input1, input2 // Cin=0
	//	츨력 : [23:0] out,   Cout >> overflow_signal
	//	out[i] == GG[i] = G_CELL ( G_k-1:0, G_i:k, P_k-1:l )	

	//KS0 - G0, P0완성 + output sign 확인////////////////
	//KS0 output
	wire [23:0] KS0_input1; 
	wire [23:0] KS0_input2; 
	wire KS0_out_sign;
		
	fr_adder_pre KS0(.clock(clock), .resetn(resetn), .sign_in1(sign_in1), .sign_in2(sign_in2), .in1(in1), .in2(in2), .out_input1(KS0_input1), .out_input2(KS0_input2), .out_sign(KS0_out_sign));
	
	
	//KS0_5 
	
	wire [24:0] KS0_1_G0; //G0 i:i
	wire [24:0] KS0_1_P0; //P0 i:i
	wire KS0_1_out_sign;
	
	
	
	fr_adder_prepare KS0_1(.clock(clock), .resetn(resetn), .input1(KS0_input1), .input2(KS0_input2), .in_out_sign(KS0_out_sign), .out_out_sign(KS0_1_out_sign), .G0(KS0_1_G0), .P0(KS0_1_P0));
	
	
	//step1////////////////////////////////////////////////////
	//in 	- G0, P0        				out_sign
	//out - G1, P1, P0, GG[1:0]		out_sign
	
	wire [24:0] KS1_G1;  //G i:i-1
	wire [24:0] KS1_P1;	//P i:i-1
	wire [24:0] KS1_P0;
	wire [24:0] KS1_GG; 
	wire KS1_out_sign; 
	
	KS_step1 KS1(.clock(clock), .resetn(resetn), .G0(KS0_1_G0), .P0(KS0_1_P0), .in_sign(KS0_1_out_sign), .out_G1(KS1_G1), .out_P1(KS1_P1), .out_P0(KS1_P0), .out_GG(KS1_GG), .out_sign(KS1_out_sign));
	
	
	//step2///////////////////////////////////////////////////////
	//in 	- G1, P1, P0, GG[1:0] 		out_sign
	//out - G2, P2, P0, GG[3:0]		out_sign
	
	wire [24:0] KS2_G2;	//G i:i-3
	wire [24:0] KS2_P2;  //P i:i-3
	wire [24:0] KS2_P0;
	wire [24:0] KS2_GG; //3-0까지의 out
	wire KS2_out_sign;
	
	KS_step2 KS2(.clock(clock), .resetn(resetn), .G1(KS1_G1), .P1(KS1_P1), .P0(KS1_P0), .in_GG(KS1_GG), .in_sign(KS1_out_sign), .out_G2(KS2_G2), .out_P2(KS2_P2), .out_P0(KS2_P0), .out_GG(KS2_GG), .out_sign(KS2_out_sign));
	
	
	//step3/////////////////////////////////////////////////////////
	//in  - G2, P2, P0, GG[3:0]			out_sign
	//out - G3, P3, P0, GG[7:0]			out_sign
	
	wire [24:0] KS3_G3;	//G i:i-7
	wire [24:0] KS3_P3;  //P i:i-7
	wire [24:0] KS3_P0;
	wire [24:0]	KS3_GG;
	wire KS3_out_sign;
	
	KS_step3 KS3(.clock(clock), .resetn(resetn), .G2(KS2_G2), .P2(KS2_P2), .P0(KS2_P0), .in_GG(KS2_GG), .in_sign(KS2_out_sign), .out_G3(KS3_G3), .out_P3(KS3_P3), .out_P0(KS3_P0), .out_GG(KS3_GG), .out_sign(KS3_out_sign));
	
	
	//step4////////////////////////////////////////////////////
	//in  - G3, P3, P0, GG[7:0] 		out_sign
	//out - G4, P4, P0, GG[15:0] 		out_sign
	//이번 스텝에서는 i=8~15까지만 G_Cell만 적용
	//Cout을 위한 마지막 B_Cell
	
	wire [24:0] KS4_G4; //G i:i-15
	wire [24:0] KS4_P4; //P i:i-15
	wire [24:0] KS4_P0;
	wire [24:0] KS4_GG;
	wire KS4_out_sign;
	
	KS_step4 KS4(.clock(clock), .resetn(resetn), .G3(KS3_G3), .P3(KS3_P3), .P0(KS3_P0), .in_GG(KS3_GG), .in_sign(KS3_out_sign), .out_G4(KS4_G4), .out_P4(KS4_P4), .out_P0(KS4_P0), .out_GG(KS4_GG), .out_sign(KS4_out_sign));

	
	//step5//////////////////////////////////////////
	//in 	- G4, P4, p0, GG[15:0]				out_sign
	//out - 			 P0, GG[23:0]			 	out_sign
	
	wire [24:0] KS5_P0;
	wire [24:0] KS5_GG;
	wire KS5_out_sign;
	
	KS_step5 KS5(.clock(clock), .resetn(resetn), .G4(KS4_G4), .P4(KS4_P4), .P0(KS4_P0), .in_GG(KS4_GG), .in_sign(KS4_out_sign), .out_P0(KS5_P0), .out_GG(KS5_GG), .out_sign(KS5_out_sign));

	
	//step6////////////////////////////////////////
	//in  - P0, GG, out_sign
	//out - Sum, Cout, out_sign
	wire [24:1] KS6_Sum;
	wire KS6_Cout;
	wire KS6_out_sign;
	
	KS_step6 KS6(.clock(clock), .resetn(resetn), .P0(KS5_P0), .GG(KS5_GG), .in_sign(KS5_out_sign), .Sum(KS6_Sum), .Cout(KS6_Cout), .out_sign(KS6_out_sign));
	
	assign out = KS6_Sum;
	assign overflow_signal = KS6_Cout;
	assign adder_out_sign = KS6_out_sign;
	
endmodule























