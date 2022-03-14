// This module generates all the M10K blocks and initialized their values 
// (given from arm via PIO). 2-state state machine (initialize , ready)

module M10K_initializer  (
    input clk, reset, // pio_init from arm is reset 
 // initializing ports   
    input init_en,
    input [17:0] pio_d,
    input [8:0] pio_wr_addr,
    input pio_wr_en,

// signals for normal op
    input [8:0] rd_addr_cn,
    input [8:0] wr_addr_cn, 
    input we_cn,
    input [17:0] d_cn,
    output [17:0] q_cn,
// outputs to communicate memory status 
    output reg done,
    input [9:0] pio_height
);

// the muxed version of memory signals 
    wire [17:0] q;
    wire [17:0] d;
    wire [8:0] wr_addr;
    wire [8:0] rd_addr;
    wire we;

   
    // mux logic for initialize vs normal operation
    assign d = (done) ? d_cn : pio_d;
    assign wr_addr = (done) ? wr_addr_cn : pio_wr_addr;
    assign rd_addr = rd_addr_cn;
    assign we = (done) ? we_cn : (pio_wr_en && init_en);
    
    assign q_cn = q;


    M10K_512_18 m ( .q(q),
                    .d(d),
                    .write_address(wr_addr),
                    .read_address(rd_addr),
                    .we(we),
                    .clk(clk)
            );

    reg [1:0] stage;
    // this state machine operates under the assumption that arm provides incremental address 
    always @(posedge clk) begin
        if(reset) begin
            stage <= 0;
            done <= 0;
        end

        else if(!reset && init_en && stage == 0 && pio_wr_addr < pio_height && pio_wr_en) begin 
            if(pio_wr_addr == pio_height-1) 
                stage <= 1;
        end
        
        else if(stage == 1) begin // Memory is filled, stays in this stage forever
            done <= 1;
            stage <= 1;
        end

    end
endmodule 

// module M10K_initializer_tb ();
//     reg clk, reset; // pio_init from arm is reset 
//  // initializing ports   
//     reg init_en;
//     reg [17:0] pio_d;
//     reg [8:0] pio_wr_addr;
//     reg pio_wr_en;

// // signals for normal op
//     reg [8:0] rd_addr_cn;
//     reg [8:0] wr_addr_cn; 
//     reg we_cn;
//     reg [17:0] d_cn;
//     wire [17:0] q_cn;
// // outputs to communicate memory status 
//     reg done;


//     M10K_initializer DUT (.*);

//     //Initialize clocks
// 	initial begin
// 		clk = 1'b0;
//         init_en = 1;
//         pio_wr_en = 0;
//         pio_d = 0; 
//         pio_wr_addr = 0;
// 	end
	
//     // initial reset 
//     initial begin
//         reset = 1'b0;
//         #10 
//         reset = 1'b1;
//         #30
//         reset = 1'b0;
//     end

// 	//Toggle the clocks
// 	always begin
// 		#10
// 		clk = !clk;
// 	end



    
//     always @(posedge clk)begin //update the next write values
//         if(reset) begin
//             init_en = 1;
//             pio_wr_en = 0;
//             pio_d = 0; 
//             pio_wr_addr = 0;
//         end
//         if(!reset & pio_wr_addr < 31-1) begin
//             pio_wr_en <= 1;
//             pio_d <= pio_d + 1;
//             pio_wr_addr <= pio_wr_addr + 1;
//         end 

//         if(done) begin
//             pio_wr_en <= 0;
//             rd_addr_cn <= 29;
//             #40
//             wr_addr_cn <= 30;
//             we_cn <= 1; 
//             d_cn <= 17; 

//         end        
//     end
// endmodule 
