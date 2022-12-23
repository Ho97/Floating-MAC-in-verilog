module G_Cell(G0, G1, P1, GG);
	input G0, G1, P1;
	output GG;
	
	assign GG = G1 | (P1 & G0);
endmodule
//G_Cell = G_k-1:l, G_i:k, P_i:k >> G_i:0
