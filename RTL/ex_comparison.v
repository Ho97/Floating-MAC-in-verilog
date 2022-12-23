module ex_comparison(ex_A, ex_B, ex_compare, ex_diff);
	
	input [7:0] ex_A, ex_B;
	output ex_compare;
	output [7:0] ex_diff;
	
	assign ex_compare = (ex_A > ex_B) ? 0 : 1;
	//ex_A가 더 크면 0, ex_B가 더 크면 1  
	//ex 같으면 1
	
	wire [7:0] bigger  = (ex_compare) ? ex_B : ex_A;
	wire [7:0] smaller = (ex_compare) ? ex_A : ex_B;

	//unsigned 8bit subtraction
	assign ex_diff = bigger - smaller;	

endmodule 
