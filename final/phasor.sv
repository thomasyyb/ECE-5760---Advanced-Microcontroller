// for now 
// 4.23 fixed point 
module phasor (
    input logic clk, reset, 
    input logic signed [3:0] mag, 
    input logic [3:0] freq, //up to 15th harmonic 
    output logic signed [19:0] out
);
    logic [7:0] address; // step 
    // logic [15:0] out;
    always_ff @(posedge clk) begin
        if(reset)
            address <= 8'd0;
        else begin
            address <= address + freq;
        end
    end
    logic signed [15:0] sine_out;
    sync_rom s (.clock(clk), .address, .sine(sine_out));

    
    assign out = sine_out * mag;
    
endmodule 

module phasor_tb();
    logic clk, reset;
    logic signed [3:0] mag; 
    logic [3:0] freq; //up to 15th harmonic
    logic signed [19:0] out;

    initial begin
		clk <= 0;
		forever #(50) clk <= ~clk;
	end

    phasor DUT (.*);
    
    initial begin
        reset <= 1; freq <= 1; mag <= 1;@(posedge clk);
        reset <= 0; @(posedge clk);
        
        repeat(1000) @(posedge clk);

        mag <= 3; @(posedge clk);
        repeat(1000) @(posedge clk);
        mag <= -3; @(posedge clk);
        repeat(1000) @(posedge clk);
        $stop;
    end

endmodule
