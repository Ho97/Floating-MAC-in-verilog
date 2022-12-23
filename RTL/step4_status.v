module step4_status(clock, resetn, in_out_sign, out_out_sign);
	input clock, resetn;
	
	input in_out_sign;
	
	output reg out_out_sign;
	
	always@(posedge clock, negedge resetn) begin
		if(!resetn) begin
			out_out_sign <=0;
		end
		else begin	
			out_out_sign <= in_out_sign;
		end
	end	

endmodule

