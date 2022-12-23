`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    22:44:31 12/16/2022 
// Design Name: 
// Module Name:    step2_adder_status 
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
module step2_adder_status(clock, resetn, in_sign_in1, in_sign_in2, in_current_ex, out_sign_in1, out_sign_in2, out_current_ex);
	input clock, resetn;
	
	input in_sign_in1, in_sign_in2;
	input [7:0] in_current_ex;
	
	output out_sign_in1, out_sign_in2;
	output [7:0] out_current_ex;

	parameter cycle = 8;
	
	wire temp_sign1[cycle:0];
	wire temp_sign2[cycle:0];
	wire [7:0] temp_ex[cycle:0];	
	
	assign temp_sign1[0] = in_sign_in1;
	assign temp_sign2[0] = in_sign_in2;
	assign temp_ex[0] = in_current_ex;
	
	genvar i;
	generate
		for(i=0; i<cycle ; i=i+1) begin: loop_buf_add
			temporary_box_add TBA1(.clock(clock), .resetn(resetn), .in_sign1(temp_sign1[i]), .in_sign2(temp_sign2[i]), .in_ex(temp_ex[i]), .out_sign1(temp_sign1[i+1]), .out_sign2(temp_sign2[i+1]), .out_ex(temp_ex[i+1]));
		end
	endgenerate
	
	assign out_sign_in1 = temp_sign1[cycle];
	assign out_sign_in2 = temp_sign2[cycle];
	assign out_current_ex = temp_ex[cycle];

endmodule 


////////////////////////////////////////////////////

module temporary_box_add(clock, resetn, in_sign1, in_sign2, in_ex, out_sign1, out_sign2, out_ex); //1 clock 동안 임시 저장
	input clock, resetn;
	
	input in_sign1, in_sign2;
	input [7:0] in_ex;
	
	output reg out_sign1, out_sign2;
	output reg [7:0] out_ex;
	
	always@(posedge clock, negedge resetn) begin
		if(!resetn) begin
			out_sign1 <= 0;
			out_sign2 <= 0;
			out_ex <= 0;
		end
		else begin	
			out_sign1 <= in_sign1;
			out_sign2 <= in_sign2;
			out_ex <= in_ex;
		end
	end

endmodule 