`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    19:43:48 12/22/2022 
// Design Name: 
// Module Name:    fm_step3 
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
module fm_step3(CLK, RESETn, in_ex, in_sign, temp_p_r9, temp_s_r9, out_ex, out_sign, mul_out, count);
    input CLK, RESETn;
	 
	 input [7:0] in_ex;
	 input in_sign;
	 
	 input [21:0] temp_p_r9;
	 input [21:0] temp_s_r9;
	 
	 output reg [7:0] out_ex;
	 output reg out_sign;
	 
	 output reg [21:0] mul_out;
	 output reg [4:0] count;
	 
	 ///Array multiplier - Summation - 10th line///////////////////////////////////////////////
	 	 
	 wire [22:0] carry;
	 assign carry[0] = 1'b0;
	 
	 wire [21:0] sum;
	 
	 genvar c;
	 generate
		 for (c=0 ; c<22 ; c=c+1) begin: am_row1
			full_adder fm_s3_am10(.x(temp_p_r9[c]), .y(temp_s_r9[c]), .ci(carry[c]), .co(carry[c+1]), .s(sum[c]));	
		 end
	 endgenerate
	 
	 
	 ////Finding first one of mul_out/////////////////////////////////////////////
	 
	always@(posedge CLK, negedge RESETn) begin
		if(!RESETn)	count <= 21;
		else if (sum[21]==1) count <= 21;
		else if (sum[20]==1) count <= 20;
		else if (sum[19]==1) count <= 19;
		else if (sum[18]==1) count <= 18;
		else if (sum[17]==1) count <= 17;
		else if (sum[16]==1) count <= 16;
		else if (sum[15]==1) count <= 15;
		else if (sum[14]==1) count <= 14;
		else if (sum[13]==1) count <= 13;
		else if (sum[12]==1) count <= 12;
		else if (sum[11]==1) count <= 11;
		else if (sum[10]==1) count <= 10;
		else if (sum[9]==1) count <= 9;
		else if (sum[8]==1) count <= 8;
		else if (sum[7]==1) count <= 7;
		else if (sum[6]==1) count <= 6;
		else if (sum[5]==1) count <= 5;
		else if (sum[4]==1) count <= 4;
		else if (sum[3]==1) count <= 3;
		else if (sum[2]==1) count <= 2;
		else if (sum[1]==1) count <= 1;
		else if (sum[0]==1) count <= 0;
		else count <= 21;
	end	 
	 
	 
	 
	 
	 //////////////////////////////////////////////////////////////
	 
	always@(posedge CLK, negedge RESETn)begin
		if(!RESETn) begin
			out_ex <= 0;
			out_sign <= 0;
			mul_out <= 0;
		end
		else begin
			out_ex <= in_ex;
			out_sign <= in_sign;
			mul_out <= sum;
		end
	end
			
	 
	 


endmodule



