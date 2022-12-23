`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    18:54:21 12/17/2022 
// Design Name: 
// Module Name:    fr_adder_pre 
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
module fr_adder_pre(clock, resetn, sign_in1, sign_in2, in1, in2, out_input1, out_input2, out_sign);
	input clock, resetn;
	
	input sign_in1, sign_in2;
	input [23:0] in1, in2;

	output reg out_sign;
	output reg [23:0] out_input1, out_input2;
	
	 
	// ���+��� or ����+���� >> fraction ���� ����
	// ������ Sign�� ��� ���� �����ϱ� ������ ���밪�� �����൵ �ȴ�.
			
	// ���+���� or ����+��� >> ũ�� ���� ��ȣ ���� - ���밪 ���� �ָ� 2's complement�� �� ���� ���� - overflow �����Ѵ�.
	//sign=1 �̸� ����, sign=0 �̸� ���
	wire output_sign = (sign_in1 == sign_in2) ? sign_in1 : (in1 == in2) ?	0	: (in1 > in2) ?  sign_in1 : sign_in2;
										//sign ������	output��ȣ�״�� 		in1,in2������0		in1���밪 ũ�� in1 ��ȣ ����		in2 ���밪ũ�� in2��ȣ ����
		
	wire [23:0] input1 = (sign_in1 == sign_in2) ? in1 : (output_sign == sign_in1) ? in1 : ~in1+1;
	wire [23:0] input2 = (sign_in1 == sign_in2) ? in2 : (output_sign == sign_in2) ? in2 : ~in2+1;
							//				sign ������ �״��			�ٸ��� ���밪 ���� �ָ� 2's complement

	

	always@(posedge clock, negedge resetn) begin
		if(!resetn) begin
			out_sign <= 0;
			out_input1 <= 0;
			out_input2 <= 0;
		end
		else begin
			out_sign <= output_sign;
			out_input1 <= input1;
			out_input2 <= input2;
		end
	end

endmodule
