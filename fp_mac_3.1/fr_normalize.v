`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    22:45:54 12/16/2022 
// Design Name: 
// Module Name:    fr_normalize 
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
module fr_normalize(clock, resetn, count, nor_input, nor_ov_sig, current_ex, nor_out_significand, nor_out_exponent);
	input clock, resetn;	
		
	input [7:0] count;	
	input [23:0] nor_input;
	input nor_ov_sig;
	input [7:0] current_ex;
	
	output reg [24:0] nor_out_significand;
	output reg [7:0] nor_out_exponent;

	always@(posedge clock, negedge resetn) begin
		if(!resetn) begin
			nor_out_significand <= 0;
			nor_out_exponent <=0;
		end
		else begin
			if (!nor_ov_sig) begin		//overflow=0 >> �ٷ� normalize
				nor_out_significand = {{1'b0}, nor_input << (23-count)}; //1.######�� �ǵ��� normalize
				nor_out_exponent = current_ex - 23 + count;
			end
			else begin //overflow �߻�
				nor_out_significand = {1'b1, nor_input}; //overflow�̸� ù ��Ʈ�� �׻� 1 
				nor_out_exponent = current_ex + 1;	//overflow�� ���ڸ� �� Ŀ�� �Ŵϱ� exponent�� 1 ������
			end		
		end
	end	
endmodule 


