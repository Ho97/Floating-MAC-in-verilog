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
	
	/////Rounding - input_significand의 마지막 자리가 1이면 1 올려주고 0이면 버림
	
	//rounding은 overflow가 발생했을 때만 해도 된다. 나머지의 경우 반올림하는 자리에 아무런 값이 없고 항상 0으로 비워져 있음
	//즉 round up만 고려 - overflow 발생 & in_significand[0]=1일 때 in_sifnificand[11:1]에 1'b1 더해주기
	//roundup 더해줬는대 가장 높은 자리에서 올림 발생시 - normalizing 한칸 해야 됨
	wire [24:0] temp_significand = {{1'b0}, in_significand[24:1]} + 1'b1;
	
	always@(posedge clock, negedge resetn) begin	
		if(!resetn) begin
			out_significand <= 0;
			out_exponent <= 0;
		end
		else begin
			if (in_ov_sig == 0) begin	//overflow = 0 >> 반올림 할 필요 없음
				out_significand = in_significand[23:0];
				out_exponent = in_exponent;
			end
			//overflow = 1 >> 반올림 진행 >> in_significand[0] 확인하기
			else if (in_significand[0] == 0) begin	//반올림하는 자리 = 0 >> 반올림 할 필요 없음
				out_significand = in_significand[24:1];
				out_exponent = in_exponent;
			end
			else begin //overflow 발생, 반올림하는 자리 = 1 >>>> round up
				//temp_significand = {{1'b0}, in_significand[11:1]} + 1'b1;
				if (temp_significand[24] == 0) begin //반올림 했는데 자리수 변화 X
					out_significand = temp_significand[23:0];
					out_exponent = in_exponent;
				end
				else begin //가장 높은 자리에서 1+1발생해 자리 올려 줘야 함 - exponent+1 로 normalizing 해주기
					out_significand = temp_significand[24:1];
					out_exponent = in_exponent + 1;
				end				
			end
		end
	end
endmodule 