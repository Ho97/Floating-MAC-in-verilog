module fr_normalize(clock, resetn, count, nor_input, nor_ov_sig, current_ex, nor_out_significand, nor_out_exponent);
	input clock, resetn;	
		
	input [7:0] count;	
	input [23:0] nor_input;
	input nor_ov_sig;
	input [7:0] current_ex;
	
	output reg [24:0] nor_out_significand;
	output reg [7:0] nor_out_exponent;

	always@(posedge clock, negedge resetn) begin
		if(!resetn) begin
			nor_out_significand <= 0;
			nor_out_exponent <=0;
		end
		else begin
			if (!nor_ov_sig) begin		//overflow=0 >> 바로 normalize
				nor_out_significand <= {{1'b0}, nor_input << (23-count)}; //1.######가 되도록 normalize
				nor_out_exponent <= current_ex - 23 + count;
			end
			else begin //overflow 발생
				nor_out_significand <= {1'b1, nor_input}; //overflow이면 첫 비트는 항상 1 
				nor_out_exponent <= current_ex + 1;	//overflow면 한자리 더 커진 거니까 exponent에 1 더해줌
			end		
		end
	end	
endmodule 


