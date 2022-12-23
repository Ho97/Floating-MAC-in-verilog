module step1_status(clock, resetn, in_significand_A, in_significand_B, out_significand_A, out_significand_B);
	input clock, resetn;
	
	input  [10:0] in_significand_A, in_significand_B;
	
	output reg [10:0] out_significand_A, out_significand_B;
	
	always@(posedge clock, negedge resetn) begin
		if(!resetn) begin
			out_significand_A <= 0;
			out_significand_B <= 0;
		end
		else begin	
			out_significand_A <= in_significand_A;
			out_significand_B <= in_significand_B;
		end
	end	

endmodule 
