module KS_step3(clock, resetn, G2, P2, P0, in_GG, in_sign, out_G3, out_P3, out_P0, out_GG, out_sign);
	input clock, resetn;
	
	input [24:0] G2, P2, P0;	//G i:i-1 //P i:i-1
	input [24:0] in_GG;
	input in_sign;
	
	output reg [24:0] out_G3, out_P3; //G i:i-3 //P i:i-3
	output reg [24:0] out_P0;
	output reg [24:0] out_GG;
	output reg out_sign;
	
	wire [24:0] G3, P3; 
	wire [24:0] GG;
	
	assign GG[3:0] = in_GG[3:0];
	
	//////////////////////////////
	
	genvar i;
	generate
		for(i=4 ; i<=7 ; i=i+1) begin: loop_KS3_G
			G_Cell G_U3(.G0(G2[i-4]), .G1(G2[i]), .P1(P2[i]), .GG(GG[i]));
		end
	endgenerate
	
	/////////////////////////////////	
	
	genvar j;
	generate
		for(j=8 ; j<=24 ; j=j+1) begin: loop_KS3_B
			B_Cell B_U3(.G0(G2[j-4]), .G1(G2[j]), .P0(P2[j-4]), .P1(P2[j]), .PP(P3[j]), .GG(G3[j]));
		end
	endgenerate
	
	///////////////////////////////////
	
	assign G3[7:0] = GG[7:0];
	
	always@(posedge clock, negedge resetn) begin
		if(!resetn) begin
			out_sign <= 0;
			out_G3 <= 0;
			out_P3 <= 0;
			out_P0 <= 0;
			out_GG <= 0;
		end
		else begin	
			out_sign <= in_sign;
			out_G3 <= G3;
			out_P3 <= P3;
			out_P0 <= P0;
			out_GG <= GG;
		end
	end	
	
	


endmodule
