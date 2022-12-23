module step5_adder_status(clock, resetn, in_current_sign, out_sign);
	input clock,resetn;
	
	input in_current_sign;
	
	output reg out_sign;
	
	always@(posedge clock, negedge resetn) begin
		if(!resetn) begin
			out_sign <= 0;
		end
		else begin
			out_sign <= in_current_sign;
		end
	end

endmodule 
