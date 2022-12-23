`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:02:10 12/22/2022 
// Design Name: 
// Module Name:    fm_step4 
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
module fm_step4(CLK, RESETn, ex_added, out_sign, mul_out, count, result);
	input CLK, RESETn;
	
	input [7:0] ex_added;
	input out_sign;
	input [21:0] mul_out;
	input [4:0] count;
	
	output reg [31:0] result;
	
	///Normalize////////////////////////////////////
	
	wire [7:0] out_exponent = ex_added + count -20;
		
	wire [23:0] out_significand = {{mul_out << (21-count)}, 2'b00};
	
	///Final output//////////////////////////////////////////
	
	wire [31:0] single_out = {out_sign, out_exponent, out_significand[22:0]};
	
	
	
	////////////////////////////////////////////
	
	always@(posedge CLK, negedge RESETn) begin
		if(!RESETn) begin
			result <= 0;
		end
		else begin
			result <= single_out;
		end
	end

endmodule


