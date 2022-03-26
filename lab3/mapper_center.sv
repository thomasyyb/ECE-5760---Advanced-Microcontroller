module mapper (
    input logic clk, reset,
    input logic [9:0] x,
    input logic [8:0] y,
    // input logic [26:0] delta,  
    input logic [5:0] scale,

    input logic sl, sr, su, sd,
    output logic [26:0] ci, cr
);
    // zoomed out top left coordiantes 
    logic signed [26:0] tl_x, tl_y;
    logic signed [26:0] center_x, center_y;
    logic [26:0] delta;

    assign delta = 27'b0000_000_0000_1100_1100_1101_0000 >> scale;

    always_ff @(posedge clk) begin
        if(reset) begin
            center_x <= 0;  // 13 = 0b1101
            center_y <= 0;
            // tl_x <= 13 << 23;  // 13 = 0b1101
            // tl_y <= 3  << 22;
        end else begin // might want a safeguard for over/underflow?
            if(sl) 
                center_x <= center_x - (delta << 5);
            if(sr)
                center_x <= center_x + (delta << 5);
            if(su)
                center_y <= center_y + (delta << 5);
            if(sd)
                center_y <= center_y - (delta << 5);
            // if(sl) 
            //     tl_x <= tl_x - (delta << 5);
            // if(sr)
            //     tl_x <= tl_x + (delta << 5);
            // if(su)
            //     tl_y <= tl_y + (delta << 5);
            // if(sd)
            //     tl_y <= tl_y - (delta << 5);
        end 
    end
    
    assign tl_x = center_x - (((320 << 15) + (320 << 14) + (320 << 11) + (320 << 10) + (320 << 7) + (320 << 6) + (320 << 4)) >> scale) ;
    assign tl_y = center_y + (((240 << 15) + (240 << 14) + (240 << 11) + (240 << 10) + (240 << 7) + (240 << 6) + (240 << 4)) >> scale) ;
    assign cr = tl_x + (((x << 15) + (x << 14) + (x << 11) + (x << 10) + (x << 7) + (x << 6) + (x << 4)) >> scale) ;
    assign ci = tl_y - (((y << 15) + (y << 14) + (y << 11) + (y << 10) + (y << 7) + (y << 6) + (y << 4)) >> scale) ;

    // assign dx = x - 320;
    // assign dy = y - 240;
    // assign cr = center_x + (((dx << 15) + (dx << 14) + (dx << 11) + (dx << 10) + (dx << 7) + (dx << 6) + (dx << 4)) >> scale) ;
    // assign ci = center_y - (((dy << 15) + (dy << 14) + (dy << 11) + (dy << 10) + (dy << 7) + (dy << 6) + (dy << 4)) >> scale) ;

endmodule 

// module mapper_tb ();
//     logic clk, reset;
//     logic [9:0] x;
//     logic [8:0] y;
//     logic sl, sr, su, sd;
//     logic [3:0] scale;
//     logic signed [26:0] ci, cr;
//     logic signed [26:0] tl_x, tl_y; // for debugging
//     logic [26:0] delta; // for debugging 

// 	initial begin
// 		clk <= 0;
// 		forever #(50) clk <= ~clk;
// 	end

//     mapper DUT (.*);
// // delta <= 27'b0000_000_0000_1100_1100_1101_0000;
//     initial begin 
//         scale <= 0;  reset <= 1;
//         su <= 0; sd <= 0; sl <= 0; sr <= 0;@(posedge clk);
//         reset <= 0; @(posedge clk);
//         @(posedge clk);
//         x <= 0; y <= 0;    @(posedge clk);
//         //  sr <= 1;                   @(posedge clk);
//         //  sr <= 0; @(posedge clk);
         
//          // change x to 1 to see scale effect
//          scale <= 1; @(posedge clk);
//          x <= 1; y <= 0; @(posedge clk);
//                             @(posedge clk);

//          sr <= 1; @(posedge clk);
//                     @(posedge clk);
//          sr <= 0; @(posedge clk);
//         x <= 0; y <= 479;    @(posedge clk);
//         x <= 639; y <= 0;    @(posedge clk);
//         x <= 639; y <= 479;    @(posedge clk);
//         @(posedge clk);

//         $stop;


//     end

//     real rr_i, rr_r; 
//     assign rr_i = real'(ci/(2.0**23));
//     assign rr_r = real'(cr/(2.0**23));

//     real rr_tlx, rr_tly, rr_delta;
//     assign rr_tlx = real'(tl_x/(2.0**23));
//     assign rr_tly = real'(tl_y/(2.0**23));
//     assign rr_delta = real'(delta/(2.0**23));

// endmodule 