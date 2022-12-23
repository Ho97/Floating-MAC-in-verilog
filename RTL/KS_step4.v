module KS_step4(clock, resetn, G3, P3, P0, in_GG, in_sign, out_G4, out_P4, out_P0, out_GG, out_sign);
	input clock, resetn;
	
	input [24:0] G3, P3, P0;	//G i:i-7 //P i:i-7
	input [24:0] in_GG;
	input in_sign;
	
	output reg [24:0] out_G4, out_P4, out_P0; //G i:i-15 //P i:i-15
	output reg [24:0] out_GG;
	output reg out_sign;
	
	wire [24:0] G4, P4; 
	wire [24:0] GG;
	
	assign GG[7:0] = in_GG[7:0];
	
	////////////////////////////
	
	genvar i;
	generate
		for(i=8 ; i<=15 ; i=i+1) begin: loop_KS4_G
			G_Cell G_U4(.G0(G3[i-8]), .G1(G3[i]), .P1(P3[i]), .GG(GG[i]));
		end
	endgenerate
		
	/////////////////////////////////	
	
	assign P4[23:0] = P3[23:0];
	
	B_Cell B_U4(.G0(G3[16]), .G1(G3[24]), .P0(P3[16]), .P1(P3[24]), .PP(P4[24]), .GG(G4[24]));
	//					G_16:9		G_24:17			P_16:9		G_24:17		P_24:9			G_24:9
	
	
	/////////////////////////////////
	
	assign G4[23:16] = G3[23:16];
	assign G4[15:0] = GG[15:0];
	

	
	always@(posedge clock, negedge resetn) begin
		if(!resetn) begin
			out_sign <= 0;
			out_G4 <= 0;
			out_P4 <= 0;
			out_P0 <= 0;
			out_GG <= 0;
		end
		else begin	
			out_sign <= in_sign;
			out_G4 <= G4;
			out_P4 <= P4;
			out_P0 <= P0;
			out_GG <= GG;
		end
	end	
	
	


endmodule
