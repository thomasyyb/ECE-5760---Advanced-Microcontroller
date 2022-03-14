module solver (
    input signed [26:0] ci,
    input signed [26:0] cr,
    input signed [12:0] in_max_iter,

    // output signed [26:0] iout,
    // output signed [26:0] rout,
    output signed [12:0] out_max_iter
); 

    // Compute modules

    reg signed [26:0] zr_reg, zi_reg, zr_sqr_reg, zi_sqr_reg;
    wire signed [26:0] zr_reg_in, zi_reg_in, zr_sqr_reg_in, zi_sqr_reg_in;

    wire signed [26:0] zr_next_in, zi_next_in; 

    next_zr _next_zr(
        .zr_sqr(zr_sqr_reg), 
        .zi_sqr(zi_sqr_reg),
        .cr(cr),
        .zr_next(zr_next_in)
    );

    next_zi _next_zi(
        .zr(zr_reg), 
        .zi(zi_reg), 
        .ci(ci),
        .zi_next(zi_next_in)
    );


    //======================================================================
    // State Update
    //======================================================================

    // STATE_ONE = 2'h0
    // STATE_TWO = 2'h1
    // STATE_THREE = 2'h2
    // STATE_FOUR = 2'h3

    reg [2:0] state_reg; 

    always @ (posedge clk) begin

        if (reset)
            state_reg <= 2'h0;
        else begin
            state_reg <= state_reg;

            case (state_reg)

                2'h0   : state_reg <= 2'h1;
                2'h1   : state_reg <= 2'h2;
                2'h2   : state_reg <= 2'h3; 
                2'h3   : state_reg <= 2'h2;
                default: state_reg <= 2'h0;

            endcase
        end
    end

     //======================================================================
    // State Outputs : combinational code
    //======================================================================

    always @ (*)
    begin

        //--------------------------------------------------------------------
        // STATE: STATE_ONE
        //--------------------------------------------------------------------

        if ( state_reg == 2'h0 ) begin
            zr_reg_in           = 0; 
            zi_reg_in           = 0;
            zr_sqr_reg_in       = 0; 
            zi_sqr_reg_in       = 0;
        end 

        //--------------------------------------------------------------------
        // STATE: STATE_READ_MEM
        //--------------------------------------------------------------------

        if ( state_reg == 2'h0 ) begin
            zr_reg_in           = 0; 
            zi_reg_in           = 0;
            zr_sqr_reg_in       = 0; 
            zi_sqr_reg_in       = 0;
        end 

        //--------------------------------------------------------------------
        // STATE: STATE_CALC (ready, calc, read request, write disable)
        //--------------------------------------------------------------------

        else if ( state_reg == 2'h2 ) begin

            if ( row_reg == 0 ) // bottom row 
            begin 
                u_center = bottom_reg; 
                u_down   = 18'b0;
                u_up     = q;          // output of u_n_m10k_32_18
                u_prev   = q_prev;   // output of u_prev_m10k_32_18
                u_left   = 18'b0;
                u_right  = 18'b0;
            end

            else if (row_reg == 31) // top row
            begin
                u_center = center_reg_in; 
                u_down   = down_reg_in;
                u_up     = 18'b0;          // output of u_n_m10k_32_18
                u_prev   = q_prev;   // output of u_prev_m10k_32_18
                u_left   = 18'b0;
                u_right  = 18'b0;
            end 

            else
            begin
                u_center = center_reg_in; 
                u_down   = down_reg_in;
                u_up     = q;          // output of u_n_m10k_32_18
                u_prev   = q_prev;   // output of u_prev_m10k_32_18
                u_left   = 18'b0;
                u_right  = 18'b0;   
            end

            // disable write
            we      = 1'b0;
            we_prev = 1'b0;     

            // read  
            row_reg_in = row_reg_in + 5'b1;      // TODO: overflow?
            read_address = row_reg_in + 5'b1;
            read_address_prev = row_reg_in;

        end 

        //--------------------------------------------------------------------
        // STATE: STATE_UPDATE
        //--------------------------------------------------------------------

        else if ( state_reg == 2'h3 ) begin

            if ( (row_reg - 1) == 0 ) // bottom row 
            begin 

                bottom_reg_in = out_reg;
                center_reg_in = u_up; 
                down_reg_in   = bottom_reg;

                // write to u_prev_m10k
                d_prev = bottom_reg;       // u_prev_m10k
                we_prev = 1'b1;            // write_en
                write_address_prev = row_reg - 5'b1; 

            end

            else if ( (row_reg - 1) == 31 ) // top row
            begin

                // write to u_n_m10k
                d = out_reg;
                we = 1'b1;
                write_address = row_reg;
                
                // write to u_prev_m10k
                d_prev = center_reg;
                we_prev = 1'b1;
                write_address_prev = row_reg;
            
            end 

            else
            begin

                center_reg_in = u_up;
                down_reg_in = center_reg;

                // write to u_n_m10k
                d = out_reg;
                we = 1'b1;
                write_address = row_reg - 1;
                
                // write to u_prev_m10k
                d_prev = center_reg;
                we_prev = 1'b1;
                write_address_prev = row_reg - 1;

            end

            // for simulation
            // read center node (15th node)
            read_address = 5'hF; 
            test_out = q;

        end

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
    )

    assign zi_next = (mult_out << 1) + ci; 

endmodule 