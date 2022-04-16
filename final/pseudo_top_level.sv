module pseudo_top_level(
    input logic clk, reset,
    input logic signed [3:0] mag1, mag2,// for debugging
    input logic [3:0] freq1, freq2 
);

    logic signed [19:0] out1, out2;
    phasor h1 (.clk(clk), .reset(reset), .mag(mag1), .freq(freq1), .out(out1));
    phasor h2 (.clk(clk), .reset(reset), .mag(mag2), .freq(freq2), .out(out2));

    logic signed [20:0] sum;
    assign sum = out1 + out2;

endmodule

module pseudo_top_level_tb();
    logic clk, reset;
    logic signed [3:0] mag1, mag2; 
    logic [3:0] freq1, freq2; //up to 15th harmonic

    initial begin
		clk <= 0;
		forever #(50) clk <= ~clk;
	end

    pseudo_top_level DUT (.*);
    
    initial begin
        reset <= 1; freq1 <= 1; freq2 <= 2; mag1 <= 1; mag2 <= 7; @(posedge clk);
        reset <= 0; @(posedge clk);
        
        repeat(1000) @(posedge clk);
        $stop;
    end

endmodule