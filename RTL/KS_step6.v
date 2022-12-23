module KS_step6(clock, resetn, P0, GG, in_sign, Sum, Cout, out_sign);
	input clock, resetn;
	input [24:0] P0, GG;
	input in_sign;
	
	output reg [24:1] Sum;
	output reg Cout;
	output reg out_sign;
	
	wire [24:1] S;
	
	genvar i;
	generate
		for (i=1 ; i<=24 ; i=i+1) begin: KS6_loop
			assign S[i] = P0[i] ^ GG[i-1];
		end
	endgenerate
	
	

	always@(posedge clock, negedge resetn) begin
		if(!resetn) begin
			out_sign <= 0;
			Sum <= 0;
			Cout <= 0;
		end
		else begin
			out_sign <= in_sign;
			Sum <= S;
			Cout <= GG[24];
		end
	end	





endmodule
