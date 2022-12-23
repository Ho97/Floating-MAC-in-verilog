`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    18:19:47 12/23/2022 
// Design Name: 
// Module Name:    mac_step1 
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
module mac_step1(CLK, RESETn, A, B, C, mul_sign, mul_ex, out_C, s_r4, p_r4_5, p_r4_6, p_r4_7, p_r4_8, p_r4_9, p_r4_10);
	input CLK, RESETn;
	input [15:0] A, B;
	input [31:0] C;
	
	output reg mul_sign;
	output reg [7:0] mul_ex;
	output reg [31:0] out_C;
	
	output reg [21:0] s_r4;
	output reg [21:0] p_r4_5, p_r4_6, p_r4_7, p_r4_8, p_r4_9, p_r4_10;
	
	/////////////////////////////////
	
	wire s_A = A[15];							//sign of A
	wire [4:0] ex_A = A[14:10];			//exponent of A
	wire [10:0] sg_A = {1'b1, A[9:0]};	//significand of A
	
	wire s_B = B[15];							//sign of B
	wire [4:0] ex_B = B[14:10];			//exponent of B
	wire [10:0] sg_B = {1'b1, B[9:0]};	//significand of B
	
	//exponent addition////////////////////////////
	wire [7:0] ex_addition = ex_A + ex_B + 97;
	//@-127 = (ex_A-15) + (ex_B - 15)
	
	
	//sign_determine//////////////////////
	wire sign_determine = (s_A == s_B) ? 0 :1;
	//equal sign - positive output=0, differnet sing - negetive output=1
	
	//array mulriplier //////////////
	
	wire [21:0] partials[10:0];
	wire [21:0] sum[4:1];
	wire [22:0] carry[4:1];
	
	//partials generate
	genvar i;
	generate
		for (i=0 ; i<11 ; i=i+1) begin: gen_p
			assign partials[i] = {sg_A&{11{sg_B[i]}}} << i;
		end
	endgenerate
	
	//generate carry
	genvar j;
	generate
		for (j=1 ; j<5 ; j=j+1) begin: gen_c_14
			assign carry[j][0] = 1'b0;
		end
	endgenerate
	
	//first row	
	genvar k;
	generate
		for (k=0 ; k<22 ; k=k+1) begin: am_row1
			full_adder am1(.x(partials[1][k]), .y(partials[0][k]), .ci(carry[1][k]), .co(carry[1][k+1]), .s(sum[1][k]));	
		end
	endgenerate
	
	//row 2 to 4
	genvar r, c;
	generate
		for(r=2 ; r<5 ; r=r+1) begin:psum24_row
			for (c=0 ; c<22 ; c=c+1) begin: psum24_col
				full_adder am24(.x(partials[r][c]), .y(sum[r-1][c]), .ci(carry[r][c]), .co(carry[r][c+1]), .s(sum[r][c]));	
			end
		end
	endgenerate
	
	

	//////////////////////////////////
	
	always@(posedge CLK, negedge RESETn)begin
		if(!RESETn)begin
			mul_sign <= 0;
			mul_ex <= 0;
			out_C <= 0;
			s_r4 <= 0;
			p_r4_5 <=0;
			p_r4_6 <=0;
			p_r4_7 <=0;
			p_r4_8 <=0;
			p_r4_9 <=0;
			p_r4_10 <=0;
		end
		else begin
			mul_sign <= sign_determine;
			mul_ex <= ex_addition;
			out_C <= C;
			s_r4 <= sum[4];
			p_r4_5 <= partials[5];
			p_r4_6 <= partials[6];
			p_r4_7 <= partials[7];
			p_r4_8 <= partials[8];
			p_r4_9 <= partials[9];
			p_r4_10 <= partials[10];
		end
	end
endmodule


///////////////////////////////////////////////

module full_adder(x,y,ci,co,s);
	input x, y, ci;
	output co, s;
	
	wire w1, w2, w3;
	xor(w1, x, y);
	xor(s, w1, ci);
	and(w2, w1, ci);
	and(w3, x, y);
	or(co, w3, w2);

endmodule



