`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    22:46:39 12/16/2022 
// Design Name: 
// Module Name:    fr_round 
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
module fr_round(clock, resetn, in_significand, in_exponent, in_ov_sig, out_significand, out_exponent);
	input clock,resetn;
	
	input [24:0] in_significand;
	input [7:0] in_exponent;
	input in_ov_sig;
	
	output reg	[23:0] out_significand;
	output reg  [7:0] out_exponent;
	
	/////Rounding - input_significand�� ������ �ڸ��� 1�̸� 1 �÷��ְ� 0�̸� ����
	
	//rounding�� overflow�� �߻����� ���� �ص� �ȴ�. �������� ��� �ݿø��ϴ� �ڸ��� �ƹ��� ���� ���� �׻� 0���� ����� ����
	//�� round up�� ��� - overflow �߻� & in_significand[0]=1�� �� in_sifnificand[11:1]�� 1'b1 �����ֱ�
	//roundup ������´� ���� ���� �ڸ����� �ø� �߻��� - normalizing ��ĭ �ؾ� ��
	wire [24:0] temp_significand = {{1'b0}, in_significand[24:1]} + 1'b1;
	
	always@(posedge clock, negedge resetn) begin	
		if(!resetn) begin
			out_significand <= 0;
			out_exponent <= 0;
		end
		else begin
			if (in_ov_sig == 0) begin	//overflow = 0 >> �ݿø� �� �ʿ� ����
				out_significand = in_significand[23:0];
				out_exponent = in_exponent;
			end
			//overflow = 1 >> �ݿø� ���� >> in_significand[0] Ȯ���ϱ�
			else if (in_significand[0] == 0) begin	//�ݿø��ϴ� �ڸ� = 0 >> �ݿø� �� �ʿ� ����
				out_significand = in_significand[24:1];
				out_exponent = in_exponent;
			end
			else begin //overflow �߻�, �ݿø��ϴ� �ڸ� = 1 >>>> round up
				//temp_significand = {{1'b0}, in_significand[11:1]} + 1'b1;
				if (temp_significand[24] == 0) begin //�ݿø� �ߴµ� �ڸ��� ��ȭ X
					out_significand = temp_significand[23:0];
					out_exponent = in_exponent;
				end
				else begin //���� ���� �ڸ����� 1+1�߻��� �ڸ� �÷� ��� �� - exponent+1 �� normalizing ���ֱ�
					out_significand = temp_significand[24:1];
					out_exponent = in_exponent + 1;
				end				
			end
		end
	end
endmodule 