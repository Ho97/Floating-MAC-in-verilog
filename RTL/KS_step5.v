module KS_step5(clock, resetn, G4, P4, P0, in_GG, in_sign, out_P0, out_GG, out_sign);
    input clock, resetn;
	 
	 input [24:0] G4, P4, P0;
	 input [24:0] in_GG;
	 input in_sign;
	 
	 output reg [24:0] out_P0, out_GG;
	 output reg out_sign;
	 
	 wire [24:0] GG;
	 
	 assign GG[15:0] = in_GG[15:0];
	 
	 ////////////////////////////////
	
	 genvar i;
	 generate
	  	 for(i=16 ; i<=23 ; i=i+1) begin: loop_KS5_G
			 G_Cell G_U5(.G0(G4[i-8]), .G1(G4[i]), .P1(P4[i]), .GG(GG[i]));
		 end
	 endgenerate
		
	 G_Cell G_U5(.G0(G4[8]), .G1(G4[24]), .P1(P4[24]), .GG(GG[24]));
	 //				G_8:0			G_24:9		P_24:9			G_24:0
	 
	 always@(posedge clock, negedge resetn) begin
		if(!resetn) begin
			out_sign <= 0;
			out_P0 <= 0;
			out_GG <= 0;
		end
		else begin	
			out_sign <= in_sign;
			out_P0 <= P0;
			out_GG <= GG;
		end
	end	
	 
	 


endmodule
