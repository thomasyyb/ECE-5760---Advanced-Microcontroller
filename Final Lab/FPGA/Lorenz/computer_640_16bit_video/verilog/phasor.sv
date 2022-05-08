module phasor (
    input  logic clk, reset, 
    input  logic signed [26:0] sine_mag, cosine_mag,
    input  logic [4:0] freq, //up to 31st harmonic 
    // output logic signed [19:0] sin_out, cos_out
    output logic signed [26:0] out
);
    logic [7:0] address; // step
    always_ff @(posedge clk) begin
        if (reset)
            address <= 8'd0;
        else  
            address <= address + freq;
    end
    logic signed [15:0] sine, cosine;
    sync_rom s (.clock(clk), .address(address), .sine(sine), .cosine(cosine));

    logic signed [26:0] cos_ext, sin_ext;
    assign cos_ext = cosine[15] ? {13'h1fff, cosine[13:0]} :  {13'd0, cosine[13:0]};
    assign sin_ext = sine[15] ? {13'h1fff, sine[13:0]} :  {13'd0, sine[13:0]};
    
    logic signed [26:0] sine_out, cosine_out;
    signed_mult _sine (.out(sine_out), .a(sine_mag), .b(sin_ext));
    signed_mult _cosine (.out(cosine_out), .a(cosine_mag), .b(cos_ext));

    assign out = sine_out + cosine_out;

endmodule

// for now 
// 4.23 fixed point 
// module phasor (
//     input  logic clk, reset, 
//     input  logic signed [3:0] sine_mag, cosine_mag,
//     input  logic [3:0] freq, //up to 15th harmonic 
//     // output logic signed [19:0] sin_out, cos_out
//     output logic signed [19:0] out
// );
//     logic [7:0] address; // step
//     always_ff @(posedge clk) begin
//         if (reset)
//             address <= 8'd0;
//         else if (rdy) begin 
//             address <= address + freq;
//         end
//     end
//     logic signed [15:0] sine_out, cosine_out;
//     sync_rom s (.clock(clk), .address(address), .sine(sine_out), .cosine(cosine_out));

//     assign out = sine_out * sine_mag + cosine_out * cosine_mag;
//     // assign sin_out = sine_out * sine_mag;
//     // assign cos_out = cosine_out * cosine_mag;

// endmodule 

// module phasor_tb();
//     logic clk, reset;
//     logic signed [3:0] sine_mag, cosine_mag; 
//     logic [3:0] freq; //up to 15th harmonic
//     logic signed [19:0] s_out, c_out;

//     initial begin
// 		clk <= 0;
// 		forever #(50) clk <= ~clk;
// 	end

//     phasor DUT (.*);
    
//     initial begin
//         reset <= 1; freq <= 1; sine_mag <= 1; cosine_mag <= 1; @(posedge clk);                    
//         reset <= 0;     @(posedge clk);                    
//         repeat(1000)    @(posedge clk);                    
//         sine_mag <= 3;       @(posedge clk);                    
//         repeat(1000)    @(posedge clk);                    
//         cosine_mag <= -3;      @(posedge clk);                    
//         repeat(1000)    @(posedge clk);                    
//         $stop;
//     end

// endmodule
