
module solver (

    input                clk, reset,
    input signed [26:0]  ci,
    input signed [26:0]  cr,
    input signed [12:0]  in_max_iter,

    // output signed [26:0] iout,
    // output signed [26:0] rout,
    output signed [12:0] out_iter,
    output reg           done_reg
); 

    // Compute modules

    reg signed [26:0]  zr_reg, zi_reg, zr_sqr_reg, zi_sqr_reg;
    reg                diverge_reg;
    reg         [12:0] counter_reg;

    wire signed [26:0] zr_reg_in, zi_reg_in, zr_sqr_in, zi_sqr_in;
    wire signed [26:0] z_magitude_sqr;
    wire               diverge_in, done_in;
    wire        [12:0] counter_in;

    wire [26:0] zr_next_wire, zi_next_wire, zr_sqr_wire, zi_sqr_wire;

    next_zr _next_zr(
        .zr_sqr(zr_sqr_reg), 
        .zi_sqr(zi_sqr_reg),
        .cr(cr),
        .zr_next(zr_next_wire)
    );

    next_zi _next_zi(
        .zr(zr_reg), 
        .zi(zi_reg), 
        .ci(ci),
        .zi_next(zi_next_wire)
    );

    signed_mult _zr_sqr_mult(
        .out(zr_sqr_wire),
        .a(zr_next_wire),
        .b(zr_next_wire)
    );    

    signed_mult _zi_sqr_mult(
        .out(zi_sqr_wire),
        .a(zi_next_wire),
        .b(zi_next_wire)
    );

    assign z_magitude_sqr = zr_sqr_wire + zi_sqr_wire;

    assign out_iter = counter_reg;

    // always @ (posedge clk) begin
    //     zr_reg <= zr_reg_in;
    //     zi_reg <= zi_reg_in;
    //     zr_sqr_reg <= zr_sqr_in;
    //     zi_sqr_reg <= zi_sqr_in;
    //     diverge_reg <= diverge_in;
    //     counter_reg <= counter_in;
    //     done_reg <= done_in;
    // end

    //======================================================================
    // State Update
    //======================================================================

    // Only two states/one cycle per iterations for three multipliers
    // STATE_INIT = 2'h0
    // STATE_ONE = 2'h1
    
    reg [2:0] state_reg; 

    always @ (posedge clk) begin

        if (reset)
            state_reg <= 2'h0;
        else begin
            state_reg <= state_reg;

            case (state_reg)

                2'h0   : state_reg <= 2'h1;
                2'h1   : 
                    if (counter_reg > in_max_iter || diverge_reg) 
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

    always @ (posedge clk) begin
  
        //--------------------------------------------------------------------
        // STATE: STATE_INIT
        //--------------------------------------------------------------------

        if ( state_reg == 2'h0 ) begin
            zr_reg       = 0; 
            zi_reg       = 0;
            zr_sqr_reg   = 0; 
            zi_sqr_reg   = 0;
            counter_reg  = 0; 
            diverge_reg  = 0; 
            done_reg     = 0; 
        end

        //--------------------------------------------------------------------
        // STATE: STATE_ONE
        //--------------------------------------------------------------------

        else if ( state_reg == 2'h1 ) begin
            // zr_reg_in ... are directly outputs of multipliers so no assignment here
            counter_reg = counter_reg + 1;
            done_reg    = 0; 
            diverge_reg = ( zr_reg >= 2 || zi_reg >=2 || z_magitude_sqr >= 4);
            zr_reg = zr_next_wire;
            zi_reg = zi_next_wire;
        end

        //--------------------------------------------------------------------
        // STATE: STATE_TWO
        //--------------------------------------------------------------------

        else if ( state_reg == 2'h2 ) begin 
            zr_reg       = 0; 
            zi_reg       = 0;
            zr_sqr_reg       = 0; 
            zi_sqr_reg       = 0;
            counter_reg      = counter_reg;
            diverge_reg      = diverge_reg; 
            done_reg         = 1;
        end

    end // end of state machine 

    // always @(posedge clk) begin
    //     if(reset) begin
    //         zr_reg <= 0;
    //         zr_reg <= 0;
    //     end else begin

    //     end
    // end
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