
// v2 does not hardwire left right inputs to the comput module 
// Introduces enable signal in compute module to prevent unwanted computation outputs 
// v3 uses the M10K initializer module
module string_v3  (
	input wire clk, reset,
	input wire signed [17:0] left_wire, right_wire,
	output wire signed[17:0] neighbor_in,

	// signals for the M10K initiailizer
	input init_en,
	input [17:0] pio_d,
	input [8:0] pio_wr_addr,
	input pio_wr_en,

	input allDone,
	// outputs to communicate memory status 
	output done, // do I need the ready signal?
	output reg [17:0] center,
	input fifo_empty,
	input [9:0] pio_height,
	input [17:0] rho_eff
 );
	wire [8:0] CENTER = (pio_height >> 1 );
// connections 
	wire signed [17:0]  up_mux_in, down_mux_in, mid_mux_in;
	reg signed [17:0] down_reg, mid_reg, bot_reg;
	wire signed [17:0] node_out;

	reg [8:0] counter;

	reg signed [17:0]  n_curr_d, n_prev_d;
	wire signed [17:0] n_curr_q, n_prev_q;
	reg [8:0] n_curr_wr_addr, n_curr_rd_addr, n_prev_wr_addr, n_prev_rd_addr;
	reg n_curr_we, n_prev_we;

	// ready & done signals 
	wire m_curr_done;
	wire m_prev_done;
	assign done = m_curr_done & m_prev_done;

	M10K_initializer m_curr (
		.clk(clk),
		.reset(reset), 
		.init_en(init_en),
		.pio_d(pio_d),
		.pio_wr_addr(pio_wr_addr),
		.pio_wr_en(pio_wr_en),
		//compute node inputs 
		.rd_addr_cn(n_curr_rd_addr),
		.wr_addr_cn(n_curr_wr_addr),
		.we_cn(n_curr_we),
		.d_cn(n_curr_d),
		.q_cn(n_curr_q),
		// status signals
		.done(m_curr_done),
		// height of drum 
		.pio_height(pio_height)

	);

	M10K_initializer m_prev (
		.clk(clk),
		.reset(reset),
		.init_en(init_en),
		.pio_d(pio_d),
		.pio_wr_addr(pio_wr_addr),
		.pio_wr_en(pio_wr_en),
		//compute node inputs 
		.rd_addr_cn(n_prev_rd_addr),
		.wr_addr_cn(n_prev_wr_addr),
		.we_cn(n_prev_we),
		.d_cn(n_prev_d),
		.q_cn(n_prev_q),
		// status signals
		.done(m_prev_done),
		// height of drum 
		.pio_height(pio_height)

	);

	// define computation module
	assign mid_mux_in = (counter == 0) ? bot_reg : mid_reg;
	assign up_mux_in = (counter == pio_height-1) ? 0 : n_curr_q; 
	assign down_mux_in = (counter == 0) ? 0 : down_reg; 
	assign neighbor_in = mid_mux_in;

	reg computeEn;
	SingleNodeNonlinear node ( .clock(clk), 
								.reset(reset),
								.en(computeEn),
								.middle_init(mid_mux_in),
								.middle(mid_mux_in),  
								.middle_prev(n_prev_q),
								.middle_out(node_out), //output
								.left(left_wire),
								.right(right_wire),
								.up(up_mux_in),
								.down(down_mux_in),
								.rho_eff(rho_eff)
	);

	// state machine (starts after initialization stage of M10K initializer)
	reg [2:0] stage;	
	always @(posedge clk) begin
		if(reset | !allDone) begin // waits for done signal before beginning this state machien 
			stage <= 3'b0;
			center <= 0;
			down_reg <= 0;
			mid_reg <= 0;
			bot_reg <= 0;
			counter <= 0;
			n_curr_d <= 0;
			n_prev_d <= 0;
			n_curr_wr_addr <= 0;
			n_curr_rd_addr <= 0;
			n_prev_wr_addr <= 0;
			n_prev_rd_addr <= 0;
			n_curr_we <= 0;
			n_prev_we <= 0;
			computeEn <= 0;
			if(pio_wr_addr == CENTER && pio_wr_en) begin
				center <= pio_d;
			end
		end else if (fifo_empty) begin
			if(stage == 0) begin
				n_curr_we <= 0;
				n_prev_we <= 0;
				n_curr_rd_addr <= counter + 1;
				n_prev_rd_addr <= counter;
				stage <= 1;
			end
			if(stage == 1) begin 
				stage <= 2;
			end
			if(stage == 2) begin // memory returns q's
				stage <= 3;
				computeEn <= 1;
			end
			if(stage == 3) begin // node is computing
				computeEn <= 0;
				stage <= 4;
			end
			if(stage == 4) begin // node done computing, transtion stage, moving values to en
				if (counter == 0) begin
					// special case for bottom row
					mid_reg <= up_mux_in; 
					bot_reg <= node_out;
					down_reg <= bot_reg; 
					// memory 
					n_prev_d  <= bot_reg;
					n_prev_we <= 1;
					n_prev_wr_addr <= counter; 
				end 
				else if (counter == pio_height-1) begin
					n_curr_we <= 1;
					n_curr_wr_addr <= counter; 
					n_curr_d <= node_out;
					
					n_prev_we <= 1;
					n_prev_wr_addr <= counter; 
					n_prev_d <= mid_reg; // check cycle
				end else begin
					// newer M10k
					n_curr_we <= 1;
					n_curr_wr_addr <= counter; 
					n_curr_d <= node_out; // supposedly writes new computed value to the newer M10k
					
					mid_reg <= up_mux_in; 
					down_reg <= mid_reg;

					// older M10k
					n_prev_we <= 1;
					n_prev_wr_addr <= counter;
					n_prev_d <= mid_reg; // this supposedly writes mid_reg value to prev M10k	

					if(counter == CENTER) 
						center <= node_out;
					
				end				
				counter <= (counter==pio_height-1) ? 0 : (counter + 1); 
				stage <= 0;
			end
		end
		
	
	end 
endmodule

// `timescale 1ns/1ns
// module string_v3_tb();
// 	reg clk, reset;
// 	reg signed [17:0] left_wire, right_wire;
// 	wire signed[17:0] neighbor_in; // output

// 	// signals for the M10K initiailizer
// 	reg init_en;
// 	reg [17:0] pio_d;
// 	reg [8:0] pio_wr_addr;
// 	reg pio_wr_en;

// 	// outputs to communicate memory status 
// 	wire done;  //output
// 	wire [17:0] center;

// 	//Initialize clocks
// 	initial begin
// 		clk = 1'b0;
// 		left_wire = 0;
// 		right_wire = 0;
// 		init_en <= 1;
// 	end
	
// 	//Toggle the clocks
// 	always begin
// 		#10
// 		clk = !clk;
// 	end

// 	//Intialize and drive signals
// 	initial begin
// 		reset  = 1'b0;
// 		#10 
// 		reset  = 1'b1;
// 		#30
// 		reset  = 1'b0;
// 	end

// 	// string_v3 DUT (.clk(clk), .reset(reset), .left_wire(left_wire), .right_wire(right_wire), .neighbor_in(neighbor_in));

// 	string_v3 #(33) DUT (
// 		.clk(clk),
// 		.reset(reset),
// 		.left_wire(left_wire),
// 		.right_wire(right_wire),
// 		.neighbor_in(neighbor_in),
// 		.init_en(init_en),
// 		.pio_d(pio_d),
// 		.pio_wr_addr(pio_wr_addr),
// 		.pio_wr_en(pio_wr_en),
// 		.allDone(1'b1),
// 		.done(done),
// 		.center(center)
// 	);
// 	// initialize memory 
// 	reg signed [17:0] mem [32:0];
// 	initial begin
// 		$readmemh("mem_init.txt", mem);
// 	end

//     always @(posedge clk)begin //update the next write values
//         if(reset) begin
//             init_en = 1;
//             pio_wr_en = 1;
//             pio_d = mem[0]; 
//             pio_wr_addr = 0;
//         end
//         if(!reset & pio_wr_addr < 33-1) begin
//             pio_wr_en <= 1;
//             pio_d <= mem[pio_wr_addr + 1];
//             pio_wr_addr <= pio_wr_addr + 1;
//         end 

               
//     end
	
// 	// reg stalled;
//     // always @(posedge clk) begin //update the next write values
//     //     if(reset) begin
//     //         pio_d <= mem[pio_wr_addr];
//     //         pio_wr_addr <= 0;
// 	// 		stalled <= 0;
//     //     end
// 	// 	if(!reset) 
// 	// 		stalled <= 1;
//     //     if(!ready & !reset & !done & stalled) begin
			
//     //         pio_d <= mem[pio_wr_addr];
// 	// 		pio_wr_addr <= pio_wr_addr + 1;

//     //     end  
//     // end
// endmodule 

