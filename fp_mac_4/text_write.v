`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:31:55 12/22/2022 
// Design Name: 
// Module Name:    text_write 
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
module text_write(clock, resetn, in_result);
	input clock, resetn;
	input [31:0] in_result;
	
	integer text;
	
	always@(posedge clock, negedge resetn) begin
		if (!resetn) begin
			text = $fopen("output.txt","w");
		end
		else begin
			text = $fopen("output.txt","a");
	
			$fwriteb(text, in_result);
			$fwrite(text, "\n");

			$fclose(text);
		end
	end
endmodule 