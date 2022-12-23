`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    23:05:44 12/17/2022 
// Design Name: 
// Module Name:    G_Cell 
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
module G_Cell(G0, G1, P1, GG);
	input G0, G1, P1;
	output GG;
	
	assign GG = G1 | (P1 & G0);
endmodule
//G_Cell = G_k-1:l, G_i:k, P_i:k >> G_i:0