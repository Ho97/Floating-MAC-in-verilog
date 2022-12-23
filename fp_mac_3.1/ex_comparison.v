`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    22:42:05 12/16/2022 
// Design Name: 
// Module Name:    ex_comparison 
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
module ex_comparison(ex_A, ex_B, ex_compare, ex_diff);
	
	input [7:0] ex_A, ex_B;
	output ex_compare;
	output [7:0] ex_diff;
	
	assign ex_compare = (ex_A > ex_B) ? 0 : 1;
	//ex_A�� �� ũ�� 0, ex_B�� �� ũ�� 1  
	//ex ������ 1
	
	wire [7:0] bigger  = (ex_compare) ? ex_B : ex_A;
	wire [7:0] smaller = (ex_compare) ? ex_A : ex_B;

	//unsigned 8bit subtraction
	assign ex_diff = bigger - smaller;	

endmodule 