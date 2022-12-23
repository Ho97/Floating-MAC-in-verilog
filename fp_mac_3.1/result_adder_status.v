`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    22:47:27 12/16/2022 
// Design Name: 
// Module Name:    result_adder_status 
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
module result_adder_status(clock, resetn, sign, exponent, significand, fp_adder_output);
	input clock,resetn;
	
	input sign;
	input [7:0] exponent;
	input [23:0] significand;
	
	output reg [31:0] fp_adder_output;

	always@(posedge clock, negedge resetn) begin
		if(!resetn) begin
			fp_adder_output <= 0;
		end
		else begin
			fp_adder_output <= {sign, exponent, significand[22:0]};
		end
	end

endmodule 