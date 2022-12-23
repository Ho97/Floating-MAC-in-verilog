module fr_shifter(clock, resetn, A, B, comp, diff, out_in1, out_in2);
	input clock, resetn;

	input [23:0] A, B;
	input	[7:0] diff;
	input comp;
	
	output reg[23:0] out_in1, out_in2;
	//in1은 shifr right 하는 놈 (exponent 작은 애)
	//in2는 그냥 그대로(exponent 큰 애)
	
	wire [23:0] in1, in2;
	
	assign in2 = (comp) ? B : A;
	assign in1 = (comp) ? A >> diff : B >> diff;
	
	always@(posedge clock, negedge resetn) begin
		if(!resetn) begin
			out_in1 <= 0;
			out_in2 <= 0;
		end
		else begin
			out_in1 <= in1;
			out_in2 <= in2;
		end
	end
					
endmodule 
