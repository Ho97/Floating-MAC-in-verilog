`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    22:34:14 12/16/2022 
// Design Name: 
// Module Name:    result_status 
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
module result_status(clock, resetn, out_sign, out_exponent, out_significand, fp_mul_out);
	input clock,resetn;
	
	input out_sign;
	input [7:0] out_exponent;
	input [23:0] out_significand;
	
	output reg [31:0] fp_mul_out;

	always@(posedge clock, negedge resetn) begin
		if(!resetn) begin
			fp_mul_out <= 0;
		end
		else begin
			fp_mul_out <= {out_sign, out_exponent, out_significand[22:0]};
		end
	end

endmodule 
