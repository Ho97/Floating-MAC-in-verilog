`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:27:57 12/18/2022 
// Design Name: 
// Module Name:    fr_adder_prepare 
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
module fr_adder_prepare(clock, resetn, input1, input2, in_out_sign, out_out_sign, G0, P0);
	input clock, resetn;
	
	input in_out_sign;
	input [23:0] input1, input2;
	
	output reg out_out_sign;
	output reg [24:0] G0, P0;
	
	wire [24:0] G;
	assign G[24:1]	= input1 & input2;
	assign G[0] = 0; //Cin ¾øÀ½
	
	wire [24:0] P;
	assign P[24:1] = input1 ^ input2;
	assign P[0] = 0;
	

	always@(posedge clock, negedge resetn) begin
		if(!resetn) begin
			out_out_sign <= 0;
			G0 <= 0;
			P0 <= 0;
		end
		else begin
			out_out_sign <= in_out_sign;
			G0 <= G;
			P0 <= P;
		end
	end

endmodule
