module pseudo_top_analysis(
    input logic clk, reset,
    //debug
    output logic [26:0] oSum
);


    logic [15:0] mem_x [9:0]; // at most 9 points 
    logic [15:0] mem_y [9:0]; 

    logic [3:0] K;
    logic [3:0] count;
    logic done; 
    assign K = 4;

    initial begin 
        mem_x[0] = 16'b0; mem_y[0] = 16'b0;
        mem_x[1] = 16'b0; mem_y[1] = 16'b1;
        mem_x[2] = 16'b1; mem_y[2] = 16'b1;
        mem_x[3] = 16'b1; mem_y[3] = 16'b0;
        // close curve
        mem_x[4] = 16'b0; mem_y[4] = 16'b0;
    end

    logic [26:0] fp_x, fp_y;
    logic [15:0] pixel_x, pixel_y;
                    //pixel_x
    Int2Fp x (.iInteger(16'd3), .oA(fp_x)); 
                    //pixel_y
    Int2Fp y (.iInteger(16'd2), .oA(fp_y));

    always_ff @(posedge clk) begin
        if(reset) begin
            count <= 0;
            done <= 0;
            pixel_x <= 0;
            pixel_y <= 0;
        end else begin
            pixel_x <= mem_x[count];
            pixel_y <= mem_y[count];
            count <= count + 1;
            if(count == K) begin
                done <= 1;
            end
        end
    end 

    // test fpAdd 
    //logic [26:0] oSum;
    FpAdd a (.iCLK(clk), .iA(fp_x), .iB(fp_y), .oSum(oSum));

//     module FpAdd (
//     input             iCLK,
//     input      [26:0] iA,
//     input      [26:0] iB,
//     output reg [26:0] oSum
// );
endmodule

module pseudo_top_analysis_tb();
   logic clk, reset;
   logic [26:0] oSum;

    initial begin
		clk <= 0;
		forever #(50) clk <= ~clk;
	end

    pseudo_top_analysis DUT (.*);
    
    initial begin
        reset <= 1; @(posedge clk);
        reset <= 0; @(posedge clk);
        
        repeat(5) @(posedge clk);
        $stop;
    end
    real rr_oSum; 
    // oSum[26]
    // oSum[25:18]
    // {1,oSum[17:0]}
    assign rr_oSum = oSum[26] ? -real'((2**(oSum[25:18]-127))*({1'b1,oSum[17:0]})/(2.0**18)) : real'((2**(oSum[25:18]-127))*({1'b1,oSum[17:0]})/(2.0**18));

    //     real rr_i, rr_r; 
//     assign rr_i = real'(ci/(2.0**23));
endmodule 