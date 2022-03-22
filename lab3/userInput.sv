module userInput (
    input logic clk, reset, in,
    output logic out
);
    logic ps, ns;
    logic out_f1, out_f2;
    always_ff @(posedge clk) begin
        if(reset) 
            ps <= 0;
        else 
            ps <= ns;

    end

    always_comb begin
        case(ps)
            1'b0: ns = (in)  ? 1'b1 : 1'b0;
            1'b1: ns = (~in) ? 1'b0 : 1'b1;
        endcase
    end 

    assign out_f1 = (ps == 0) && (in);
    // assign out = out_f2;

    always_ff @(posedge clk) begin
        if(reset) begin
            out_f2 <= 0;
            out <= 0;
        end else begin
            out <= out_f2;
            out_f2 <= out_f1;
        end

    end
endmodule

module userInput_tb();
    logic clk, reset, in; 
    logic out; 

	initial begin
		clk <= 0;
		forever #(50) clk <= ~clk;
	end

    userInput DUT (.*);

    initial begin 
        reset <= 1;  in <= 0;               @(posedge clk);
        reset <= 0;                 @(posedge clk);
                                    @(posedge clk);
        in <= 1;              @(posedge clk);
            @(posedge clk);
          @(posedge clk);
           @(posedge clk);
        @(posedge clk);

        $stop;


    end
endmodule 