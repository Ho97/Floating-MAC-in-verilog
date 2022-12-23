`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    19:21:30 12/23/2022 
// Design Name: 
// Module Name:    mac_step4 
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
module mac_step4(CLK, RESETn, in_sign, in_ex, input1, input2, ov_yn, sum, overflow, count, out_sign, out_ex);
	input CLK, RESETn;
	input in_sign, ov_yn;
	input [7:0] in_ex;
	input [23:0] input1, input2;
	
	output reg [23:0] sum;
	output reg overflow;
	output reg [4:0] count;
	
	output reg out_sign;
	output reg [7:0] out_ex;
	
	
	
	///P0, G0 积己//////////////////////////////////////
	wire [24:0] P0;
	assign P0[24:1] = input1 ^ input2;
	assign P0[0] = 0;
		
	wire [24:0] G0;
	assign G0[24:1] = input1 & input2;
	assign G0[0] = 0;
		
		
	///P1, G1 积己/////////////////////////////////////////////
	wire [24:0] P1, G1, GG;
	assign GG[0] = G0[0];
	
	G_Cell G_U1(.G0(G0[0]), .G1(G0[1]), .P1(P0[1]), .GG(GG[1]));
	
	genvar i;
	generate
		for(i=2 ; i<= 24; i=i+1)begin: loop_KS1
			B_Cell B_U1(.G0(G0[i-1]), .G1(G0[i]), .P0(P0[i-1]), .P1(P0[i]), .PP(P1[i]), .GG(G1[i]));
		end
	endgenerate
	
	assign G1[1:0] = GG[1:0];	
	
	
	///P2, G2 积己 ///////////////////////////////////////////////
	wire [24:0] P2, G2;
	G_Cell G_U21(.G0(G1[0]), .G1(G1[2]), .P1(P1[2]), .GG(GG[2]));	
	G_Cell G_U22(.G0(G1[1]), .G1(G1[3]), .P1(P1[3]), .GG(GG[3]));
	
	genvar j;
	generate
		for(j=4 ; j<=24 ; j=j+1) begin: loop_KS2_B
			B_Cell B_U2(.G0(G1[j-2]), .G1(G1[j]), .P0(P1[j-2]), .P1(P1[j]), .PP(P2[j]), .GG(G2[j]));
		end
	endgenerate
		
	assign G2[3:0] = GG[3:0];
	
	
	//P3, G3 积己///////////////////////////////////
	wire [24:0] P3, G3;
	
	genvar k;
	generate
		for(k=4 ; k<=7 ; k=k+1) begin: loop_KS3_G
			G_Cell G_U3(.G0(G2[k-4]), .G1(G2[k]), .P1(P2[k]), .GG(GG[k]));
		end
	endgenerate
	
	genvar l;
	generate
		for(l=8 ; l<=24 ; l=l+1) begin: loop_KS3_B
			B_Cell B_U3(.G0(G2[l-4]), .G1(G2[l]), .P0(P2[l-4]), .P1(P2[l]), .PP(P3[l]), .GG(G3[l]));
		end
	endgenerate
	
	assign G3[7:0] = GG[7:0];
	
	
	//P4, G4 积己////////////////////////////////////
	wire [24:0] P4, G4;
	
	genvar m;
	generate
		for(m=8 ; m<=15 ; m=m+1) begin: loop_KS4_G
			G_Cell G_U4(.G0(G3[m-8]), .G1(G3[m]), .P1(P3[m]), .GG(GG[m]));
		end
	endgenerate
	
	assign P4[23:0] = P3[23:0];
	
	B_Cell B_U4(.G0(G3[16]), .G1(G3[24]), .P0(P3[16]), .P1(P3[24]), .PP(P4[24]), .GG(G4[24]));
	
	assign G4[23:16] = G3[23:16];
	assign G4[15:0] = GG[15:0];
	
	
	//GG 场鳖瘤 积己/////////////////////////////////
	
	genvar n;
	generate
		for(n=16 ; n<=23 ; n=n+1) begin: loop_KS5_G
			G_Cell G_U5(.G0(G4[n-8]), .G1(G4[n]), .P1(P4[n]), .GG(GG[n]));
		end
	endgenerate
		
	G_Cell G_U6(.G0(G4[8]), .G1(G4[24]), .P1(P4[24]), .GG(GG[24]));
	
	
	//Summation//////////////////////////////////
	wire [24:1] S;
	
	genvar o;
	generate
		for (o=1 ; o<=24 ; o=o+1) begin: KS6_loop
			assign S[o] = P0[o] ^ GG[o-1];
		end
	endgenerate
	
	//overflow/////////////////////////////////////
	wire ov;
	
	assign ov = (ov_yn) ? GG[24] : 0;
	//in_yn (s_A, s_B 促福搁 0 - overflow 绝澜, 鞍栏搁 1 - overflow=cout
	
	
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
	
	
	
	
	
	
	///////////////////////////////////////////////
	always@(posedge CLK, negedge RESETn)begin
			if(!RESETn) begin
				out_sign <= 0;
				out_ex <= 0;
				
				sum <= 0;
				overflow <= 0;
			end
			else begin
				out_sign <= in_sign;
				out_ex <= in_ex;
				
				sum <= S;
				overflow <= ov;
			end
		end	
	
endmodule


//////////////////////////////////////////////////////////////////////////////////
module B_Cell(G0, G1, P0, P1, PP, GG);
	input G0, G1, P0, P1;
	output GG, PP;
	
	assign GG = G1 | (P1 & G0);
	assign PP = P0 & P1;
endmodule
//B_Cell = G_k-1:l, G_i:k, P_k-1:l, P_i:k >> G_i:l, P_i:l

module G_Cell(G0, G1, P1, GG);
	input G0, G1, P1;
	output GG;
	
	assign GG = G1 | (P1 & G0);
endmodule
//G_Cell = G_k-1:l, G_i:k, P_i:k >> G_i:0

