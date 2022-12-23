`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    18:46:06 12/23/2022 
// Design Name: 
// Module Name:    mac_step2 
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
module mac_step2(CLK, RESETn, in_sign, in_ex, in_C, s_r4, p_r4_5, p_r4_6, p_r4_7, p_r4_8, p_r4_9, p_r4_10, out_sign, out_ex, out_C, mul_out, count);
	input CLK, RESETn;
	input in_sign;
	input [7:0] in_ex;
	input [31:0] in_C;
	
	input [21:0] s_r4, p_r4_5, p_r4_6, p_r4_7, p_r4_8, p_r4_9, p_r4_10;
	
	output reg out_sign;
	output reg [7:0] out_ex;
	output reg [31:0] out_C;
	
	output reg [21:0] mul_out;
	output reg [4:0] count;
	
	///////////////////////////////////
	
	//get partials
	wire [21:0] partials[10:5];
	assign partials[5] = p_r4_5;
	assign partials[6] = p_r4_6;
	assign partials[7] = p_r4_7;
	assign partials[8] = p_r4_8;
	assign partials[9] = p_r4_9;
	assign partials[10] = p_r4_10;
	
	//get summation
	wire [21:0] sum[10:4];
	assign sum[4] = s_r4;
	
	
	
	
	
	
	//generate carry
	wire [22:0] carry[10:5];
	
	genvar j;
	generate
		for (j=5 ; j<11 ; j=j+1) begin: gen_c_510
			assign carry[j][0] = 1'b0;
		end
	endgenerate
	

	//row 5 to 10
	genvar r, c;
	generate
		for(r=5 ; r<11 ; r=r+1) begin:psum510_row
			for (c=0 ; c<22 ; c=c+1) begin: psum510_col
				full_adder am24(.x(partials[r][c]), .y(sum[r-1][c]), .ci(carry[r][c]), .co(carry[r][c+1]), .s(sum[r][c]));	
			end
		end
	endgenerate
	
	
	
	 ////Finding first one of mul_out/////////////////////////////////////////////
	 
	always@(posedge CLK, negedge RESETn) begin
		if(!RESETn)	count <= 21;
		else if (sum[10][21]==1) count <= 21;
		else if (sum[10][20]==1) count <= 20;
		else if (sum[10][19]==1) count <= 19;
		else if (sum[10][18]==1) count <= 18;
		else if (sum[10][17]==1) count <= 17;
		else if (sum[10][16]==1) count <= 16;
		else if (sum[10][15]==1) count <= 15;
		else if (sum[10][14]==1) count <= 14;
		else if (sum[10][13]==1) count <= 13;
		else if (sum[10][12]==1) count <= 12;
		else if (sum[10][11]==1) count <= 11;
		else if (sum[10][10]==1) count <= 10;
		else if (sum[10][9]==1) count <= 9;
		else if (sum[10][8]==1) count <= 8;
		else if (sum[10][7]==1) count <= 7;
		else if (sum[10][6]==1) count <= 6;
		else if (sum[10][5]==1) count <= 5;
		else if (sum[10][4]==1) count <= 4;
		else if (sum[10][3]==1) count <= 3;
		else if (sum[10][2]==1) count <= 2;
		else if (sum[10][1]==1) count <= 1;
		else if (sum[10][0]==1) count <= 0;
		else count <= 21;
	end	
	
	
	
	
	
	
	
	//////////////////////////////////////
	always@(posedge CLK, negedge RESETn)begin
		if(!RESETn)begin
			out_sign <= 0;
			out_ex <= 0;
			out_C <= 0;
			mul_out <= 0;
		end
		else begin
			out_sign <= in_sign;
			out_ex <= in_ex;
			out_C <= in_C;
			mul_out <= sum[10];
		end
	end
endmodule











