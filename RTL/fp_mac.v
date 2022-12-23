module fp_mac(CLK, RESETn, A, B, C, Y);
	input CLK, RESETn;
	
	input [15:0] A, B;	//new data
	input [31:0] C;		//data from previous MAC
	
	output [31:0] Y;
	
	wire [31:0] mul_out;
	wire [31:0] aged_C;
	wire [31:0] result;
	
	float_multiplier FM1(.clock(CLK), .resetn(RESETn), .A(A), .B(B), .result(mul_out));
	
	sum_out_buffer SB1(.clock(CLK), .resetn(RESETn), .input_data(C), .output_data(aged_C));
	
	float_adder FA1(.clock(CLK), .resetn(RESETn), .A(mul_out), .B(aged_C), .result(result));

	assign Y = result;

	//text_write TW1(.clock(clock), .resetn(resetn), .in_result(result));

endmodule
