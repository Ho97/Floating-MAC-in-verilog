`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    22:45:44 12/22/2022 
// Design Name: 
// Module Name:    fa_step4 
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
module fa_step4(CLK, RESETn, in_sign, in_ex, in_yn, P0, GG, sum, ov, out_sign, out_ex, count);
	input CLK, RESETn;
	
	input in_sign, in_yn;
	input [7:0] in_ex;
	
	input [24:0] P0, GG;
	
	output reg ov, out_sign;
	output reg [7:0] out_ex;
	output reg [23:0] sum;
	output reg [4:0] count;
	
	//Summation//////////////////////////////////
	wire [24:1] S;
	
	genvar i;
	generate
		for (i=1 ; i<=24 ; i=i+1) begin: KS6_loop
			assign S[i] = P0[i] ^ GG[i-1];
		end
	endgenerate
	
	
	//overflow/////////////////////////////////////
	wire overflow;
	
	assign overflow = (in_yn) ? GG[24] : 0;
	//in_yn (s_A, s_B 다르면 0 - overflow 없음, 같으면 1 - overflow=cout
	
	
	//firstone detection///////////////////////////////////
	always@(posedge CLK, negedge RESETn) begin
		if(!RESETn)	count = 23;
		else if (S[24]==1) count = 23;
		else if (S[23]==1) count = 22;
		else if (S[22]==1) count = 21;
		else if (S[21]==1) count = 20;
		else if (S[20]==1) count = 19;
		else if (S[19]==1) count = 18;
		else if (S[18]==1) count = 17;
		else if (S[17]==1) count = 16;
		else if (S[16]==1) count = 15;
		else if (S[15]==1) count = 14;
		else if (S[14]==1) count = 13;
		else if (S[13]==1) count = 12;
		else if (S[12]==1) count = 11;
		else if (S[11]==1) count = 10;
		else if (S[10]==1) count = 9;
		else if (S[9]==1) count = 8;
		else if (S[8]==1) count = 7;
		else if (S[7]==1) count = 6;
		else if (S[6]==1) count = 5;
		else if (S[5]==1) count = 4;
		else if (S[4]==1) count = 3;
		else if (S[3]==1) count = 2;
		else if (S[2]==1) count = 1;
		else if (S[1]==1) count = 0;
		else count = 23;
	end
	




	////////////////////////////////////
	always@(posedge CLK, negedge RESETn)begin
		if(!RESETn)begin
			ov <= 0;
			out_sign <= 0;
			out_ex <= 0;
			sum <= 0;
		end
		else begin
			out_sign <= in_sign;
			out_ex <= in_ex;
			ov <= overflow;
			sum <= S;
		end
	end
endmodule



