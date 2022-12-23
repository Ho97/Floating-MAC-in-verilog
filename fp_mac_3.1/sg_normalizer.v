`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    22:33:43 12/16/2022 
// Design Name: 
// Module Name:    sg_normalizer 
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
module sg_normalizer(clock, resetn, in_ex, in_mul_out_sig, in_count, out_ex, sig_nor_out);
		input clock, resetn;
		
		input [7:0] in_ex;
		input [21:0] in_mul_out_sig;
		input [4:0] in_count;
		
		output reg [7:0] out_ex;
		output reg [23:0] sig_nor_out;
		
		wire [21:0] temp_sig = in_mul_out_sig << (21-in_count);
		
		always@(posedge clock, negedge resetn) begin
		if(!resetn) begin
			out_ex <= 0;
			sig_nor_out <=0;
		end
		else begin
			out_ex <= in_ex + in_count - 20;
			sig_nor_out <= {temp_sig, 2'b00};
		end
	end
		
		

endmodule 