module sign_determine(clock, resetn, s_A, s_B, out_sign);
	 input clock, resetn;
	
	 input s_A, s_B;
	 
	 output reg out_sign;
	 
	 always@(posedge clock, negedge resetn) begin
		if(!resetn) begin
			out_sign <= 0;
		end
		else begin
			out_sign <= (s_A == s_B) ? 0 : 1; 
		end
	end
endmodule 
