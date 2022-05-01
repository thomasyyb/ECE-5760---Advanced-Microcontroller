module drum  #(parameter WIDTH = 173) (
    input clk, reset,

	// signals for the M10K initiailizer
    input [17:0] pio_d,
	input [8:0] pio_wr_addr,
    input pio_wr_en,
    input [7:0] pio_string_init,

    //pio inputs for width and height
    input [9:0] pio_height,
    output [17:0] center_node,
    output wire allDone,
    input fifo_empty
);


    wire signed [17:0] neighbor_in [WIDTH-1:0];
    wire [WIDTH-1:0] done; 


    wire [17:0] center [WIDTH-1:0];
    wire signed [17:0] rho_init, rho_eff, center_pow2;
    assign center_node = center[ ( WIDTH>>1 ) ];

    assign allDone = &done;

    generate
        genvar i;
        for(i = 0; i < WIDTH; i=i+1) begin: d

            string_v3 s (
                .clk(clk),
                .reset(reset), // should also be controlled by the C program reset
                .left_wire((i == 0) ? 18'b0 : neighbor_in[i-1]),
                .right_wire((i == WIDTH-1) ? 18'b0 : neighbor_in[i+1]),
                .neighbor_in(neighbor_in[i]),
                .init_en((i == pio_string_init)),
                .pio_d(pio_d),
                .pio_wr_addr(pio_wr_addr),
                .pio_wr_en(pio_wr_en),
                .allDone(allDone),
                .done(done[i]),
                .center(center[i]), // else open port?
                // width and height of drum
                .fifo_empty(fifo_empty),
                .pio_height(pio_height),
                .rho_eff(rho_eff)
            );
        end
    endgenerate

    signed_mult m1 (.out(center_pow2), .a(center_node >> 4), .b(center_node >> 4));
    assign rho_init = {1'b0, 17'h08000};  // 0.25
    assign rho_eff = ( 18'h0FAE1 > (center_pow2 + rho_init) ) ? (center_pow2 + rho_init) : 18'h0FAE1 ;  // 0.49


endmodule 

// module drum_tb ();
//     reg clk, reset;
        
//     reg [17:0] pio_d;
// 	reg [8:0] pio_wr_addr;
//     reg [9:0]counter_addr;
//     reg pio_wr_en;
//     reg [7:0] pio_string_init;
//     reg [9:0] pio_height;
//     wire allDone;

//     parameter WIDTH = 31;
	
// 	//Toggle the clocks
// 	always begin
// 		#10
// 		clk = !clk;
// 	end

// 	//Intialize and drive signals
// 	initial begin
//         clk = 1'b0;
// 		reset  = 1'b0;
// 		#10 
// 		reset  = 1'b1;
// 		#30
// 		reset  = 1'b0;
// 	end

//     drum DUT (.*);

// 	// initialize memory 
// 	reg signed [17:0] mem [960:0];
// 	initial begin
// 		$readmemh("2d_mem.txt", mem);
// 	end
//     // reg stalled0, stalled1, stalled2, stalled3;
//     // reg [1:0] ready_counter;
    
//     // initial begin
//     //     ready_counter = 0;
//     // end
    

//     // always @(posedge clk) begin //update the next write values
//     //     if(reset) begin
//     //         pio_d <= mem[counter_addr];
//     //         pio_wr_addr <= 0;
//     //         counter_addr <= 0;

//     //         ready_counter <= 0;
//     //     end

//     //     if(!reset & !allDone) begin 
//     //         if(pio_wr_addr + 1 == 33) begin
//     //             // pio_d <= mem[0];
// 	// 		    pio_wr_addr <= 0;
//     //             stalled0 <= 0;
//     //             stalled1 <= 0;
//     //             stalled2 <= 0;
//     //             stalled3 <= 0;

//     //         end else begin
//     //             // pio_d <= mem[pio_wr_addr + 1];
//     //             pio_wr_addr <= pio_wr_addr + 1;
//     //         end      
//     //         pio_d <= mem[counter_addr+1];
//     //         counter_addr <= counter_addr + 1;

//     //     end  
//     //     ready_counter <= ready_counter + 1;
//     // end

//     always @(posedge clk)begin //update the next write values
//         if(reset) begin
//             pio_string_init = 0;
//             pio_wr_en = 1;
//             pio_d = mem[counter_addr]; 
//             pio_wr_addr = 0;
//             counter_addr = 0;
//             pio_height = 31;
//         end

//         if(!reset & pio_string_init < WIDTH) begin
//             pio_wr_en <= 1;
//             pio_d <= mem[counter_addr + 1];
//             counter_addr <= counter_addr + 1;
//             if(pio_wr_addr + 1 == WIDTH) begin
//                 pio_wr_addr <= 0;
//                 pio_string_init <= pio_string_init + 1;
//             end
//             else begin
//                 pio_wr_addr <= pio_wr_addr + 1;
//             end
            
//         end  

               
//     end
// endmodule 