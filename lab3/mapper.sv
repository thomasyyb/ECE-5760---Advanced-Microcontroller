module mapper (
    input logic [9:0] x,
    input logic [8:0] y,
    input logic [26:0] delta,  
    input logic [3:0] scale,

    output logic [26:0] ci, cr
);
    // zoomed out top left coordiantes 
    logic [9:0] dx;
    logic [8:0] dy;
    logic [26:0] tl_x, tl_y;
    
    assign tl_x = 13 << 23; // -3 
    assign tl_y = 3 << 22; // 1.5
    
    
    // always_comb 
    // assign d15 = (delta[15] == 1'b1) ? (dx << 15) : 27'd0;
    // assign d14 = (delta[15] == 1'b1) ? (dx << 15) : 27'd0;
    // assign d13 = (delta[15] == 1'b1) ? (dx << 15) : 27'd0;
    // assign d12 = (delta[15] == 1'b1) ? (dx << 15) : 27'd0;
    // assign d11 = (delta[15] == 1'b1) ? (dx << 15) : 27'd0;
    // assign d10 = (delta[15] == 1'b1) ? (dx << 15) : 27'd0;
    // assign d09 = (delta[15] == 1'b1) ? (dx << 15) : 27'd0;
    // assign d08 = (delta[15] == 1'b1) ? (dx << 15) : 27'd0;
    // assign d07 = (delta[15] == 1'b1) ? (dx << 15) : 27'd0;
    // assign d06 = (delta[15] == 1'b1) ? (dx << 15) : 27'd0;
    // assign d05 = (delta[15] == 1'b1) ? (dx << 15) : 27'd0;
    // assign d04 = (delta[15] == 1'b1) ? (dx << 15) : 27'd0;
    
    // worst resolution is 4/480 = (0000.000_0000_1100_1100_1101_0000)
    // scale starts from 0 -> 15 // 16 breaks 
    
    assign dx = x + 1'b1;
    assign dy = y + 1'b1;
    assign cr = tl_x + ((dx << 15) + (dx << 14) + (dx << 11) + (dx << 10) + (dx << 7) + (dx << 6) + (dx << 4)) >> scale ;
    assign ci = tl_y - ((dy << 15) + (dy << 14) + (dy << 11) + (dy << 10) + (dy << 7) + (dy << 6) + (dy << 4)) >> scale ;
    

    /*
    zoom in -> delta >> 1 
    */
    
    // can be done with shifting, a huge combinational shift mapping
    
    

endmodule 

module mapper_tb ();
    logic clock;
    logic [9:0] x;
    logic [8:0] y;
    logic [26:0] delta;  
    logic [3:0] scale;
    logic signed git [26:0] ci, cr;

	initial begin
		clock <= 0;
		forever #(50) clock <= ~clock;
	end

    mapper DUT (.*);

    initial begin 
        scale <= 0; @(posedge clock);
        @(posedge clock);
        x <= 0; y <= 0;    @(posedge clock);
        x <= 0; y <= 479;    @(posedge clock);
        x <= 639; y <= 0;    @(posedge clock);
        x <= 639; y <= 479;    @(posedge clock);
        @(posedge clock);

        $stop;


    end

    real rr_i, rr_r; 
    assign rr_i = real'(ci/(2.0**23));
    assign rr_r = real'(cr/(2.0**23));

endmodule 