
module dft
#(
  parameter N = 3, // 2048
  parameter k = 1
)(
  input logic clk, reset, 
  output logic signed [26:0] x_real_out,
  output logic signed [26:0] x_img_out,
  output logic val
);

  logic signed [26:0] dft_partial_out [N-1:0];
  logic signed [26:0] x_n_reg [N-1:0];
  logic signed [26:0] cos_real_out [N-1:0];
  logic signed [26:0] cos_img_out [N-1:0];
  logic signed [26:0] sin_real_out [N-1:0];
  logic signed [26:0] sin_img_out [N-1:0];
  logic signed [26:0] cos_val[N-1:0];
  logic signed [26:0] sin_val[N-1:0];

  logic [N-1:0] counter;
  logic rdy; 

  generate
    genvar i;
    for (i = 0; i < N; i = i+1) begin: GenDFT

      partialDFT cos(
        .clk(clk),
        .reset(reset),
        .rdy(rdy),
        .address(), 
        .x(x_n_reg[i]),
        .real_out(cos_real_out[i]),
        .img_out(cos_img_out[i]),
        .val(cos_val[i])
      );

      partialDFT sin(
        .clk(clk),
        .reset(reset),
        .rdy(rdy),
        .address(),
        .x(x_n_reg[i]),
        .real_out(sin_real_out[i]),
        .img_out(sin_img_out[i]),
        .rdy_out(sin_val[i])
      );

    end
  endgenerate

  logic cos_val_all = &cos_val;
  logic sin_val_all = &sin_val; 

  always @ (posedge clk) begin
    if (reset) begin
      counter = 0;
      x_out = 0;
      rdy = 0;
    end else begin

      if (counter == N) begin

        val = 1;
        
      end else begin

        if (cos_val[counter-1] && sin_val[counter-1]) begin
          x_real_out = x_real_out + sin_real_out
        end

      end

    end // end of if reset 

  end // end of always clk

endmodule 

module M10K_partial_dft
#(
  parameter N = 3,
  parameter address_bitwidth = 2, // approx. log_2(N)
  parameter bitwidth = 27
)( 
    output reg [bitwidth-1:0] q,
    input [bitwidth-1:0] d,
    input [address_bitwidth-1:0] write_address, read_address,
    input we, clk
);
	 // force M10K ram style
	 // 307200 words of 8 bits
    reg [bitwidth-1:0] mem [address_bitwidth-1:0]  /* synthesis ramstyle = "no_rw_check, M10K" */;
	 
    always @ (posedge clk) begin
        if (we) begin
            mem[write_address] <= d;
		  end
        q <= mem[read_address]; // q doesn't get d in this clock cycle
    end
endmodule

module dft_tb();
    logic clk, reset;
    logic signed [3:0] sine_mag, cosine_mag; 
    logic [3:0] freq; //up to 15th harmonic
    logic signed [19:0] s_out, c_out;

    initial begin
		clk <= 0;
		forever #(50) clk <= ~clk;
	end

    phasor DUT (.*);
    
    initial begin
        reset <= 1; freq <= 1; sine_mag <= 1; cosine_mag <= 1; @(posedge clk);                    
        reset <= 0;     @(posedge clk);                    
        repeat(1000)    @(posedge clk);                    
        sine_mag <= 3;       @(posedge clk);                    
        repeat(1000)    @(posedge clk);                    
        cosine_mag <= -3;      @(posedge clk);                    
        repeat(1000)    @(posedge clk);                    
        $stop;
    end

endmodule