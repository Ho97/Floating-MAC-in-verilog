`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    21:42:45 12/22/2022 
// Design Name: 
// Module Name:    fa_step2 
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
module fa_step2(CLK, RESETn, in_sign, in_ex, in_yn, input1, input2, out_P0, out_P2, out_G2, out_GG, out_sign, out_ex, out_yn);
		input CLK, RESETn;
		input in_sign, in_yn;
		input [7:0] in_ex;
		
		input [23:0] input1, input2;
		
		output reg out_sign, out_yn;
		output reg [7:0] out_ex;
		
		output reg [24:0] out_P0, out_P2, out_G2, out_GG;
		
		//////////////////////////////////////////////////////

		///P0, G0 持失//////////////////////////////////////
		wire [24:0] P0;
		assign P0[24:1] = input1 ^ input2;
		assign P0[0] = 0;
		
		wire [24:0] G0;
		assign G0[24:1] = input1 & input2;
		assign G0[0] = 0;
		
		
		///P1, G1 持失/////////////////////////////////////////////
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
		
		
		///P2, G2 持失 ///////////////////////////////////////////////
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
		
		////////////////////////////////////////////////
		
		always@(posedge CLK, negedge RESETn)begin
			if(!RESETn) begin
				out_sign <= 0;
				out_yn <= 0;
				out_ex <= 0;
				out_P0 <= 0;
				out_P2 <= 0;
				out_G2 <= 0;
				out_GG <= 0;				
			end
			else begin
				out_sign <= in_sign;
				out_yn <= in_yn;
				out_ex <= in_ex;
				out_P0 <= P0;
				out_P2 <= P2;
				out_G2 <= G2;
				out_GG <= GG;
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
