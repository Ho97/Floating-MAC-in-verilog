`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    22:32:39 12/16/2022 
// Design Name: 
// Module Name:    sg_firstone 
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
module sg_firstone(clock, resetn, in_sig_mul_out, out_count);
	input clock, resetn;
	
	input [21:0] in_sig_mul_out;
	
	output reg [4:0] out_count;
	
	always@(posedge clock, negedge resetn) begin
		if(!resetn)	out_count = 21;
		else if (in_sig_mul_out[21]==1) out_count = 21;
		else if (in_sig_mul_out[20]==1) out_count = 20;
		else if (in_sig_mul_out[19]==1) out_count = 19;
		else if (in_sig_mul_out[18]==1) out_count = 18;
		else if (in_sig_mul_out[17]==1) out_count = 17;
		else if (in_sig_mul_out[16]==1) out_count = 16;
		else if (in_sig_mul_out[15]==1) out_count = 15;
		else if (in_sig_mul_out[14]==1) out_count = 14;
		else if (in_sig_mul_out[13]==1) out_count = 13;
		else if (in_sig_mul_out[12]==1) out_count = 12;
		else if (in_sig_mul_out[11]==1) out_count = 11;
		else if (in_sig_mul_out[10]==1) out_count = 10;
		else if (in_sig_mul_out[9]==1) out_count = 9;
		else if (in_sig_mul_out[8]==1) out_count = 8;
		else if (in_sig_mul_out[7]==1) out_count = 7;
		else if (in_sig_mul_out[6]==1) out_count = 6;
		else if (in_sig_mul_out[5]==1) out_count = 5;
		else if (in_sig_mul_out[4]==1) out_count = 4;
		else if (in_sig_mul_out[3]==1) out_count = 3;
		else if (in_sig_mul_out[2]==1) out_count = 2;
		else if (in_sig_mul_out[1]==1) out_count = 1;
		else if (in_sig_mul_out[0]==1) out_count = 0;
		else out_count = 21;
	end


endmodule 