

module DE1_SoC_Computer (
	////////////////////////////////////
	// FPGA Pins
	////////////////////////////////////

	// Clock pins
	CLOCK_50,
	CLOCK2_50,
	CLOCK3_50,
	CLOCK4_50,

	// ADC
	ADC_CS_N,
	ADC_DIN,
	ADC_DOUT,
	ADC_SCLK,

	// Audio
	AUD_ADCDAT,
	AUD_ADCLRCK,
	AUD_BCLK,
	AUD_DACDAT,
	AUD_DACLRCK,
	AUD_XCK,

	// SDRAM
	DRAM_ADDR,
	DRAM_BA,
	DRAM_CAS_N,
	DRAM_CKE,
	DRAM_CLK,
	DRAM_CS_N,
	DRAM_DQ,
	DRAM_LDQM,
	DRAM_RAS_N,
	DRAM_UDQM,
	DRAM_WE_N,

	// I2C Bus for Configuration of the Audio and Video-In Chips
	FPGA_I2C_SCLK,
	FPGA_I2C_SDAT,

	// 40-Pin Headers
	GPIO_0,
	GPIO_1,
	
	// Seven Segment Displays
	HEX0,
	HEX1,
	HEX2,
	HEX3,
	HEX4,
	HEX5,

	// IR
	IRDA_RXD,
	IRDA_TXD,

	// Pushbuttons
	KEY,

	// LEDs
	LEDR,

	// PS2 Ports
	PS2_CLK,
	PS2_DAT,
	
	PS2_CLK2,
	PS2_DAT2,

	// Slider Switches
	SW,

	// Video-In
	TD_CLK27,
	TD_DATA,
	TD_HS,
	TD_RESET_N,
	TD_VS,

	// VGA
	VGA_B,
	VGA_BLANK_N,
	VGA_CLK,
	VGA_G,
	VGA_HS,
	VGA_R,
	VGA_SYNC_N,
	VGA_VS,

	////////////////////////////////////
	// HPS Pins
	////////////////////////////////////
	
	// DDR3 SDRAM
	HPS_DDR3_ADDR,
	HPS_DDR3_BA,
	HPS_DDR3_CAS_N,
	HPS_DDR3_CKE,
	HPS_DDR3_CK_N,
	HPS_DDR3_CK_P,
	HPS_DDR3_CS_N,
	HPS_DDR3_DM,
	HPS_DDR3_DQ,
	HPS_DDR3_DQS_N,
	HPS_DDR3_DQS_P,
	HPS_DDR3_ODT,
	HPS_DDR3_RAS_N,
	HPS_DDR3_RESET_N,
	HPS_DDR3_RZQ,
	HPS_DDR3_WE_N,

	// Ethernet
	HPS_ENET_GTX_CLK,
	HPS_ENET_INT_N,
	HPS_ENET_MDC,
	HPS_ENET_MDIO,
	HPS_ENET_RX_CLK,
	HPS_ENET_RX_DATA,
	HPS_ENET_RX_DV,
	HPS_ENET_TX_DATA,
	HPS_ENET_TX_EN,

	// Flash
	HPS_FLASH_DATA,
	HPS_FLASH_DCLK,
	HPS_FLASH_NCSO,

	// Accelerometer
	HPS_GSENSOR_INT,
		
	// General Purpose I/O
	HPS_GPIO,
		
	// I2C
	HPS_I2C_CONTROL,
	HPS_I2C1_SCLK,
	HPS_I2C1_SDAT,
	HPS_I2C2_SCLK,
	HPS_I2C2_SDAT,

	// Pushbutton
	HPS_KEY,

	// LED
	HPS_LED,
		
	// SD Card
	HPS_SD_CLK,
	HPS_SD_CMD,
	HPS_SD_DATA,

	// SPI
	HPS_SPIM_CLK,
	HPS_SPIM_MISO,
	HPS_SPIM_MOSI,
	HPS_SPIM_SS,

	// UART
	HPS_UART_RX,
	HPS_UART_TX,

	// USB
	HPS_CONV_USB_N,
	HPS_USB_CLKOUT,
	HPS_USB_DATA,
	HPS_USB_DIR,
	HPS_USB_NXT,
	HPS_USB_STP
);

//=======================================================
//  PARAMETER declarations
//=======================================================


//=======================================================
//  PORT declarations
//=======================================================

////////////////////////////////////
// FPGA Pins
////////////////////////////////////

// Clock pins
input						CLOCK_50;
input						CLOCK2_50;
input						CLOCK3_50;
input						CLOCK4_50;

// ADC
inout						ADC_CS_N;
output					ADC_DIN;
input						ADC_DOUT;
output					ADC_SCLK;

// Audio
input						AUD_ADCDAT;
inout						AUD_ADCLRCK;
inout						AUD_BCLK;
output					AUD_DACDAT;
inout						AUD_DACLRCK;
output					AUD_XCK;

// SDRAM
output 		[12: 0]	DRAM_ADDR;
output		[ 1: 0]	DRAM_BA;
output					DRAM_CAS_N;
output					DRAM_CKE;
output					DRAM_CLK;
output					DRAM_CS_N;
inout			[15: 0]	DRAM_DQ;
output					DRAM_LDQM;
output					DRAM_RAS_N;
output					DRAM_UDQM;
output					DRAM_WE_N;

// I2C Bus for Configuration of the Audio and Video-In Chips
output					FPGA_I2C_SCLK;
inout						FPGA_I2C_SDAT;

// 40-pin headers
inout			[35: 0]	GPIO_0;
inout			[35: 0]	GPIO_1;

// Seven Segment Displays
output		[ 6: 0]	HEX0;
output		[ 6: 0]	HEX1;
output		[ 6: 0]	HEX2;
output		[ 6: 0]	HEX3;
output		[ 6: 0]	HEX4;
output		[ 6: 0]	HEX5;

// IR
input						IRDA_RXD;
output					IRDA_TXD;

// Pushbuttons
input			[ 3: 0]	KEY;

// LEDs
output		[ 9: 0]	LEDR;

// PS2 Ports
inout						PS2_CLK;
inout						PS2_DAT;

inout						PS2_CLK2;
inout						PS2_DAT2;

// Slider Switches
input			[ 9: 0]	SW;

// Video-In
input						TD_CLK27;
input			[ 7: 0]	TD_DATA;
input						TD_HS;
output					TD_RESET_N;
input						TD_VS;

// VGA
output		[ 7: 0]	VGA_B;
output					VGA_BLANK_N;
output					VGA_CLK;
output		[ 7: 0]	VGA_G;
output					VGA_HS;
output		[ 7: 0]	VGA_R;
output					VGA_SYNC_N;
output					VGA_VS;



////////////////////////////////////
// HPS Pins
////////////////////////////////////
	
// DDR3 SDRAM
output		[14: 0]	HPS_DDR3_ADDR;
output		[ 2: 0]  HPS_DDR3_BA;
output					HPS_DDR3_CAS_N;
output					HPS_DDR3_CKE;
output					HPS_DDR3_CK_N;
output					HPS_DDR3_CK_P;
output					HPS_DDR3_CS_N;
output		[ 3: 0]	HPS_DDR3_DM;
inout			[31: 0]	HPS_DDR3_DQ;
inout			[ 3: 0]	HPS_DDR3_DQS_N;
inout			[ 3: 0]	HPS_DDR3_DQS_P;
output					HPS_DDR3_ODT;
output					HPS_DDR3_RAS_N;
output					HPS_DDR3_RESET_N;
input						HPS_DDR3_RZQ;
output					HPS_DDR3_WE_N;

// Ethernet
output					HPS_ENET_GTX_CLK;
inout						HPS_ENET_INT_N;
output					HPS_ENET_MDC;
inout						HPS_ENET_MDIO;
input						HPS_ENET_RX_CLK;
input			[ 3: 0]	HPS_ENET_RX_DATA;
input						HPS_ENET_RX_DV;
output		[ 3: 0]	HPS_ENET_TX_DATA;
output					HPS_ENET_TX_EN;

// Flash
inout			[ 3: 0]	HPS_FLASH_DATA;
output					HPS_FLASH_DCLK;
output					HPS_FLASH_NCSO;

// Accelerometer
inout						HPS_GSENSOR_INT;

// General Purpose I/O
inout			[ 1: 0]	HPS_GPIO;

// I2C
inout						HPS_I2C_CONTROL;
inout						HPS_I2C1_SCLK;
inout						HPS_I2C1_SDAT;
inout						HPS_I2C2_SCLK;
inout						HPS_I2C2_SDAT;

// Pushbutton
inout						HPS_KEY;

// LED
inout						HPS_LED;

// SD Card
output					HPS_SD_CLK;
inout						HPS_SD_CMD;
inout			[ 3: 0]	HPS_SD_DATA;

// SPI
output					HPS_SPIM_CLK;
input						HPS_SPIM_MISO;
output					HPS_SPIM_MOSI;
inout						HPS_SPIM_SS;

// UART
input						HPS_UART_RX;
output					HPS_UART_TX;

// USB
inout						HPS_CONV_USB_N;
input						HPS_USB_CLKOUT;
inout			[ 7: 0]	HPS_USB_DATA;
input						HPS_USB_DIR;
input						HPS_USB_NXT;
output					HPS_USB_STP;

//=======================================================
//  REG/WIRE declarations
//=======================================================

wire			[15: 0]	hex3_hex0;
wire			[15: 0]	hex5_hex4;

//assign HEX0 = ~hex3_hex0[ 6: 0]; // hex3_hex0[ 6: 0]; 
//assign HEX1 = ~hex3_hex0[14: 8];
//assign HEX2 = ~hex3_hex0[22:16];
//assign HEX3 = ~hex3_hex0[30:24];
assign HEX4 = 7'b1111111;
assign HEX5 = 7'b1111111;

HexDigit Digit0(HEX0, max_iterations_decimal_display[0]);
HexDigit Digit1(HEX1, max_iterations_decimal_display[1]);
HexDigit Digit2(HEX2, max_iterations_decimal_display[2]);
HexDigit Digit3(HEX3, max_iterations_decimal_display[3]);
// HexDigit Digit4(HEX4, max_iterations[19:16]);
// HexDigit Digit5(HEX5, max_iterations[23:20]);

// VGA clock and reset lines
wire vga_pll_lock ;
wire vga_pll ;
reg  vga_reset ;

// M10k memory control and data
parameter num_x = 4;
parameter num_y = 4;
parameter num_solvers = 16;
parameter log_num_x = 2;
parameter log_num_y = 2;

wire 		[7:0] 	M10k_out [num_solvers-1:0];
reg 		[7:0] 	write_data [num_solvers-1:0];
reg 		[18:0] 	write_address ;
reg 		[18:0] 	read_address ;
reg 				write_enable ;

// M10k memory clock
wire 				M10k_pll ;
wire 				M10k_pll_locked ;
 
// Memory writing control registers
reg 		[2:0] 	arbiter_state ;
reg			[9:0]	x_counter, y_counter; 
wire 		[9:0] 	x_coord [num_x-1:0];
wire 		[9:0] 	y_coord [num_y-1:0];

// Wires for connecting VGA driver to memory
wire 		[9:0]	next_x ;
wire 		[9:0] 	next_y ;

reg 		[31:0]  timer ; // may need to throttle write-rate
reg flag;  // timer_flag;
reg [31:0] signal_tap [1:0];

wire stuck_flag;
reg stuck_reg;
assign stuck_flag = signal_tap[1] > max_iterations;
assign GPIO_0[1] = stuck_flag;
assign GPIO_0[2] = stuck_reg;
assign GPIO_0[0] = flag;

integer k;
wire allDone = &solver_done  ;
always@(posedge M10k_pll) begin
	
	for (k = 0; k < num_solvers; k = k + 1) begin

		// Zero everything in reset
		if (~KEY[0]) begin  
			arbiter_state <= 3'd_0 ;
			vga_reset <= 1'b_1 ;
			solver_reset <= 1 ;
			write_data[k] <= 0;
			write_address <= 0;
			write_enable <= 0;

			// Oscilloscope the calculation time
			flag <= 0;
			signal_tap[0] <= 0;
			signal_tap[1] <= 0;
			stuck_reg	  <= 0;
		end 

		// Otherwiser render the mandelbrot set
		else begin
			
			// This state happens at the beginning of each frame
			if (arbiter_state == 3'd_0) begin
				vga_reset <= 1'b_0 ;
				solver_reset <= 1; 
				arbiter_state <= 3'd_1;
				x_counter <= 10'd_0 ; 
				y_counter <= 10'd_0 ;  
				flag <= ~flag;
				signal_tap[0] <= 0;
				signal_tap[1] <= 0;
				stuck_reg <= 1;
			end
			
			else if (arbiter_state == 3'd_1) begin
				// we will start the solver in the next state 
				solver_reset <= 1;
				// address update
				if( x_counter < (640/num_x-1) ) begin
					x_counter <= x_counter + 1 ;
					stuck_reg <= 0;
				end else begin
					stuck_reg <= 1;
					y_counter <= y_counter + 1; 
					x_counter <= 0;
				end
				arbiter_state <= 3'd2 ;
				signal_tap[1] <= 0;
			end

			// We need one more state for the solver_reset to actually reset the done signal
			// or we will just jump through the current pixel
			else if (arbiter_state == 3'd_2) begin
				solver_reset <= 0;
				arbiter_state <= 3'd3 ;
			end

			// Wait for all the solvers to finish
			else if (arbiter_state == 3'd_3) begin
				if (!allDone) begin
					arbiter_state <= 3'd3 ;
					signal_tap[0] <= signal_tap[0] + 1;
					signal_tap[1] <= signal_tap[1] + 1;
				end
				else begin 
					arbiter_state <= 3'd4 ;
				end
			end

			// Write the output colors to M10K blocks
			else if (arbiter_state == 3'd_4) begin
				write_enable <= 1'b_1 ;
				write_address <= ((640/num_x-1) * y_counter) + x_counter ;
				write_data[k] <= color_out[k];
				arbiter_state <= 3'd_5 ;
			end

			// Write finish! Decide whether to reset the address or go on to the next one
			else if (arbiter_state == 3'd_5) begin
				write_enable <= 1'b_0 ;
				if (x_counter>=(640/num_x-1) && y_counter>=(480/num_y-1)) begin
					// If we reach the last pixel, we reset the counter by going to the stage 0
					// timer_flag <= 1;  // set flag
					arbiter_state <= 3'd_0 ;
				end	else begin
					// Otherwise, we move on to the next pixel
					arbiter_state  <= 3'd_1 ;
				end
			end

			else begin // default 
				vga_reset 	<= vga_reset 		;
				solver_reset 	<= solver_reset 	;
				arbiter_state 	<= 3'd3			;
				x_counter 	<= x_counter 		;
				y_counter 	<= y_counter 		;
				write_enable	<= write_enable		;
				stuck_reg	<= stuck_reg		;
			end 

			// if(out_1 | out_2 | out_3) begin
			// 	timer_flag <= 0;
			// 	timer <= 0;
			// end 

			// if(!timer_flag)
			// 	timer <= timer + 1; 
			// else
			// 	timer <= timer;

		end 

	end 

end

// mux stuff
// assign x_coord[0] = x_counter;
// assign x_coord[1] = x_counter;
// assign y_coord[0] = y_counter << 1;
// assign y_coord[1] = (y_counter << 1) + 1;

// counter = 0
// y_coor  = 0, 1, 2, 3 
// counter = 1
// y_coor  = 4, 5, 6, 7
// counter = 119
// y_coor  = 476, 477, 478, 479

// signals 
//assign read_address = (19'd_640*next_y[9:1]) + next_x
//wire [7:0] M10K_out [1:0]
wire [26:0] center_x [num_solvers-1:0];
wire [26:0] center_y [num_solvers-1:0];

// assign x_coord[i] = ( x_counter << log_num_x ) + i;
// assign y_coord[i] = ( y_counter << log_num_y ) + i;

generate
	genvar i, j;
	for(i = 0; i < num_x; i = i + 1) begin: x_name
		assign x_coord[i] = ( x_counter << log_num_x ) + i;
	end
	for(i = 0; i < num_y; i = i + 1) begin: y_name
		assign y_coord[i] = ( y_counter << log_num_y ) + i;
	end
	for(i = 0; i < num_y; i = i + 1) begin: bundle_y
		for(j = 0; j < num_x; j = j + 1) begin: bundle_x
			M10K_8_bit_16_solv pixel_data( .q(M10k_out[i*num_x+j]), // contains pixel color (8 bit) for display
									.d(write_data[i*num_x+j]),
									.write_address(write_address),
									.read_address(((640/num_x-1)*next_y[9:log_num_y]) + next_x[9:log_num_x]),
									.we(write_enable),
									.clk(M10k_pll)
			);

			mapper _mapper(
					.clk(M10k_pll),
					.reset(~KEY[0]),
					.x(x_coord[j]),
					.y(y_coord[i][8:0]),
					.scale(scale),
					.sl(shift_left),
					.sr(shift_right),
					.su(shift_up),
					.sd(shift_down),
					.ci(ci_in[i*num_x+j]),
					.cr(cr_in[i*num_x+j]),
					.center_x(center_x[i*num_x+j]),
					.center_y(center_y[i*num_x+j])
			);

			register ci_reg(
				.d(ci_in[i*num_x+j]),
				.q(ci_out[i*num_x+j]),
				.clk(M10k_pll)
			);

			register cr_reg(
				.d(cr_in[i*num_x+j]),
				.q(cr_out[i*num_x+j]),
				.clk(M10k_pll)
			);

			solver _s (
				.clk(M10k_pll),
				.reset(solver_reset),
				.ci(ci_out[i*num_x+j]),
				.cr(cr_out[i*num_x+j]),
				.in_max_iter(max_iterations),
				.out_iter(out_iter[i*num_x+j]),
				.done_reg(solver_done[i*num_x+j])
			); 

			counter_to_color _c2c ( 
				.counter(out_iter[i*num_x+j]),
				.max_iterations(max_iterations),
				.color(color_out[i*num_x+j])
			);
		end
	end
endgenerate

reg solver_reset;
reg [5:0] scale;

// set as registers to involve a stage
wire signed [26:0]  ci_in [num_solvers-1:0];
wire signed [26:0]  cr_in [num_solvers-1:0];
wire signed [26:0]  ci_out [num_solvers-1:0];
wire signed [26:0]  cr_out [num_solvers-1:0];
wire signed [12:0]  out_iter [num_solvers-1:0];
wire [num_solvers-1:0] solver_done ; // used packed array better
wire zoom_in, zoom_out, shift_left, shift_right, shift_up, shift_down;
wire [12:0] max_iterations;
wire [3:0] max_iterations_decimal_display [3:0];

assign max_iterations[12:11] = 2'd0;
assign max_iterations[10:3] = SW[9:2];
assign max_iterations_decimal_display[0] = max_iterations % 10;
assign max_iterations_decimal_display[1] = max_iterations/10 % 10;
assign max_iterations_decimal_display[2] = max_iterations/100 % 10;
assign max_iterations_decimal_display[3] = max_iterations/1000;
assign LEDR[5:0] = {zoom_in, zoom_out, shift_left, shift_right, shift_up, shift_down};
assign zoom_in = SW[0] & out_1;
assign zoom_out = ~SW[0] & out_1;
assign shift_right = SW[1] & out_2; 
assign shift_up = ~SW[1] & out_2; 
assign shift_left = SW[1] & out_3; 
assign shift_down = ~SW[1] & out_3;

wire        [7:0]   color_out [num_solvers-1:0];
// next_y[0] ? M10k_out[1] : M10k_out[0]
reg [7:0] vga_color_in;
always @(*) begin
	case({next_y[log_num_y-1:0], next_x[log_num_x-1:0]}) // change this base on scheme. Even for x and y we could do {x[1:0], y[1:0]}
		4'b0000: vga_color_in = M10k_out[0];
		4'b0001: vga_color_in = M10k_out[1];
		4'b0010: vga_color_in = M10k_out[2];
		4'b0011: vga_color_in = M10k_out[3];

		4'b0100: vga_color_in = M10k_out[4];
		4'b0101: vga_color_in = M10k_out[5];
		4'b0110: vga_color_in = M10k_out[6];
		4'b0111: vga_color_in = M10k_out[7];

		4'b1000: vga_color_in = M10k_out[8];
		4'b1001: vga_color_in = M10k_out[9];
		4'b1010: vga_color_in = M10k_out[10];
		4'b1011: vga_color_in = M10k_out[11];

		4'b1100: vga_color_in = M10k_out[12];
		4'b1101: vga_color_in = M10k_out[13];
		4'b1110: vga_color_in = M10k_out[14];
		4'b1111: vga_color_in = M10k_out[15];

	    default: vga_color_in = M10k_out[0]; //should never enter
	endcase
end

// vga_color_in = M10k_out[{next_y[log_num_y-1:0], next_x[log_num_x-1:0]}];

// Instantiate VGA driver			
// runs at 25 MHz 		
vga_driver DUT   (	.clock(vga_pll), 
							.reset(vga_reset),
							.color_in(vga_color_in),	// Pixel color (8-bit) from memory
							.next_x(next_x),		// This (and next_y) used to specify memory read address
							.next_y(next_y),		// This (and next_x) used to specify memory read address
							.hsync(VGA_HS),
							.vsync(VGA_VS),
							.red(VGA_R),
							.green(VGA_G),
							.blue(VGA_B),
							.sync(VGA_SYNC_N),
							.clk(VGA_CLK),
							.blank(VGA_BLANK_N)
);

// Mandelbrot computation

wire out_1, out_2, out_3;

always @(posedge M10k_pll) begin
	if(~KEY[0]) begin
		scale <= 0;
	end else begin
		if(zoom_in) begin
			scale <= scale + 1;
		end else if (zoom_out) begin
			scale <= scale - 1;
		end
	end
end

userInput _key_1 (
					.clk(M10k_pll),
					.reset(~KEY[0]),
					.in(~KEY[1]),
					// .out( SW[0] ? zoom_in : zoom_out )
					.out(out_1)
				);

userInput _key_2 (
					.clk(M10k_pll),
					.reset(~KEY[0]),
					.in(~KEY[2]),
					// .out( SW[1] ? shift_right : shift_up )
					.out(out_2)
				);

userInput _key_3 (
					.clk(M10k_pll),
					.reset(~KEY[0]),
					.in(~KEY[3]),
					//.out( SW[1] ? shift_left : shift_down )
					.out(out_3)
				);	

//=======================================================
//  Structural coding
//=======================================================
// From Qsys
wire [26:0] pio_x, pio_y;
wire [5:0] pio_scale;
assign pio_x = center_x[0];
assign pio_y = center_y[0];
assign pio_scale = scale;

Computer_System The_System (
	////////////////////////////////////
	// FPGA Side
	////////////////////////////////////
	.vga_pio_locked_export			(vga_pll_lock),           //       vga_pio_locked.export
	.vga_pio_outclk0_clk				(vga_pll),              //      vga_pio_outclk0.clk
	.m10k_pll_locked_export			(M10k_pll_locked),          //      m10k_pll_locked.export
	.m10k_pll_outclk0_clk			(M10k_pll),            //     m10k_pll_outclk0.clk

	// Global signals
	.system_pll_ref_clk_clk					(CLOCK_50),
	.system_pll_ref_reset_reset			(1'b0),
	

	////////////////////////////////////
	// HPS Side
	////////////////////////////////////
	// DDR3 SDRAM
	.memory_mem_a			(HPS_DDR3_ADDR),
	.memory_mem_ba			(HPS_DDR3_BA),
	.memory_mem_ck			(HPS_DDR3_CK_P),
	.memory_mem_ck_n		(HPS_DDR3_CK_N),
	.memory_mem_cke		(HPS_DDR3_CKE),
	.memory_mem_cs_n		(HPS_DDR3_CS_N),
	.memory_mem_ras_n		(HPS_DDR3_RAS_N),
	.memory_mem_cas_n		(HPS_DDR3_CAS_N),
	.memory_mem_we_n		(HPS_DDR3_WE_N),
	.memory_mem_reset_n	(HPS_DDR3_RESET_N),
	.memory_mem_dq			(HPS_DDR3_DQ),
	.memory_mem_dqs		(HPS_DDR3_DQS_P),
	.memory_mem_dqs_n		(HPS_DDR3_DQS_N),
	.memory_mem_odt		(HPS_DDR3_ODT),
	.memory_mem_dm			(HPS_DDR3_DM),
	.memory_oct_rzqin		(HPS_DDR3_RZQ),
	
	// PIO Connections
	.pio_x_external_connection_export(pio_x), 
	.pio_y_external_connection_export(pio_y), 
	.pio_scale_external_connection_export(pio_scale), // pio_scale_external_connection.export
	
	// Ethernet
	.hps_io_hps_io_gpio_inst_GPIO35	(HPS_ENET_INT_N),
	.hps_io_hps_io_emac1_inst_TX_CLK	(HPS_ENET_GTX_CLK),
	.hps_io_hps_io_emac1_inst_TXD0	(HPS_ENET_TX_DATA[0]),
	.hps_io_hps_io_emac1_inst_TXD1	(HPS_ENET_TX_DATA[1]),
	.hps_io_hps_io_emac1_inst_TXD2	(HPS_ENET_TX_DATA[2]),
	.hps_io_hps_io_emac1_inst_TXD3	(HPS_ENET_TX_DATA[3]),
	.hps_io_hps_io_emac1_inst_RXD0	(HPS_ENET_RX_DATA[0]),
	.hps_io_hps_io_emac1_inst_MDIO	(HPS_ENET_MDIO),
	.hps_io_hps_io_emac1_inst_MDC		(HPS_ENET_MDC),
	.hps_io_hps_io_emac1_inst_RX_CTL	(HPS_ENET_RX_DV),
	.hps_io_hps_io_emac1_inst_TX_CTL	(HPS_ENET_TX_EN),
	.hps_io_hps_io_emac1_inst_RX_CLK	(HPS_ENET_RX_CLK),
	.hps_io_hps_io_emac1_inst_RXD1	(HPS_ENET_RX_DATA[1]),
	.hps_io_hps_io_emac1_inst_RXD2	(HPS_ENET_RX_DATA[2]),
	.hps_io_hps_io_emac1_inst_RXD3	(HPS_ENET_RX_DATA[3]),

	// Flash
	.hps_io_hps_io_qspi_inst_IO0	(HPS_FLASH_DATA[0]),
	.hps_io_hps_io_qspi_inst_IO1	(HPS_FLASH_DATA[1]),
	.hps_io_hps_io_qspi_inst_IO2	(HPS_FLASH_DATA[2]),
	.hps_io_hps_io_qspi_inst_IO3	(HPS_FLASH_DATA[3]),
	.hps_io_hps_io_qspi_inst_SS0	(HPS_FLASH_NCSO),
	.hps_io_hps_io_qspi_inst_CLK	(HPS_FLASH_DCLK),

	// Accelerometer
	.hps_io_hps_io_gpio_inst_GPIO61	(HPS_GSENSOR_INT),

	//.adc_sclk                        (ADC_SCLK),
	//.adc_cs_n                        (ADC_CS_N),
	//.adc_dout                        (ADC_DOUT),
	//.adc_din                         (ADC_DIN),

	// General Purpose I/O
	.hps_io_hps_io_gpio_inst_GPIO40	(HPS_GPIO[0]),
	.hps_io_hps_io_gpio_inst_GPIO41	(HPS_GPIO[1]),

	// I2C
	.hps_io_hps_io_gpio_inst_GPIO48	(HPS_I2C_CONTROL),
	.hps_io_hps_io_i2c0_inst_SDA		(HPS_I2C1_SDAT),
	.hps_io_hps_io_i2c0_inst_SCL		(HPS_I2C1_SCLK),
	.hps_io_hps_io_i2c1_inst_SDA		(HPS_I2C2_SDAT),
	.hps_io_hps_io_i2c1_inst_SCL		(HPS_I2C2_SCLK),

	// Pushbutton
	.hps_io_hps_io_gpio_inst_GPIO54	(HPS_KEY),

	// LED
	.hps_io_hps_io_gpio_inst_GPIO53	(HPS_LED),

	// SD Card
	.hps_io_hps_io_sdio_inst_CMD	(HPS_SD_CMD),
	.hps_io_hps_io_sdio_inst_D0	(HPS_SD_DATA[0]),
	.hps_io_hps_io_sdio_inst_D1	(HPS_SD_DATA[1]),
	.hps_io_hps_io_sdio_inst_CLK	(HPS_SD_CLK),
	.hps_io_hps_io_sdio_inst_D2	(HPS_SD_DATA[2]),
	.hps_io_hps_io_sdio_inst_D3	(HPS_SD_DATA[3]),

	// SPI
	.hps_io_hps_io_spim1_inst_CLK		(HPS_SPIM_CLK),
	.hps_io_hps_io_spim1_inst_MOSI	(HPS_SPIM_MOSI),
	.hps_io_hps_io_spim1_inst_MISO	(HPS_SPIM_MISO),
	.hps_io_hps_io_spim1_inst_SS0		(HPS_SPIM_SS),

	// UART
	.hps_io_hps_io_uart0_inst_RX	(HPS_UART_RX),
	.hps_io_hps_io_uart0_inst_TX	(HPS_UART_TX),

	// USB
	.hps_io_hps_io_gpio_inst_GPIO09	(HPS_CONV_USB_N),
	.hps_io_hps_io_usb1_inst_D0		(HPS_USB_DATA[0]),
	.hps_io_hps_io_usb1_inst_D1		(HPS_USB_DATA[1]),
	.hps_io_hps_io_usb1_inst_D2		(HPS_USB_DATA[2]),
	.hps_io_hps_io_usb1_inst_D3		(HPS_USB_DATA[3]),
	.hps_io_hps_io_usb1_inst_D4		(HPS_USB_DATA[4]),
	.hps_io_hps_io_usb1_inst_D5		(HPS_USB_DATA[5]),
	.hps_io_hps_io_usb1_inst_D6		(HPS_USB_DATA[6]),
	.hps_io_hps_io_usb1_inst_D7		(HPS_USB_DATA[7]),
	.hps_io_hps_io_usb1_inst_CLK		(HPS_USB_CLKOUT),
	.hps_io_hps_io_usb1_inst_STP		(HPS_USB_STP),
	.hps_io_hps_io_usb1_inst_DIR		(HPS_USB_DIR),
	.hps_io_hps_io_usb1_inst_NXT		(HPS_USB_NXT)
);
endmodule // end top level

// Declaration of module, include width and signedness of each input/output
module vga_driver (
	input wire clock,
	input wire reset,
	input [7:0] color_in,
	output [9:0] next_x,
	output [9:0] next_y,
	output wire hsync,
	output wire vsync,
	output [7:0] red,
	output [7:0] green,
	output [7:0] blue,
	output sync,
	output clk,
	output blank
);
	
	// Horizontal parameters (measured in clock cycles)
	parameter [9:0] H_ACTIVE  	=  10'd_639 ;
	parameter [9:0] H_FRONT 	=  10'd_15 ;
	parameter [9:0] H_PULSE		=  10'd_95 ;
	parameter [9:0] H_BACK 		=  10'd_47 ;

	// Vertical parameters (measured in lines)
	parameter [9:0] V_ACTIVE  	=  10'd_479 ;
	parameter [9:0] V_FRONT 	=  10'd_9 ;
	parameter [9:0] V_PULSE		=  10'd_1 ;
	parameter [9:0] V_BACK 		=  10'd_32 ;

//	// Horizontal parameters (measured in clock cycles)
//	parameter [9:0] H_ACTIVE  	=  10'd_9 ;
//	parameter [9:0] H_FRONT 	=  10'd_4 ;
//	parameter [9:0] H_PULSE		=  10'd_4 ;
//	parameter [9:0] H_BACK 		=  10'd_4 ;
//	parameter [9:0] H_TOTAL 	=  10'd_799 ;
//
//	// Vertical parameters (measured in lines)
//	parameter [9:0] V_ACTIVE  	=  10'd_1 ;
//	parameter [9:0] V_FRONT 	=  10'd_1 ;
//	parameter [9:0] V_PULSE		=  10'd_1 ;
//	parameter [9:0] V_BACK 		=  10'd_1 ;

	// Parameters for readability
	parameter 	LOW 	= 1'b_0 ;
	parameter 	HIGH	= 1'b_1 ;

	// States (more readable)
	parameter 	[7:0]	H_ACTIVE_STATE 		= 8'd_0 ;
	parameter 	[7:0] 	H_FRONT_STATE		= 8'd_1 ;
	parameter 	[7:0] 	H_PULSE_STATE 		= 8'd_2 ;
	parameter 	[7:0] 	H_BACK_STATE 		= 8'd_3 ;

	parameter 	[7:0]	V_ACTIVE_STATE 		= 8'd_0 ;
	parameter 	[7:0] 	V_FRONT_STATE		= 8'd_1 ;
	parameter 	[7:0] 	V_PULSE_STATE 		= 8'd_2 ;
	parameter 	[7:0] 	V_BACK_STATE 		= 8'd_3 ;

	// Clocked registers
	reg 		hysnc_reg ;
	reg 		vsync_reg ;
	reg 	[7:0]	red_reg ;
	reg 	[7:0]	green_reg ;
	reg 	[7:0]	blue_reg ;
	reg 		line_done ;

	// Control registers
	reg 	[9:0] 	h_counter ;
	reg 	[9:0] 	v_counter ;

	reg 	[7:0]	h_state ;
	reg 	[7:0]	v_state ;

	// State machine
	always@(posedge clock) begin
		// At reset . . .
  		if (reset) begin
			// Zero the counters
			h_counter 	<= 10'd_0 ;
			v_counter 	<= 10'd_0 ;
			// States to ACTIVE
			h_state 	<= H_ACTIVE_STATE  ;
			v_state 	<= V_ACTIVE_STATE  ;
			// Deassert line done
			line_done 	<= LOW ;
  		end
  		else begin
			//////////////////////////////////////////////////////////////////////////
			///////////////////////// HORIZONTAL /////////////////////////////////////
			//////////////////////////////////////////////////////////////////////////
			if (h_state == H_ACTIVE_STATE) begin
				// Iterate horizontal counter, zero at end of ACTIVE mode
				h_counter <= (h_counter==H_ACTIVE)?10'd_0:(h_counter + 10'd_1) ;
				// Set hsync
				hysnc_reg <= HIGH ;
				// Deassert line done
				line_done <= LOW ;
				// State transition
				h_state <= (h_counter == H_ACTIVE)?H_FRONT_STATE:H_ACTIVE_STATE ;
			end
			// Assert done flag, wait here for reset
			if (h_state == H_FRONT_STATE) begin
				// Iterate horizontal counter, zero at end of H_FRONT mode
				h_counter <= (h_counter==H_FRONT)?10'd_0:(h_counter + 10'd_1) ;
				// Set hsync
				hysnc_reg <= HIGH ;
				// State transition
				h_state <= (h_counter == H_FRONT)?H_PULSE_STATE:H_FRONT_STATE ;
			end
			if (h_state == H_PULSE_STATE) begin
				// Iterate horizontal counter, zero at end of H_FRONT mode
				h_counter <= (h_counter==H_PULSE)?10'd_0:(h_counter + 10'd_1) ;
				// Set hsync
				hysnc_reg <= LOW ;
				// State transition
				h_state <= (h_counter == H_PULSE)?H_BACK_STATE:H_PULSE_STATE ;
			end
			if (h_state == H_BACK_STATE) begin
				// Iterate horizontal counter, zero at end of H_FRONT mode
				h_counter <= (h_counter==H_BACK)?10'd_0:(h_counter + 10'd_1) ;
				// Set hsync
				hysnc_reg <= HIGH ;
				// State transition
				h_state <= (h_counter == H_BACK)?H_ACTIVE_STATE:H_BACK_STATE ;
				// Signal line complete at state transition (offset by 1 for synchronous state transition)
				line_done <= (h_counter == (H_BACK-1))?HIGH:LOW ;
			end
			//////////////////////////////////////////////////////////////////////////
			///////////////////////// VERTICAL ///////////////////////////////////////
			//////////////////////////////////////////////////////////////////////////
			if (v_state == V_ACTIVE_STATE) begin
				// increment vertical counter at end of line, zero on state transition
				v_counter <= (line_done==HIGH)?((v_counter==V_ACTIVE)?10'd_0:(v_counter + 10'd_1)):v_counter ;
				// set vsync in active mode
				vsync_reg <= HIGH ;
				// state transition - only on end of lines
				v_state <= (line_done==HIGH)?((v_counter==V_ACTIVE)?V_FRONT_STATE:V_ACTIVE_STATE):V_ACTIVE_STATE ;
			end
			if (v_state == V_FRONT_STATE) begin
				// increment vertical counter at end of line, zero on state transition
				v_counter <= (line_done==HIGH)?((v_counter==V_FRONT)?10'd_0:(v_counter + 10'd_1)):v_counter ;
				// set vsync in front porch
				vsync_reg <= HIGH ;
				// state transition
				v_state <= (line_done==HIGH)?((v_counter==V_FRONT)?V_PULSE_STATE:V_FRONT_STATE):V_FRONT_STATE ;
			end
			if (v_state == V_PULSE_STATE) begin
				// increment vertical counter at end of line, zero on state transition
				v_counter <= (line_done==HIGH)?((v_counter==V_PULSE)?10'd_0:(v_counter + 10'd_1)):v_counter ;
				// clear vsync in pulse
				vsync_reg <= LOW ;
				// state transition
				v_state <= (line_done==HIGH)?((v_counter==V_PULSE)?V_BACK_STATE:V_PULSE_STATE):V_PULSE_STATE ;
			end
			if (v_state == V_BACK_STATE) begin
				// increment vertical counter at end of line, zero on state transition
				v_counter <= (line_done==HIGH)?((v_counter==V_BACK)?10'd_0:(v_counter + 10'd_1)):v_counter ;
				// set vsync in back porch
				vsync_reg <= HIGH ;
				// state transition
				v_state <= (line_done==HIGH)?((v_counter==V_BACK)?V_ACTIVE_STATE:V_BACK_STATE):V_BACK_STATE ;
			end

			//////////////////////////////////////////////////////////////////////////
			//////////////////////////////// COLOR OUT ///////////////////////////////
			//////////////////////////////////////////////////////////////////////////
			red_reg 		<= (h_state==H_ACTIVE_STATE)?((v_state==V_ACTIVE_STATE)?{color_in[7:5],5'd_0}:8'd_0):8'd_0 ;
			green_reg 	<= (h_state==H_ACTIVE_STATE)?((v_state==V_ACTIVE_STATE)?{color_in[4:2],5'd_0}:8'd_0):8'd_0 ;
			blue_reg 	<= (h_state==H_ACTIVE_STATE)?((v_state==V_ACTIVE_STATE)?{color_in[1:0],6'd_0}:8'd_0):8'd_0 ;
			
 	 	end
	end
	// Assign output values
	assign hsync = hysnc_reg ;
	assign vsync = vsync_reg ;
	assign red = red_reg ;
	assign green = green_reg ;
	assign blue = blue_reg ;
	assign clk = clock ;
	assign sync = 1'b_0 ;
	assign blank = hysnc_reg & vsync_reg ;
	// The x/y coordinates that should be available on the NEXT cycle
	assign next_x = (h_state==H_ACTIVE_STATE)?h_counter:10'd_0 ;
	assign next_y = (v_state==V_ACTIVE_STATE)?v_counter:10'd_0 ;

endmodule




//============================================================
// M10K module for testing
//============================================================
// See example 12-16 in 
// http://people.ece.cornell.edu/land/courses/ece5760/DE1_SOC/HDL_style_qts_qii51007.pdf
//============================================================

module M10K_512_8( 
    output reg [7:0] q,
    input [7:0] d,
    input [18:0] write_address, read_address,
    input we, clk
);
	 // force M10K ram style
	 // 307200 words of 8 bits
    reg [7:0] mem [153600:0]  /* synthesis ramstyle = "no_rw_check, M10K" */;
	 
    always @ (posedge clk) begin
        if (we) begin
            mem[write_address] <= d;
		  end
        q <= mem[read_address]; // q doesn't get d in this clock cycle
    end
endmodule

module M10K_8_bit_16_solv( 
    output reg [7:0] q,
    input [7:0] d,
    input [18:0] write_address, read_address,
    input we, clk
);
	 // force M10K ram style
	 // 307200 words of 8 bits
    reg [7:0] mem [19200:0]  /* synthesis ramstyle = "no_rw_check, M10K" */;
	 
    always @ (posedge clk) begin
        if (we) begin
            mem[write_address] <= d;
		  end
        q <= mem[read_address]; // q doesn't get d in this clock cycle
    end
endmodule

module M10K_8_bit_4_solv( 
    output reg [7:0] q,
    input [7:0] d,
    input [18:0] write_address, read_address,
    input we, clk
);
	 // force M10K ram style
	 // 307200 words of 8 bits
    reg [7:0] mem [76800:0]  /* synthesis ramstyle = "no_rw_check, M10K" */;
	 
    always @ (posedge clk) begin
        if (we) begin
            mem[write_address] <= d;
		  end
        q <= mem[read_address]; // q doesn't get d in this clock cycle
    end
endmodule



module register (input [26:0] d, input clk, output reg [26:0] q);
	always @(posedge clk)
		q <= d;
endmodule
