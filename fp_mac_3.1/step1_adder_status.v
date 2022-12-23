`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    22:42:26 12/16/2022 
// Design Name: 
// Module Name:    step1_adder_status 
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
module step1_adder_status(clock, resetn, s_A, s_B, ex_A, ex_B, ex_compare, sign_in1, sign_in2, current_ex);
	input clock, resetn;
	
	input s_A, s_B;
	input [7:0] ex_A, ex_B;
	input ex_compare;
	
	output reg sign_in1, sign_in2;
	output reg [7:0] current_ex;
	
	
	always@(posedge clock, negedge resetn) begin
		if(!resetn) begin
			sign_in1 <=0;
			sign_in2 <=0;
			current_ex <=0;
		end
		else begin	
			sign_in1 <= (ex_compare) ? s_A : s_B;
			sign_in2 <= (ex_compare) ? s_B : s_A;
			current_ex <= (ex_compare) ? ex_B : ex_A;
		end
	end	

endmodule 