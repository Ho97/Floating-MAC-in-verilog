`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    19:05:07 12/23/2022 
// Design Name: 
// Module Name:    mac_step3 
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
module mac_step3(CLK, RESETn, C, mul_sg, mul_count, mul_current_ex, mul_sign, add_out_sign, add_current_ex, out_input1, out_input2, ov_yn);
	input CLK, RESETn;
	input [31:0] C;
	input [21:0] mul_sg;
	input [4:0] mul_count;
	input [7:0] mul_current_ex;
	input mul_sign;
	
	output reg add_out_sign, ov_yn;
	output reg [7:0] add_current_ex;
	output reg [23:0] out_input1, out_input2;
	
	///////////////////////////////////////////////
	//multiplicaton output >> A
	//input C 				  >> B
	
	
	//normalize >> multiplier output
	wire s_A = mul_sign;
	
	wire [7:0] ex_A = mul_current_ex + mul_count -20;
	
	wire [23:0] sg_A = {{mul_sg << (21-mul_count)}, 2'b00};
	
	//input C
	wire s_B = C[31];							
	wire [7:0] ex_B = C[30:23];			
	wire [23:0] sg_B = {1'b1, C[22:0]};	
	
	////////////////////////////////////////////////
	
	//���⼭���� ADDER ����
	
	//EX comparison/////////////////////////////////////////////
	
	wire ex_comp = (ex_A > ex_B) ? 0:1;
	wire [7:0] bigger = (ex_comp) ? ex_B : ex_A;
	wire [7:0] smaller = (ex_comp) ? ex_A : ex_B;
	
	wire [7:0] ex_diff = bigger-smaller;
	wire [7:0] current_exponent = bigger;
	
	//shifting////////////////////////////////////////////////
	//in1 - exponent ���� �� - shift right
	//in2 - exponent ū �� - �״��
	
	wire [23:0] in1 = (ex_comp) ? sg_A >> ex_diff : sg_B >> ex_diff;
	wire [23:0] in2 = (ex_comp) ? sg_B : sg_A;
	wire sign_in2 = (ex_comp) ? s_B : s_A;
	wire sign_in1 = (ex_comp) ? s_A : s_B;
	
	//Addition prepare///////////////////////
	//���� ��ȣ�� ��� output ��ȣ �״�� significand�� ���� -ov �Ǻ�
	//�ٸ� ��ȣ�� ��� output ��ȣ�� significand ���밪 ū �� -ov ����
	
	wire output_sign = (s_A == s_B) ? s_A : (in1 == in2) ? 0 : (in1 > in2) ? sign_in1 : sign_in2;
	wire ov_YN = (sign_in1 == sign_in2) ? 1 : 0;
	
	//�ٸ� ��ȣ�� ��� significand ���� ���� 2's complement ����
	wire [23:0] input1 = (s_A == s_B) ? in1 : (output_sign == sign_in1) ? in1 : ~in1+1;
	wire [23:0] input2 = (s_A == s_B) ? in2 : (output_sign == sign_in2) ? in2 : ~in2+1;
	
	
	
	
	
	
	
	///////////////////////////////////////////
	always@(posedge CLK, negedge RESETn)begin
		if(!RESETn)begin
			add_out_sign <= 0;
			add_current_ex <= 0;
			out_input1 <= 0;
			out_input2 <= 0;
			ov_yn <= 0;
		end
		else begin
			add_out_sign <= output_sign;
			add_current_ex <= current_exponent;
			out_input1 <= input1;
			out_input2 <= input2;
			ov_yn <= ov_YN;
		end
	end
endmodule
