`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    22:24:25 12/22/2022 
// Design Name: 
// Module Name:    fa_step3 
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
module fa_step3(CLK, RESETn, in_sign, in_ex, in_yn, P0, P2, G2, in_GG, out_sign, out_ex, out_yn, out_P0, out_GG);
	input CLK, RESETn;
	input in_sign, in_yn;
	input [7:0] in_ex;
	
	input [24:0] P0, P2, G2, in_GG;
	
	output reg out_sign, out_yn;
	output reg [7:0] out_ex;
	
	output reg [24:0] out_P0, out_GG;
		
	wire [24:0] GG; 
	assign GG[3:0] = in_GG[3:0];
	
	wire [24:0] P3, G3, P4, G4;
	
	//P3, G3 积己///////////////////////////////////
	
	genvar i;
	generate
		for(i=4 ; i<=7 ; i=i+1) begin: loop_KS3_G
			G_Cell G_U3(.G0(G2[i-4]), .G1(G2[i]), .P1(P2[i]), .GG(GG[i]));
		end
	endgenerate
	
	genvar j;
	generate
		for(j=8 ; j<=24 ; j=j+1) begin: loop_KS3_B
			B_Cell B_U3(.G0(G2[j-4]), .G1(G2[j]), .P0(P2[j-4]), .P1(P2[j]), .PP(P3[j]), .GG(G3[j]));
		end
	endgenerate
	
	assign G3[7:0] = GG[7:0];
	
	//P4, G4 积己////////////////////////////////////
	
	genvar k;
	generate
		for(k=8 ; k<=15 ; k=k+1) begin: loop_KS4_G
			G_Cell G_U4(.G0(G3[k-8]), .G1(G3[k]), .P1(P3[k]), .GG(GG[k]));
		end
	endgenerate
	
	assign P4[23:0] = P3[23:0];
	
	B_Cell B_U4(.G0(G3[16]), .G1(G3[24]), .P0(P3[16]), .P1(P3[24]), .PP(P4[24]), .GG(G4[24]));
	
	assign G4[23:16] = G3[23:16];
	assign G4[15:0] = GG[15:0];
	
	//GG 场鳖瘤 积己/////////////////////////////////
	
	genvar l;
	generate
		for(l=16 ; l<=23 ; l=l+1) begin: loop_KS5_G
			G_Cell G_U5(.G0(G4[l-8]), .G1(G4[l]), .P1(P4[l]), .GG(GG[l]));
		end
	endgenerate
		
	G_Cell G_U6(.G0(G4[8]), .G1(G4[24]), .P1(P4[24]), .GG(GG[24]));
	
	
	
	///////////////////////////////////////
	always@(posedge CLK, negedge RESETn) begin
		if(!RESETn) begin
			out_sign <= 0;
			out_yn <= 0;
			out_ex <= 0;
			out_P0 <= 0;
			out_GG <= 0;
		end
		else begin
			out_sign <= in_sign;
			out_yn <= in_yn;
			out_ex <= in_ex;
			out_P0 <= P0;
			out_GG <= GG;
		end
	end

endmodule
