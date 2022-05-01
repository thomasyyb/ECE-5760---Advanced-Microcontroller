module coodinate(
    input clk, reset,
    input logic [] x,
    input logic [] y,
    input logic next,
    input logic done
);
    // we need K
    // x_j
    // l_j
    // L

    logic [#:0] K;
    logic [#:0] x_j [#:0];
    logic [#:0] l_j [#:0];
    logic [#:0] L;

    logic [] x_prev;
    logic [] y_prev;
    always_ff @(posedge clk) begin
        if(reset) begin
            K <= 0;
        end else begin
            if(K > 0) begin
                // I have valid x_j and l_j
            end
            K <= K + 1;
            L <= L + l_distance 
        end
    end 

    logic [#:0] l_diff;
    logic [#:0] x_diff;

    assign x_diff = x - x_prev;
    assign y_diff = 
endmodule 