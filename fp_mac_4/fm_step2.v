`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:24:44 12/22/2022 
// Design Name: 
// Module Name:    fm_step2 
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
module fm_step2(CLK, RESETn, in_ex, in_sign, temp_p_r1_2, temp_p_r1_3, temp_p_r1_4, temp_p_r1_5, temp_p_r1_6, temp_p_r1_7, temp_p_r1_8, temp_p_r1_9, temp_p_r1_10, temp_s_r1, out_ex, out_sign, temp_p_r9, temp_s_r9);
	input CLK, RESETn;
	input [7:0] in_ex;
	input in_sign;
	
	input [21:0] temp_p_r1_2;
	input [21:0] temp_p_r1_3;
	input [21:0] temp_p_r1_4;
	input [21:0] temp_p_r1_5;
	input [21:0] temp_p_r1_6;
	input [21:0] temp_p_r1_7;
	input [21:0] temp_p_r1_8;
	input [21:0] temp_p_r1_9;
	input [21:0] temp_p_r1_10;
	
	input [21:0] temp_s_r1;
	
	output reg [7:0] out_ex;
	output reg out_sign;
	output reg [21:0] temp_p_r9;
	output reg [21:0] temp_s_r9;
	
	reg [7:0] temp_ex[9:3];
	reg temp_sign[9:3];

	//array multiplier///////////////////////////////////////////////////
	reg [21:0] temp_p[9:3][10:3];
	reg [21:0] temp_s[9:2];

	wire [22:0] carry[9:2];
	wire [21:0] sum[9:2];
	
	genvar i;
	generate
		for (i=2 ; i<10 ; i=i+1) begin: c_gen
			assign carry[i][0] = 1'b0;
		end
	endgenerate
	
	genvar m;
	generate
		for (m=0 ; m<22 ; m=m+1) begin: am_row2
			full_adder fm_s2_am21(.x(temp_p_r1_2[m]), .y(temp_s_r1[m]), .ci(carry[2][m]), .co(carry[2][m+1]), .s(sum[2][m]));
		end
	endgenerate
		
	genvar r,c;
	generate
		for (r=3 ; r<10; r=r+1)begin: am_row3_9
			for (c=0 ; c<22 ; c=c+1) begin: am_col
				full_adder fm_s2_am2(.x(temp_p[r][r][c]), .y(temp_s[r-1][c]), .ci(carry[r][c]), .co(carry[r][c+1]), .s(sum[r][c]));
			end
		end
	endgenerate
		
	
	//temporal registers
	integer k, l;
	always@(posedge CLK, negedge RESETn)begin
		if(!RESETn) begin
			for (k=2 ; k<10 ; k=k+1)begin 
				temp_ex[k] <= 0;
				temp_sign[k] <= 0;
				temp_s[k] <= 0;
				for(l=2 ; l<10 ; l=l+1) begin
					temp_p[k][l] <= 22'b0;
				end	
			end
		end
		
		
		
		else begin
			temp_ex[3] <= in_ex;
			temp_sign[3] <= in_sign;
			for (k=4 ; k<10 ; k=k+1) begin
				temp_ex[k] <= temp_ex[k-1];
				temp_sign[k] <= temp_sign[k-1];
			end
			
			for (k=2 ; k<10 ; k=k+1) begin	
				temp_s[k] <= sum[k];
			end
			
			
			temp_p[3][3] <= temp_p_r1_3;
			temp_p[3][4] <= temp_p_r1_4;
			temp_p[3][5] <= temp_p_r1_5;
			temp_p[3][6] <= temp_p_r1_6;
			temp_p[3][7] <= temp_p_r1_7;
			temp_p[3][8] <= temp_p_r1_8;
			temp_p[3][9] <= temp_p_r1_9;
			temp_p[3][10] <= temp_p_r1_10;
			
			
			for (k=4 ; k<10 ; k=k+1) begin
				for (l=4 ; l<11 ; l=l+1) begin
					temp_p[k][l] <= temp_p[k-1][l];
				end
			end
		end
	end
	
	
	//final output
	always@(posedge CLK, negedge RESETn)begin
		if(!RESETn) begin
			out_ex <= 0;
			out_sign <= 0;
			temp_p_r9 <= 22'b0;
			temp_s_r9 <= 22'b0;
		
		end
		else begin
			out_ex <= temp_ex[9];
			out_sign <= temp_sign[9];
			temp_p_r9 <= temp_p[9][10];
			temp_s_r9 <= sum[9];
	
		end
	end

endmodule

