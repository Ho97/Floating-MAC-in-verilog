`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    22:30:04 12/16/2022 
// Design Name: 
// Module Name:    ex_adder 
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
module ex_adder(clock, resetn, ex_A, ex_B, out_ex);
	input clock, resetn;
	
	input [4:0] ex_A, ex_B;
	
	output reg [7:0] out_ex;
	
	always@(posedge clock, negedge resetn) begin
		if(!resetn) begin
			out_ex <= 0;
		end
		else begin
			out_ex <= ex_A + ex_B + 97;
			//@-127 = (ex_A - 15) + (ex_B - 15)
		end
	end
endmodule
