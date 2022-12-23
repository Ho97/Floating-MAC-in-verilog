module KS_step2(clock, resetn, G1, P1, P0, in_GG, in_sign, out_G2, out_P2, out_P0, out_GG, out_sign);
	input clock, resetn;
	
	input [24:0] G1, P1, P0;	//G i:i-1 //P i:i-1
	input [24:0] in_GG;
	input in_sign;
	
	output reg [24:0] out_G2, out_P2; //G i:i-3 //P i:i-3
	output reg [24:0] out_P0;
	output reg [24:0] out_GG;
	output reg out_sign;
	
	wire [24:0] G2, P2; 
	wire [24:0] GG;
	
	assign GG[1:0] = in_GG[1:0];
	
	//////////////////////// 
	
	genvar i;
	generate
		for(i=2 ; i<=3 ; i=i+1) begin: loop_KS2_G
			G_Cell G_U2(.G0(G1[i-2]), .G1(G1[i]), .P1(P1[i]), .GG(GG[i]));
		end
	endgenerate
	
	/////////////////////////////
	
	genvar j;
	generate
		for(j=4 ; j<=24 ; j=j+1) begin: loop_KS2_B
			B_Cell B_U2(.G0(G1[j-2]), .G1(G1[j]), .P0(P1[j-2]), .P1(P1[j]), .PP(P2[j]), .GG(G2[j]));
		end
	endgenerate
	
	//////////////////////////////
	
	
	assign G2[3:0] = GG[3:0];

	
	always@(posedge clock, negedge resetn) begin
		if(!resetn) begin
			out_sign <= 0;
			out_G2 <= 0;
			out_P2 <= 0;
			out_GG <= 0;
			out_P0 <= 0;
		end
		else begin	
			out_sign <= in_sign;
			out_G2 <= G2;
			out_P2 <= P2;
			out_GG <= GG;
			out_P0 <= P0;
		end
	end	
	
	
	


endmodule
