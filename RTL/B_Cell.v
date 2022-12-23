
module B_Cell(G0, G1, P0, P1, PP, GG);
	input G0, G1, P0, P1;
	output GG, PP;
	
	assign GG = G1 | (P1 & G0);
	assign PP = P0 & P1;
endmodule
//B_Cell = G_k-1:l, G_i:k, P_k-1:l, P_i:k >> G_i:l, P_i:i
