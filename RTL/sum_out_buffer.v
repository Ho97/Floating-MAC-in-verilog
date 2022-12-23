module sum_out_buffer(clock, resetn, input_data, output_data);
	input clock, resetn;
	
	input [31:0] input_data;
	
	output [31:0] output_data;
	
	///Mul에서 인풋 A와 B가 곱해지는 동안 이전 MAC에서 전달되는 Y값을 임시로 저장해 두기 위한 버퍼
	
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

module temporary_box(clock, resetn, in_data, out_data); //1 clock 동안 임시 저장
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
