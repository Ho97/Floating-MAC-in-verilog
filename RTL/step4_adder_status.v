module step4_adder_status(clock, resetn, in_current_sign, in_ov_sign, out_sign, out_ov_sign);
	input clock,resetn;
	
	input in_current_sign;
	input in_ov_sign;
	
	output reg out_sign;
	output reg out_ov_sign;
	
	always@(posedge clock, negedge resetn) begin
		if(!resetn) begin
			out_sign <= 0;
			out_ov_sign <= 0;
		end
		else begin
			out_sign <= in_current_sign;
			out_ov_sign <=  in_ov_sign;
		end
	end

endmodule 
