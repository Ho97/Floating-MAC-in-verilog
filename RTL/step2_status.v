module step2_status(clock, resetn, in_ex_add_out, in_out_sign, out_ex_add_out, out_out_sign);
	input clock, resetn;
	
	input [7:0] in_ex_add_out;
	input in_out_sign;
	
	output [7:0] out_ex_add_out;
	output out_out_sign;
	
	parameter cycle = 10;
	
	wire [7:0] temp_ex[cycle:0];
	wire temp_sign[cycle:0];
	
	assign temp_ex[0] = in_ex_add_out;
	assign temp_sign[0] = in_out_sign;
	
	genvar i;
	generate
		for(i=0 ; i<cycle ; i=i+1) begin: loop_buf_mul
			temporary_box_mul TBM1(.clock(clock), .resetn(resetn), .in_sign(temp_sign[i]), .in_ex(temp_ex[i]), .out_sign(temp_sign[i+1]), .out_ex(temp_ex[i+1]));
		end
	endgenerate
	
	assign out_ex_add_out = temp_ex[cycle];
	assign out_out_sign = temp_sign[cycle];
	
endmodule 

///////////////////////////////

module temporary_box_mul(clock, resetn, in_sign, in_ex, out_sign, out_ex); //1 clock 동안 임시 저장
	input clock, resetn;
		
	input [7:0] in_ex;
	input in_sign;
	
	output reg [7:0] out_ex;
	output reg out_sign;
	
	always@(posedge clock, negedge resetn) begin
		if(!resetn) begin
			out_sign <= 0;
			out_ex <= 0;
		end
		else begin	
			out_sign <= in_sign;
			out_ex <= in_ex;
		end
	end

endmodule 
