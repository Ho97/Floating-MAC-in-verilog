`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    22:33:13 12/16/2022 
// Design Name: 
// Module Name:    step4_status 
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
module step4_status(clock, resetn, in_out_sign, out_out_sign);
	input clock, resetn;
	
	input in_out_sign;
	
	output reg out_out_sign;
	
	always@(posedge clock, negedge resetn) begin
		if(!resetn) begin
			out_out_sign <=0;
		end
		else begin	
			out_out_sign <= in_out_sign;
		end
	end	

endmodule
