module step3_adder_status(clock, resetn, in_adder_out, in_ov_sign, in_adder_out_sign, in_sign_in1, in_sign_in2, in_current_ex, out_adder_out, out_ov_sign, out_adder_out_sign, out_current_ex);
	input clock,resetn;
	
	input [23:0] in_adder_out;
	input in_ov_sign;
	input in_adder_out_sign;
	input in_sign_in1, in_sign_in2;
	input [7:0] in_current_ex;
		
	output reg [23:0] out_adder_out;
	output reg out_ov_sign;
	output reg out_adder_out_sign;
	output reg [7:0] out_current_ex;
	
	always@(posedge clock, negedge resetn) begin
		if(!resetn) begin
			out_adder_out	<= 0;
			out_ov_sign 	<= 0;
			out_adder_out_sign	<= 0;
			out_current_ex <= 0;
		end
		else begin
			out_adder_out	<= in_adder_out;
			out_ov_sign 	<= (in_sign_in1 != in_sign_in2) ? 0 : in_ov_sign;
			out_adder_out_sign	<= in_adder_out_sign;
			out_current_ex <= in_current_ex;
		end
	end
endmodule

