`timescale 1ns/1ns
module solver_tb();

    reg clk_50, reset;
    reg [26:0] ci, cr;
    reg signed [12:0] in_max_iter;

    wire [12:0] out_iter;
    wire done_reg;

    //Initialize clock
    initial begin   
        clk_50 = 1'b0;
    end

    //Toggle the clocks
	always begin
		#5
		clk_50  = !clk_50;
	end
    initial begin
        ci = 0;
        cr = 0;
        in_max_iter = 13'd1000;
        reset  = 1'b0;
		#10 
		reset  = 1'b1;
		#30
		reset  = 1'b0;
      
        #15000;
        ci = 1 << 23;
        cr = 1 << 23; // this is 1
        reset  = 1'b0;
		#10 
		reset  = 1'b1;
		#30
		reset  = 1'b0;

        #15000;
        ci = 1 << 22; // 0.5
        cr = 1 << 22;
        reset  = 1'b0;
		#10 
		reset  = 1'b1;
		#30
		reset  = 1'b0;

        #15000;
        ci = 0; // 0.5
        cr = 3 << 20;
        reset  = 1'b0;
		#10 
		reset  = 1'b1;
		#30
		reset  = 1'b0;
    end


    // Top level function

    solver _solver(
        .clk(clk_50),
        .reset(reset),
        .ci(ci),       
        .cr(cr),      
        .in_max_iter(in_max_iter),
        .out_iter(out_iter),
        .done_reg(done_reg)
    );

endmodule
