`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    22:35:03 12/16/2022 
// Design Name: 
// Module Name:    sum_out_buffer 
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
module sum_out_buffer(clock, resetn, input_data, output_data);
	input clock, resetn;
	
	input [31:0] input_data;
	
	output [31:0] output_data;
	
	///Mul���� ��ǲ A�� B�� �������� ���� ���� MAC���� ���޵Ǵ� Y���� �ӽ÷� ������ �α� ���� ����
	
	parameter cycle = 14;
	
	wire [31:0] temp_data[cycle : 0];
	
	assign temp_data[0] = input_data;
	
	genvar i;
	generate
		for(i=0 ; i<cycle ; i=i+1) begin: loop_buf
			temporary_box TB1 (.clock(clock), .resetn(resetn), .in_data(temp_data[i]), .out_data(temp_data[i+1]));
		end
	endgenerate
	
	assign output_data = temp_data[cycle];

endmodule

////////////////////////////////////////////////////

module temporary_box(clock, resetn, in_data, out_data); //1 clock ���� �ӽ� ����
	input clock, resetn;
	
	input [31:0] in_data;
		
	output reg [31:0] out_data;
	
	always@(posedge clock, negedge resetn) begin
		if(!resetn) begin
			out_data <=0;
		end
		else begin	
			out_data <= in_data;
		end
	end

endmodule 