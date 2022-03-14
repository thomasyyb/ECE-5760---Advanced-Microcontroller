/////////////////////////////////////////////////
////////////	Single Node	/////////////////
/////////////////////////////////////////////////
module SingleNodeLinear (clock, reset, middle_init, middle, middle_out, left, right, up, down, middle_prev);
	input clock, reset;
	input wire signed[17:0] middle_init, left, right, up, down, middle, middle_prev;
	output reg signed[17:0] middle_out;
	wire signed [17:0] middle_temp_1, middle_temp_2, middle_temp_3, middle_temp_4, middle_temp_5, middle_pow2, rho_next;
	reg signed [17:0] rho;
	
	// calculate rho 
	signed_mult m1 (.out(middle_pow2), .a(middle >> 4), .b(middle >> 4));
	assign rho_next = ( (18'h10000 - 18'h00800) > (middle_pow2 + rho)) ? (middle_pow2 + rho) : (18'h10000 - 18'h00800);
	always@(posedge clock) begin
		if(reset) 
			rho <= {1'b0, 17'h08000};
	end
	

	assign middle_temp_1 = left + right + up + down - (middle << 2);
	signed_mult m2 (.out(middle_temp_2), .a(middle_temp_1), .b(rho));
	assign middle_temp_3 = (middle << 1) - (middle_prev - (middle_prev >>> 12));
	assign middle_temp_4 = middle_temp_2 + middle_temp_3;
	assign middle_temp_5 = middle_temp_4 >>> 12;

	always@(posedge clock) begin
	  if (reset) begin
		middle_out <= middle_init ;
	  end
	  else begin
		//middle_prev <= middle ;
		middle_out <= middle_temp_4 - middle_temp_5;
	  end
	end
endmodule

// Non linear module includes input of rho_eff to create "pitch glide"
// Includes Enable signal so the output only updates accordingly
module SingleNodeNonlinear (clock, reset, en, middle_init, middle, middle_out, left, right, up, down, middle_prev, rho_eff);
	input clock, reset, en;
	input wire signed[17:0] middle_init, left, right, up, down, middle, middle_prev;
	output reg signed[17:0] middle_out;
	input wire signed [17:0] rho_eff;
	wire signed [17:0] middle_temp_1, middle_temp_2, middle_temp_3, middle_temp_4, middle_temp_5, middle_pow2;

	assign middle_temp_1 = left + right + up + down - (middle << 2);
	signed_mult m2 (.out(middle_temp_2), .a(middle_temp_1), .b(rho_eff));
	assign middle_temp_3 = (middle << 1) - (middle_prev - (middle_prev >>> 12));
	assign middle_temp_4 = middle_temp_2 + middle_temp_3;
	assign middle_temp_5 = middle_temp_4 >>> 12;
	

	always@(posedge clock) begin
	  if (reset) begin
		middle_out <= middle_init ;
	  end
	  if (en) begin 
		middle_out <= middle_temp_4 - middle_temp_5;
	  end else 
	  	middle_out <= middle_out;
	end
endmodule

//////////////////////////////////////////////////
//// signed mult of 1.17 format 2'comp////////////
//////////////////////////////////////////////////

module signed_mult (out, a, b);
	output 	signed  [17:0]	out;
	input 	signed	[17:0] 	a;
	input 	signed	[17:0] 	b;
	// intermediate full bit length
	wire 	signed	[35:0]	mult_out;
	assign mult_out = a * b;
	// select bits for 1.17 fixed point
	assign out = {mult_out[35], mult_out[33:17]};
endmodule
//////////////////////////////////////////////////