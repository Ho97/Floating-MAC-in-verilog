`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:58:48 12/22/2022 
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
	
	wire [31:0] mul_out;
	wire [31:0] aged_C;
	wire [31:0] result;
	
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
			
	
	
	
	float_multiplier MUL1(.CLK(CLK), .RESETn(RESETn), .A(input_A), .B(input_B), .result(mul_out));
	
	sum_out_buffer SB1(.CLK(CLK), .RESETn(RESETn), .input_data(input_C), .output_data(aged_C));
	
	float_adder ADD1(.CLK(CLK), .RESETn(RESETn), .A(mul_out), .B(aged_C), .result(result));

	assign Y = result;
		
	text_write TW1(.clock(CLK), .resetn(RESETn), .in_result(result));
	

endmodule

  