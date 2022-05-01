// expect output to arrive 1 cycle later because sync_rom is sequential

module partialDFT(
    input logic clk, reset,
    input logic rdy,
    input logic signed [7:0] address,  // idx = 2*pi*k*n/N
    // input logic signed [26:0
    input logic signed [26:0] x,    // 
    output logic signed [26:0] real_out, img_out;
    output val
);
    logic signed [15:0] cosine, sine;
    logic signed [26:0] cos_ext, sin_ext;
    // logic signed [26:0] real_out, img_out;
    assign cos_ext = cosine[15] ? {13'h1fff, cosine[13:0]} :  {13'd0, cosine[13:0]};
    assign sin_ext = sine[15] ? {13'h1fff, sine[13:0]} :  {13'd0, sine[13:0]};
    
    sync_rom t (.clock(clk), .address(address), .sine(sine), .cosine(cosine));

    // signed_mult r (.out(real_out), .a(27'd2), .b(cos_ext));
    // signed_mult i (.out(img_out), .a(27'd2), .b(sin_ext));
    signed_mult r (.out(real_out), .a(x), .b(cos_ext));
    signed_mult i (.out(img_out), .a(x), .b(sin_ext));

    // handshake protocol?
    always_ff@(posedge clk) begin
        if(rdy) begin 
            val <= 1;
        end else begin
            val <= 0;
        end              
    end
endmodule


module partialDFT_tb();

    logic clk, reset;
    logic signed [7:0] address;  // idx = 2*pi*k*n/N
    logic signed [26:0] x;    // 
    logic signed [26:0] real_out, img_out;

    initial begin
		clk <= 0;
		forever #(50) clk <= ~clk;
	end

    partialDFT DUT (.*);
    
    parameter power = 12;
    parameter N = 2**power;
    // define pi in 13.14 fixed point
    logic signed [26:0] pi, pit2;
    logic signed [26:0] k;
    logic signed [26:0] n ,  nOverN; 
    logic signed [26:0] kth, theta;
    assign pit2 = {10'd0, 3'b110, 14'b01_0010_0001_1111};
    assign nOverN = n >> power; 
    signed_mult s1 (.out(kth), .a(pit2), .b(k));
    signed_mult s2 (.out(theta), .a(nOverN), .b(kth));

    assign address = theta[15:8];

    // provide x values in memory
    logic signed [26:0] mem [4095:0];
    initial begin
        $readmemh("test.txt", mem);
        
    end

    // change n, k, to see the partial output 
    int i; 

    initial begin
        reset <= 1;      k<= 1 << 14;     x <= mem[0];                  @(posedge clk);                    
        reset <= 0;                             @(posedge clk);                    
        for(i = 0; i < N; i++) begin
            n <= i << 14; x <= mem[i];@(posedge clk);  
                    @(posedge clk);  
        end             
        $display()
        $stop;
    end


    real rr_o;
    real ri_o; 
    real r_2pi;
    real r_nOverN;
    assign r_nOverN = real'(nOverN/(2.0**14));
    assign r_2pi = real'(pit2/(2.0**14));
    assign rr_o = real'(real_out/(2.0**14)) ;
    assign ri_o = real'(img_out/(2.0**14));

endmodule 