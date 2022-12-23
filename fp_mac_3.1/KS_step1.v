`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    19:18:45 12/17/2022 
// Design Name: 
// Module Name:    KS_step1 
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
module KS_step1(clock, resetn, G0, P0, in_sign, out_G1, out_P1, out_P0, out_GG, out_sign);
	input clock, resetn;
	
	input [24:0] G0, P0; //G0[i]=G_i:i, P0[i]=P_i:i
	input in_sign;
	
	output reg [24:0] out_G1, out_P1;	//G1[i]=G_i:i-1, P1[i]=P_i:i-1
	output reg [24:0] out_P0;
	output reg [24:0] out_GG;			   //GG[i]=G_i:0, PP[i]=P_i:0
	output reg out_sign;
	
	wire [24:0] G1, P1; 
	wire [24:0] GG;
		
	assign GG[0] = G0[0];	//GG[0] = G_0:0 = G0[0] 
	
	//////////////////////////////////
	
	G_Cell G_U1(.G0(G0[0]), .G1(G0[1]), .P1(P0[1]), .GG(GG[1]));
	
		
	/////////////////////////////
		
	genvar i;
	generate
		for(i=2 ; i<=24 ; i=i+1) begin: loop_KS1
			B_Cell B_U1(.G0(G0[i-1]), .G1(G0[i]), .P0(P0[i-1]), .P1(P0[i]), .PP(P1[i]), .GG(G1[i]));
		end
	endgenerate
	
	//////////////////////////////////////////
	
	assign G1[0] = G0[0];
	assign G1[1] = GG[1];
	
	always@(posedge clock, negedge resetn) begin
		if(!resetn) begin
			out_sign <= 0;
			out_G1 <= 0;
			out_P1 <= 0;
			out_P0 <= 0;
			out_GG <= 0;
		end
		else begin	
			out_sign <= in_sign;
			out_G1 <= G1;
			out_P1 <= P1;
			out_P0 <= P0;
			out_GG <= GG;
		end
	end	
	



endmodule





