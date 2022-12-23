`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    18:07:01 12/23/2022 
// Design Name: 
// Module Name:    fp_mac 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module fp_mac(CLK, RESETn, A, B, C, Y);
	input CLK, RESETn;
	
	input [15:0] A, B;	//new data
	input [31:0] C;		//data from previous MAC
	
	output [31:0] Y;
		
	reg [15:0] input_A, input_B;
	reg [31:0] input_C;
	
	always@(posedge CLK, negedge RESETn) begin
		if(!RESETn) begin
			input_A <= 0;
			input_B <= 0;
			input_C <= 0;
		end
		else begin
			input_A <= A;
			input_B <= B;
			input_C <= C;
		end
	end
	
	// STEP 1 /////////////////////////
	//exponent addition, sign determination
	//array multiplication row 1 to 4
	//in - input_A, input_B
	//out - mul_out_sign, mul_current_ex, temp_p_r4, temp_s_r4
	//transfer - input C
	
	wire ms1_mul_sign;
	wire [7:0] ms1_mul_current_ex;
	wire [21:0] ms1_p_r4[10:5];
	wire [21:0] ms1_s_r4;
	wire [31:0] ms1_C;
	
	mac_step1 MS1(.CLK(CLK), .RESETn(RESETn), .A(input_A), .B(input_B), .C(input_C), .mul_sign(ms1_mul_sign), .mul_ex(ms1_mul_current_ex), .out_C(ms1_C), .s_r4(ms1_s_r4), .p_r4_5(ms1_p_r4[5]), .p_r4_6(ms1_p_r4[6]), .p_r4_7(ms1_p_r4[7]), .p_r4_8(ms1_p_r4[8]), .p_r4_9(ms1_p_r4[9]), .p_r4_10(ms1_p_r4[10]));
	/////////////////////////////////////////////
	
	
	// STEP 2 /////////////////
	//array multiplication row 5 to 10
	//detect first one
	//in  - s_r4, p_r4[10:5]
	//out - mul_out, count
	//transfer - C, mul_out_sign, mul_current_ex
	
	wire [21:0] ms2_mul_sg;
	wire [4:0] ms2_mul_count;
	
	wire ms2_mul_sign;
	wire [7:0] ms2_mul_current_ex;
	wire [31:0] ms2_C;
	
	mac_step2 MS2(.CLK(CLK), .RESETn(RESETn), .in_sign(ms1_mul_sign), .in_ex(ms1_mul_current_ex), .in_C(ms1_C), .s_r4(ms1_s_r4), .p_r4_5(ms1_p_r4[5]), .p_r4_6(ms1_p_r4[6]), .p_r4_7(ms1_p_r4[7]), .p_r4_8(ms1_p_r4[8]), .p_r4_9(ms1_p_r4[9]), .p_r4_10(ms1_p_r4[10]), .out_sign(ms2_mul_sign), .out_ex(ms2_mul_current_ex), .out_C(ms2_C), .mul_out(ms2_mul_sg), .count(ms2_mul_count));
	////////////////////////////////////////
	
	
	// STEP 3 ////////////////////////////
	//multiplication output normalization
	//compare ex of mul_out with C
	//shift smaller exponent one
	//modify to input1 and input2 for summation
	//in  - C, mul_out_significand, count, mul_current_ex, mul_out_sign, 
	//out - add_out_sign, add_current_ex, input1, input2, ov_yn
	
	wire ms3_out_sign;
	wire [7:0] ms3_add_current_ex;
	wire [23:0] ms3_input1, ms3_input2;
	wire ms3_ov_yn;
	
	mac_step3 MS3(.CLK(CLK), .RESETn(RESETn), .C(ms2_C), .mul_sg(ms2_mul_sg), .mul_count(ms2_mul_count), .mul_current_ex(ms2_mul_current_ex), .mul_sign(ms2_mul_sign), .add_out_sign(ms3_out_sign), .add_current_ex(ms3_add_current_ex), .out_input1(ms3_input1), .out_input2(ms3_input2), .ov_yn(ms3_ov_yn));
	//////////////////////////////////////////////
	
	
	// STEP 4 //////////////////////////////////
	//Kogge Stone Adder 한 스텝에 진행 >> firstone detection까지
	//in  - input1, input2, ov_yn
	//out - sum, overflow, count
	//transfer - add_out_sign, add_current_ex
	
	wire [23:0] ms4_sum;
	wire ms4_ov;
	wire [4:0] ms4_count;
	
	wire ms4_out_sign;
	wire [7:0] ms4_current_ex;
	
	mac_step4 MS4(.CLK(CLK), .RESETn(RESETn), .in_sign(ms3_out_sign), .in_ex(ms3_add_current_ex), .input1(ms3_input1), .input2(ms3_input2), .ov_yn(ms3_ov_yn), .sum(ms4_sum), .overflow(ms4_ov), .count(ms4_count), .out_sign(ms4_out_sign), .out_ex(ms4_current_ex));
	///////////////////////////////////////////////////////
	
	
	// STEP 5 /////////////////////////////////
	//normalize와 Round(+normalize) 진행
	//in  - out_sign, current_ex, sum, overflow, count
	//out - out_sign, out_ex, out_sg
	
	wire ms5_out_sign;
	wire [7:0] ms5_out_exponent;
	wire [23:0] ms5_out_significand;
	
	mac_step5 MS5(.CLK(CLK), .RESETn(RESETn), .out_sign(ms4_out_sign), .current_ex(ms4_current_ex), .sum(ms4_sum), .ov(ms4_ov), .count(ms4_count), .out_s(ms5_out_sign), .out_ex(ms5_out_exponent), .out_sg(ms5_out_significand));
	
	assign Y = {ms5_out_sign, ms5_out_exponent, ms5_out_significand[22:0]};
	
	//text_write TW1(.clock(CLK), .resetn(RESETn), .in_result(Y));
	
endmodule
