`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    22:32:19 12/16/2022 
// Design Name: 
// Module Name:    step3_status 
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
module step3_status(clock, resetn, in_out_sign, in_ex_add_out, in_sig_mul_out, out_out_sign, out_ex_add_out, out_sig_mul_out);
	input clock, resetn;
	
	input in_out_sign;
	input [7:0] in_ex_add_out;
	input [21:0] in_sig_mul_out;
	
	output reg out_out_sign;
	output reg [7:0] out_ex_add_out;
	output reg [21:0] out_sig_mul_out;
	
	always@(posedge clock, negedge resetn) begin
		if(!resetn) begin
			out_out_sign <=0;
			out_ex_add_out <= 0;
			out_sig_mul_out <= 0;
		end
		else begin	
			out_out_sign <= in_out_sign;
			out_ex_add_out <= in_ex_add_out;
			out_sig_mul_out <= in_sig_mul_out;
		end
	end

endmodule 