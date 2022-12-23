module result_adder_status(clock, resetn, sign, exponent, significand, fp_adder_output);
	input clock,resetn;
	
	input sign;
	input [7:0] exponent;
	input [23:0] significand;
	
	output reg [31:0] fp_adder_output;

	always@(posedge clock, negedge resetn) begin
		if(!resetn) begin
			fp_adder_output <= 0;
		end
		else begin
			fp_adder_output <= {sign, exponent, significand[22:0]};
		end
	end

endmodule 
