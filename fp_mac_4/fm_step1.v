`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:32:09 12/22/2022 
// Design Name: 
// Module Name:    fm_step1 
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

//float multiplier step1 - ex_add, out_sign
// + array_multiplier - get partial & 1st line summation

module fm_step1(CLK, RESETn, A, B, ex_add, out_sign, temp_p_r1_2, temp_p_r1_3, temp_p_r1_4, temp_p_r1_5, temp_p_r1_6, temp_p_r1_7, temp_p_r1_8, temp_p_r1_9, temp_p_r1_10, temp_s_r1);
	input CLK, RESETn;
	input [15:0] A, B;
	
	output reg [7:0] ex_add;
	output reg out_sign;
	
	output reg [21:0] temp_p_r1_2;
	output reg [21:0] temp_p_r1_3;
	output reg [21:0] temp_p_r1_4;
	output reg [21:0] temp_p_r1_5;
	output reg [21:0] temp_p_r1_6;
	output reg [21:0] temp_p_r1_7;
	output reg [21:0] temp_p_r1_8;
	output reg [21:0] temp_p_r1_9;
	output reg [21:0] temp_p_r1_10;
	
	output reg [21:0] temp_s_r1;
	
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
	
	
	//array mulriplier - first row//////////////
	wire [21:0] partials[10:0];
	wire [21:0] sum_r1;
	wire [22:0] carry_r1;
	
	//partials generate
	genvar i;
	generate
		for (i=0 ; i<11 ; i=i+1) begin
			assign partials[i] = {sg_A&{11{sg_B[i]}}} << i;
		end
	endgenerate
	
	assign carry_r1[0] = 1'b0;
	//assign sum_r1[0] = partials[0];
	
	genvar c;
	generate
		for (c=0 ; c<22 ; c=c+1) begin: am_row1
			full_adder fm_s1_am1(.x(partials[1][c]), .y(partials[0][c]), .ci(carry_r1[c]), .co(carry_r1[c+1]), .s(sum_r1[c]));	
		end
	endgenerate
	
	

	always@(posedge CLK, negedge RESETn)begin
		if(!RESETn)begin
			out_sign <= 0;
			ex_add <= 0;
			
			temp_p_r1_2 <= 0;
			temp_p_r1_3 <= 0;
			temp_p_r1_4 <= 0;
			temp_p_r1_5 <= 0;
			temp_p_r1_6 <= 0;
			temp_p_r1_7 <= 0;
			temp_p_r1_8 <= 0;
			temp_p_r1_9 <= 0;
			temp_p_r1_10 <= 0;
			temp_s_r1 <= 22'b0;
		end
		
		else begin
			out_sign <= sign_determine;
			ex_add <= ex_addition;
			
			temp_p_r1_2 <= partials[2];
			temp_p_r1_3 <= partials[3];
			temp_p_r1_4 <= partials[4];
			temp_p_r1_5 <= partials[5];
			temp_p_r1_6 <= partials[6];
			temp_p_r1_7 <= partials[7];
			temp_p_r1_8 <= partials[8];
			temp_p_r1_9 <= partials[9];
			temp_p_r1_10 <= partials[10];
			temp_s_r1 <= sum_r1;
		end
	end
	
endmodule

/////////////////////////////////////////////
	
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









