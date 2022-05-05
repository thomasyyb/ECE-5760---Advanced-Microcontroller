
// ====================================================================
// audio_synthesis.sv:
//   Computes the next time step of the phasor module every time 
//   the rdy signal is set high
// ====================================================================

module audio_synthesis
#(
  parameter N = 21,
  parameter bitwidth = 27
)(
  input logic clk, reset,
  input logic signed [bitwidth-1:0] coeff_sin [N-1:0], 
  input logic signed [bitwidth-1:0] coeff_cos [N-1:0],
  output logic signed [bitwidth-1:0] out
);

  logic signed [bitwidth-1:0] phasor_out [N-1:0];

  generate
    genvar i;
    for (i = 1; i <= N; i = i+1) begin: GenDFT

      // assumed combinational logic?
      // partialDFT is 27 bits?
      phasor _phasor (
        .clk(clk),
        .reset(reset),
        .sine_mag(coeff_sin[i-1]),
        .cosine_mag(coeff_cos[i-1]),
        .freq(i[4:0]),               // TODO?
        .out(phasor_out[i-1])
      );
   
    end
  endgenerate

  logic signed [bitwidth-1:0] sum;

  integer j;
  always_comb begin
    sum = {(bitwidth-1){1'b0}}; // all zero
    for(j = 0; j < N; j=j+1)
      sum = sum + phasor_out[j];
  end

  assign out = sum;

endmodule 

module audio_syn_tb();

  parameter N = 21;
  parameter bitwidth = 27; 

  // variables:
  logic clk, reset;
  logic signed [bitwidth-1:0] coeff_sin [N-1:0];
  logic signed [bitwidth-1:0] coeff_cos [N-1:0];
  logic signed [bitwidth-1:0] out;

  integer i;

  always begin
    #5
    clk = !clk; 
  end

  audio_synthesis DUT (.*);
    
  initial begin
    reset = 1'b0; 
    clk <= 0;
    #10
    reset = 1'b1; 
    #30
    reset = 1'b0;
    #10 
    for (i = 0; i < N; i = i + 1) begin
      if (i < 1) begin
        coeff_sin[i] <= (27'b1 << 14);
        coeff_cos[i] <= (27'b1 << 14);
      end else begin
      coeff_sin[i] <= 27'b0;
      coeff_cos[i] <= 27'b0;
      end
    end
    #5000;
    for (i = 0; i < N; i = i + 1) begin
      if (i < 10) begin
        coeff_sin[i] <= (27'h10 << 14);
        coeff_cos[i] <= (27'h9 << 14);
      end else begin
      coeff_sin[i] <= 27'b0;
      coeff_cos[i] <= 27'b0;
      end
    end
    #5000;

    $stop;

      // @ (posedge clk); 
      // reset <= 1; freq <= 1; sine_mag <= 1; cosine_mag <= 1; @(posedge clk);                    
      // reset <= 0;     @(posedge clk);                    
      // repeat(1000)    @(posedge clk);                    
      // sine_mag <= 3;       @(posedge clk);                    
      // repeat(1000)    @(posedge clk);                    
      // cosine_mag <= -3;      @(posedge clk);                    
      // repeat(1000)    @(posedge clk);                    
      // $stop;
  end

endmodule

// module M10K_partial_dft
// #(
//   parameter N = 3,
//   parameter address_bitwidth = 2, // approx. log_2(N)
//   parameter bitwidth = 27
// )( 
//     output reg [bitwidth-1:0] q,
//     input [bitwidth-1:0] d,
//     input [address_bitwidth-1:0] write_address, read_address,
//     input we, clk
// );
// 	 // force M10K ram style
// 	 // 307200 words of 8 bits
//     reg [bitwidth-1:0] mem [address_bitwidth-1:0]  /* synthesis ramstyle = "no_rw_check, M10K" */;
	 
//     always @ (posedge clk) begin
//         if (we) begin
//             mem[write_address] <= d;
// 		  end
//         q <= mem[read_address]; // q doesn't get d in this clock cycle
//     end
// endmodule