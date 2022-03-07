module lorenz #(parameter WIDTH=27)    // floating point as parameter?? 
	(
		input  clk, reset,
		input  signed [WIDTH-1:0] sigma, beta, rho, dt, x0, y0, z0,
		output signed [WIDTH-1:0] x, y, z
	);
	
	// define wires
	wire signed [WIDTH-1:0] dtx, dty, dtz;
	wire signed [WIDTH-1:0] s1_out, s2_out, s3_out, s4_out;
	
	
	
	// instantiate integrators
	integrator i1 (.out(x), .funct(s1_out), 			.InitialOut(x0), .clk(clk), .reset(reset)); 
	integrator i2 (.out(y), .funct(s2_out-dty), 		.InitialOut(y0), .clk(clk), .reset(reset)); 
	integrator i3 (.out(z), .funct(s3_out-s4_out), 	.InitialOut(z0), .clk(clk), .reset(reset)); 
	
	
	// instantiate signed_mult modules 
	
	assign dtx = x >>> 8;
	assign dty = y >>> 8;
	assign dtz = z >>> 8;
	

	signed_mult s1 (.out(s1_out), .a(dty-dtx), .b(sigma));
	signed_mult s2 (.out(s2_out), .a(dtx), .b(rho-z));
	signed_mult s3 (.out(s3_out), .a(dtx), .b(y));
	signed_mult s4 (.out(s4_out), .a(dtz), .b(beta));
	
	
endmodule 


//`timescale 1 ns/10 ps  // time-unit = 1 ns, precision = 10 ps

