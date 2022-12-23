module fr_adder_pre(clock, resetn, sign_in1, sign_in2, in1, in2, out_input1, out_input2, out_sign);
	input clock, resetn;
	
	input sign_in1, sign_in2;
	input [23:0] in1, in2;

	output reg out_sign;
	output reg [23:0] out_input1, out_input2;
	
	 
	// 양수+양수 or 음수+음수 >> fraction 덧셈 진행
	// 어차피 Sign이 양수 음수 구분하기 때문에 절대값만 더해줘도 된다.
			
	// 양수+음수 or 음수+양수 >> 크기 비교후 부호 결정 - 절대값 작은 애를 2's complement한 후 덧셈 진행 - overflow 무시한다.
	//sign=1 이면 음수, sign=0 이면 양수
	wire output_sign = (sign_in1 == sign_in2) ? sign_in1 : (in1 == in2) ?	0	: (in1 > in2) ?  sign_in1 : sign_in2;
										//sign 같으면	output부호그대로 		in1,in2같으면0		in1절대값 크면 in1 부호 따라서		in2 절대값크면 in2부호 따라서
		
	wire [23:0] input1 = (sign_in1 == sign_in2) ? in1 : (output_sign == sign_in1) ? in1 : ~in1+1;
	wire [23:0] input2 = (sign_in1 == sign_in2) ? in2 : (output_sign == sign_in2) ? in2 : ~in2+1;
							//				sign 같으면 그대로			다르면 절대값 작은 애만 2's complement

	

	always@(posedge clock, negedge resetn) begin
		if(!resetn) begin
			out_sign <= 0;
			out_input1 <= 0;
			out_input2 <= 0;
		end
		else begin
			out_sign <= output_sign;
			out_input1 <= input1;
			out_input2 <= input2;
		end
	end

endmodule
