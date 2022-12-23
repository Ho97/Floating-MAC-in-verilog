`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    19:37:16 12/23/2022 
// Design Name: 
// Module Name:    mac_step5 
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
module mac_step5(CLK, RESETn, out_sign, current_ex, sum, ov, count, out_s, out_ex, out_sg);
	input CLK, RESETn;
	input out_sign, ov;
	input [7:0] current_ex;
	input [23:0] sum;
	input [4:0] count;
	
	output reg out_s;
	output reg [7:0] out_ex;
	output reg [23:0] out_sg;
	
	//NORMALIZE & Rounding//////////////////////////////////////////////////
	wire [24:0] normalized = {2'b01, sum[23:1]} + 1'b1;
	
	//overflow 발생 x >> normalizing만 진행 ---(1)
	//overflow 발생 o >> normallize 필요x >> 마지막 자리 확인 - 0 >> ex+1 하고 완료	--- (2)
	//						(가장 앞자리 항상 1)		마지막 자리 확인 - 1 >> round up >> overflow 발생 x >> ex+1, sg left shidt 1 하고 완료	---(3)
	//																								 overflow 발생 o >> 자리 올려 주기- exponent+1 로 normalizing 해주기 ---(4)
	
	always@(posedge CLK, negedge RESETn) begin
		if(!RESETn)begin
			out_s <= 0;
			out_ex <= 0;
			out_sg <= 0;
		end
		else begin
			if(!ov) begin //(1)
				out_s <= out_sign;
				out_ex <= current_ex - 23 + count;
				out_sg <= sum << (23-count);
			end
			else if (sum[0] == 0)begin //(2)
				out_s <= out_sign;
				out_ex <= current_ex + 1;
				out_sg <= {1'b1, sum[23:1]};
			end
			else if (normalized[24] == 0)begin //(3)
				out_s <= out_sign;
				out_ex <= current_ex +1;
				out_sg <= normalized[23:0];
			end
			else begin//(4)
				out_s <= out_sign;
				out_ex <= current_ex +2;
				out_sg <= normalized [24:1];
			end
		end
	end
   


endmodule
