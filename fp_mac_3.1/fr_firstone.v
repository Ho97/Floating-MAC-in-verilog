`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    22:44:59 12/16/2022 
// Design Name: 
// Module Name:    fr_firstone 
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
module fr_firstone(clock, resetn, nor_input, count);
	input clock, resetn;
	
	input [23:0] nor_input;
	
	output reg [7:0] count;

	always@(posedge clock, negedge resetn) begin
		if(!resetn)	count = 23;
		else if (nor_input[23]==1) count = 23;
		else if (nor_input[22]==1) count = 22;
		else if (nor_input[21]==1) count = 21;
		else if (nor_input[20]==1) count = 20;
		else if (nor_input[19]==1) count = 19;
		else if (nor_input[18]==1) count = 18;
		else if (nor_input[17]==1) count = 17;
		else if (nor_input[16]==1) count = 16;
		else if (nor_input[15]==1) count = 15;
		else if (nor_input[14]==1) count = 14;
		else if (nor_input[13]==1) count = 13;
		else if (nor_input[12]==1) count = 12;
		else if (nor_input[11]==1) count = 11;
		else if (nor_input[10]==1) count = 10;
		else if (nor_input[9]==1) count = 9;
		else if (nor_input[8]==1) count = 8;
		else if (nor_input[7]==1) count = 7;
		else if (nor_input[6]==1) count = 6;
		else if (nor_input[5]==1) count = 5;
		else if (nor_input[4]==1) count = 4;
		else if (nor_input[3]==1) count = 3;
		else if (nor_input[2]==1) count = 2;
		else if (nor_input[1]==1) count = 1;
		else if (nor_input[0]==1) count = 0;
		else count = 23;
	end

endmodule
