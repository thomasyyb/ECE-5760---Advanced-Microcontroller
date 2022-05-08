
//////////////////////////////////////////////////
//// signed mult of 13.14 format 2'comp////////////
//////////////////////////////////////////////////

module signed_mult (out, a, b);
	output 	signed  [26:0]	out;
	input 	signed	[26:0] 	a;
	input 	signed	[26:0] 	b;
	// intermediate full bit length
	wire 	signed	[53:0]	mult_out;
	assign mult_out = a * b;
	// select bits for 13.14 fixed point
	assign out = {{mult_out[53], mult_out[39:28]}, mult_out[27:14]};
endmodule
//////////////////////////////////////////////////