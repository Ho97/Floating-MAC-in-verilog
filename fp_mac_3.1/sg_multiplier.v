`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    22:31:40 12/16/2022 
// Design Name: 
// Module Name:    sg_multiplier 
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
module sg_multiplier(clock, resetn, in_sg_A, in_sg_B, multiplier_out);
	input clock, resetn;
	
	input [10:0] in_sg_A, in_sg_B;
	
	output [21:0] multiplier_out;
	
	//bw = 11, Array multiplier (pipeline)
	
	wire [21:0] partials[10:0];
	
	wire [21:0] sum[10:0];
	wire [22:0] carry[10:0];
	
	reg [21:0] temp_s[10:0];
	reg [21:0] temp_p[10:0][10:0];
	
	genvar i;
	generate
		for (i=0 ; i<11 ; i=i+1) begin: mul_part
			assign partials[i] = {in_sg_A&{11{in_sg_B[i]}}} << i;
		end
	endgenerate
	
	genvar j;
	generate
		for (j=0 ; j<11 ; j=j+1) begin: mul_carry
			assign carry[j][0] = 1'b0;
		end
	endgenerate
	
	assign sum[0] = partials[0];
	
	genvar r, c;
	generate
		for (r=1;r<11;r=r+1) begin:psum_row
			for(c=0 ; c<22 ; c=c+1) begin: psum_col
				full_adder u0(.x(temp_p[r][r][c]), .y(temp_s[r-1][c]), .ci(carry[r][c]), .co(carry[r][c+1]), .s(sum[r][c]));
			end
		end
	endgenerate
	
	integer k,l;
	always@(posedge clock, negedge resetn) begin
		if(!resetn) begin
			//multiplier_out <=0;
			for(k=0 ; k<11 ; k=k+1) begin
				temp_s[k] <= {(21){1'b0}};
			end
		end
		else begin
			//multiplier_out <= sum[10];
			for(k=0 ; k<11 ; k=k+1) begin
				for(l=0 ; l<22 ; l=l+1) begin
					temp_s[k][l] <= sum[k][l];
				end
			end
			
			for(l=0 ; l<11 ; l=l+1) begin
				temp_p[1][l] <= partials[l];
			end
			
			for(k=2 ; k<11 ; k=k+1) begin
				for(l=0 ; l<11 ; l=l+1) begin
					temp_p[k][l] <= temp_p[k-1][l];
				end
			end
		end
	end
	assign multiplier_out = sum[10];
	
endmodule

	


/////////////////////////////////////////////
	
module full_adder(x,y,ci,co,s);
	input x, y, ci;
	output co, s;
	
	assign s = x^y^ci;
	assign co = (x&y)|(x&ci)|(y&ci);

endmodule 