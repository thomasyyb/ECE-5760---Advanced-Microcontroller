
module solver (

    input                clk, reset,
    input signed [26:0]  ci,
    input signed [26:0]  cr,
    input signed [12:0]  in_max_iter,

    // output signed [26:0] iout,
    // output signed [26:0] rout,
    output signed [12:0] out_iter,
    output logic         done_reg
); 

    // These are the four registers and their input wires
    logic signed [26:0] zr_reg, zi_reg, zr_sqr_reg, zi_sqr_reg;
    logic signed [26:0] zr_reg_in, zi_reg_in, zr_sqr_reg_in, zi_sqr_reg_in;

    // The next value for the registers during calculation (while reset/complete, the registers should be given 0)
    logic signed [26:0] zr_next_out, zi_next_out, zr_sqr_out, zi_sqr_out;

    // (zr^2 + zi^2) to check for diverging
    logic signed [26:0] z_magitude_sqr;

    // Keep the iteration number
    logic        [12:0] counter_reg;
    logic        [12:0] counter_reg_in;
    
    // Is it diverging?
    logic               diverge;

    // The input wire for done
    logic               done_reg_in;
        
    
    next_zr _next_zr(
        .zr_sqr(zr_sqr_reg), 
        .zi_sqr(zi_sqr_reg),
        .cr(cr),
        .zr_next(zr_next_out)
    );

    next_zi _next_zi(
        .zr(zr_reg), 
        .zi(zi_reg), 
        .ci(ci),
        .zi_next(zi_next_out)
    );

    signed_mult _zr_sqr_mult(
        .out(zr_sqr_out),
        .a(zr_reg_in),
        .b(zr_reg_in)
    );

    signed_mult _zi_sqr_mult(
        .out(zi_sqr_out),
        .a(zi_reg_in),
        .b(zi_reg_in)
    );


    assign z_magitude_sqr = zr_sqr_reg_in + zi_sqr_reg_in;

    assign out_iter = counter_reg;

    always_ff @ (posedge clk) begin
        zr_reg <= zr_reg_in;
        zi_reg <= zi_reg_in;
        zr_sqr_reg <= zr_sqr_reg_in;
        zi_sqr_reg <= zi_sqr_reg_in;
        counter_reg <= counter_reg_in;
        done_reg <= done_reg_in;
    end

    //======================================================================
    // State Update
    //======================================================================

    // Only two states/one cycle per iterations for three multipliers
    // STATE_INIT = 2'h0
    // STATE_ONE = 2'h1
    
    reg [2:0] state_reg; 

    always_ff @ (posedge clk) begin

        if (reset)
            state_reg <= 2'h0;
        else begin
            state_reg <= state_reg;

            case (state_reg)

                2'h0   : state_reg <= 2'h1;
                2'h1   : 
                        if (counter_reg >= in_max_iter-1 || diverge) 
                            state_reg <= 2'h2;
                        else 
                            state_reg <= 2'h1;
                2'h2   : state_reg <= 2'h2;
                default: state_reg <= 2'h0;

            endcase
        end
    end

    //======================================================================
    // State Outputs : combinational code
    //======================================================================

    always_comb begin

        case (state_reg) 

            0: begin
                zr_reg_in       = 0; 
                zi_reg_in       = 0;
                zr_sqr_reg_in   = 0; 
                zi_sqr_reg_in   = 0;
                counter_reg_in  = 0; 
                diverge         = 0; 
                done_reg_in     = 0; 
            end

            1: begin
                zr_reg_in       = zr_next_out; 
                zi_reg_in       = zi_next_out;
                zr_sqr_reg_in   = zr_sqr_out; 
                zi_sqr_reg_in   = zi_sqr_out;
                counter_reg_in  = counter_reg + 1; 
                diverge         = (zr_reg_in >= 27'sh100_0000 || zi_reg_in >= 27'sh100_0000 || z_magitude_sqr >= 27'sh200_0000); 
                done_reg_in     = diverge; 
            end

            2: begin
                zr_reg_in           = 0; 
                zi_reg_in           = 0;
                zr_sqr_reg_in       = 0; 
                zi_sqr_reg_in       = 0;
                counter_reg_in      = counter_reg;
                diverge             = 0; 
                done_reg_in         = 1;
            end

            default: begin
                zr_reg_in           = 0; 
                zi_reg_in           = 0;
                zr_sqr_reg_in       = 0; 
                zi_sqr_reg_in       = 0;
                counter_reg_in      = 0;
                diverge             = 0; 
                done_reg_in         = 0;
            end

        endcase
        
    end // end of state machine 

endmodule 

module next_zr (
    input signed [26:0] zr_sqr, zi_sqr, cr,

    output signed [26:0] zr_next
);

    assign zr_next = zr_sqr - zi_sqr + cr;

endmodule

module next_zi (
    input signed [26:0] zr, zi, ci,

    output signed [26:0] zi_next 
);

    wire signed [26:0] mult_out;

    signed_mult _mult(
        .out(mult_out),
        .a(zr),
        .b(zi)
    );

    assign zi_next = (mult_out << 1) + ci; 

endmodule

module counter_to_color ( 
    input  signed [12:0] counter,
    input  signed [12:0] max_iterations,
    output  logic [7:0] color
);
    always_comb begin

        if (counter >= max_iterations) begin
            color = 8'b_000_000_00 ; // black
        end
        else if (counter >= (max_iterations >>> 1)) begin
            color = 8'b_011_001_00 ; // white
        end
        else if (counter >= (max_iterations >>> 2)) begin
            color = 8'b_011_001_00 ;
        end
        else if (counter >= (max_iterations >>> 3)) begin
            color = 8'b_101_010_01 ;
        end
        else if (counter >= (max_iterations >>> 4)) begin
            color = 8'b_011_001_01 ;
        end
        else if (counter >= (max_iterations >>> 5)) begin
            color = 8'b_001_001_01 ;
        end
        else if (counter >= (max_iterations >>> 6)) begin
            color = 8'b_011_010_10 ;
        end
        else if (counter >= (max_iterations >>> 7)) begin
            color = 8'b_010_100_10 ;
        end
        else if (counter >= (max_iterations >>> 8)) begin
            color = 8'b_010_100_10 ;
        end
        else begin
            color = 8'b_010_100_10 ;
        end

    end

endmodule