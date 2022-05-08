

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
//wire			[15: 0]	hex5_hex4;

//assign HEX0 = ~hex3_hex0[ 6: 0]; // hex3_hex0[ 6: 0]; 
//assign HEX1 = ~hex3_hex0[14: 8];
//assign HEX2 = ~hex3_hex0[22:16];
//assign HEX3 = ~hex3_hex0[30:24];
assign HEX4 = 7'b1111111;
assign HEX5 = 7'b1111111;

HexDigit Digit0(HEX0, hex3_hex0[3:0]);
HexDigit Digit1(HEX1, hex3_hex0[7:4]);
HexDigit Digit2(HEX2, hex3_hex0[11:8]);
HexDigit Digit3(HEX3, hex3_hex0[15:12]);

//=======================================================
//  PIO state machine
//=======================================================
// wire [31:0] pio_x, pio_y, pio_z, pio_x0, pio_y0, pio_z0, pio_sigma, pio_beta, pio_rho, pio_dt;



// assign en = SW[0];
// assign hex3_hex0[3:0] = SW[0]&pio_lorenz_clk;
// assign hex3_hex0[7:4] = SW[1];
// assign hex3_hex0[11:8] = SW[2];
// assign hex3_hex0[15:12] = SW[3]&pio_lorenz_reset;
// wire signed [26:0] sigma, beta, rho, dt ,x0, y0, z0, x, y, z;
// assign sigma = 10 << 20;
// assign beta = {7'h2, 20'hAAAAA}; //7d'2
// assign rho = 28 << 20;
// assign dt = {7'h0, 20'h01000};
// assign x0 = {7'h7F, 20'h00000};
// assign y0 = {7'h0, 20'h19999};
// assign z0 = 25 << 20;
// lorenz l (.clk(pio_lorenz_clk), .reset(pio_lorenz_reset), .en(1'b1), .sigma(pio_sigma), .beta(pio_beta), .rho(pio_rho), .dt(pio_dt), .x0(pio_x0), .y0(pio_y0), .z0(pio_z0), 
// 				.x(pio_x), .y(pio_y), .z(pio_z));

// wire pio_lorenz_clk, pio_lorenz_reset; 

// // wire [19:0] pio_phasor_sin_out[1:0];
// // wire [19:0] pio_phasor_cos_out[1:0];
// wire [19:0] pio_phasor_out[1:0];
// wire [3:0]  pio_mag_cos[1:0], pio_mag_sin[1:0], pio_freq[1:0];
// phasor p_1 (.clk(pio_lorenz_clk), .reset(pio_lorenz_reset),
// 			.sine_mag(pio_mag_sin[0]), .cosine_mag(pio_mag_cos[0]), .freq(pio_freq[0]),
// 			.out(pio_phasor_out[0]));
// phasor p_2 (.clk(pio_lorenz_clk), .reset(pio_lorenz_reset),
// 			.sine_mag(pio_mag_sin[1]), .cosine_mag(pio_mag_cos[1]), .freq(pio_freq[1]),
// 			.out(pio_phasor_out[1]));

//============================================
//=========DEBUGGING -- MATCH WITH LAB 2======

//=======================================================
// Audio controller for AVALON bus-master
//=======================================================

// computes DDS for sine wave and fills audio FIFO
// reads audio FIFO and loops it back
// MUST configure (in Qsys) Audio Config module:
// -- Line in to ADC
// -- uncheck both bypass options
// The audio_input_ready signal goes high for one
// cycle when there is new audio input data
// --
// 32-bit data is on 
//   right_audio_input, left_audio_input ;
// Every write requires 32-bit data on 
//   right_audio_output, left_audio_output ;

reg [31:0] bus_addr ; // Avalon address
// see 
// ftp://ftp.altera.com/up/pub/Altera_Material/15.1/University_Program_IP_Cores/Audio_Video/Audio.pdf
// for addresses
wire [31:0] audio_base_address = 32'h00003040 ;  // Avalon address
wire [31:0] audio_fifo_address = 32'h00003044 ;  // Avalon address +4 offset
wire [31:0] audio_data_left_address = 32'h00003048 ;  // Avalon address +8
wire [31:0] audio_data_right_address = 32'h0000304c ;  // Avalon address +12
reg [3:0] bus_byte_enable ; // four bit byte read/write mask
reg bus_read  ;       // high when requesting data
reg bus_write ;      //  high when writing data
reg [31:0] bus_write_data ; //  data to send to Avalog bus
wire bus_ack  ;       //  Avalon bus raises this when done
wire [31:0] bus_read_data ; // data from Avalon bus
reg [30:0] timer ;
reg [3:0] state ;
wire state_clock ;
wire reset;

// SW[9] disables state machine so that
// HPS has complete control of audio interface
assign reset = ~KEY[0] | SW[9] ;

// current free words in audio interface
reg [7:0] fifo_space ;
// debug check of space
assign LEDR = fifo_space ;

// audio input/output from audio module FIFO
reg [15:0] right_audio_input, left_audio_input ;
reg audio_input_ready ;
wire [15:0] right_audio_output, left_audio_output ;

// For audio loopback, or filtering
// assign right_audio_output = SW[1]? right_filter_output : right_audio_input ;
// assign left_audio_output  = SW[0]? decimated_filter_300_out : left_audio_input;

// DDS update signal for testing
reg [31:0] dds_accum ;
// DDS LUT
wire [15:0] sine_out ;
// update phase accumulator
// sync to audio data rate (48kHz) using audio_input_ready signal
// always @(posedge CLOCK_50) begin //CLOCK_50
// 	// Fout = (sample_rate)/(2^32)*{SW[9:0], 16'b0}
// 	// then Fout=48000/(2^32)*(2^25) = 375 Hz
// 	if (audio_input_ready) dds_accum <= dds_accum + {SW[9:0], 16'b0} ;	
// end
// DDS sine wave ROM
// sync_rom sineTable(CLOCK_50, dds_accum[31:24], sine_out);

//==============================================================
//===================== AUDIO SYNTHESIS ========================
//==============================================================
reg  		audio_clk;
wire [26:0] audio_syn_out_x;
wire [26:0] audio_syn_out_y;

reg  		phasor_clk;
reg  [26:0] mag_cos, mag_sin;
wire [3:0]  freq;		
// wire [26:0] phasor_out;
wire [3:0]  amp_shift;

assign freq = SW[3:0];
assign amp_shift = SW[7:4];

// phasor p_test (.clk(phasor_clk), .reset(reset),
// 			.sine_mag(coeff_a), .cosine_mag(coeff_b), .freq(freq),
// 			.out(phasor_out));

wire pio_wr_en, pio_reset;
wire [4:0] pio_wr_addr;
wire signed [26:0] pio_a, pio_b, pio_c, pio_d;
reg	signed [26:0] coeff_a [20:0];
reg	signed [26:0] coeff_b [20:0];
reg	signed [26:0] coeff_c [20:0];
reg	signed [26:0] coeff_d [20:0];

parameter bitwidth = 27;
parameter N = 21;
wire signed [bitwidth-1:0] phasor_out_x [N-1:0];
wire signed [bitwidth-1:0] phasor_out_y [N-1:0];
generate
	genvar i;
	for (i = 1; i <= N; i = i+1) begin: audio_syn
		phasor x_phasor (
		.clk(audio_clk),
		.reset(reset),
		.sine_mag(coeff_a[i-1]),
		.cosine_mag(coeff_b[i-1]),
		.freq(i[4:0]),
		.out(phasor_out_x[i-1])
		);
		phasor y_phasor (
		.clk(audio_clk),
		.reset(reset),
		.sine_mag(coeff_c[i-1]),
		.cosine_mag(coeff_d[i-1]),
		.freq(i[4:0]),
		.out(phasor_out_y[i-1])
		);
	end
endgenerate
reg signed [bitwidth-1:0] sum_x;
reg signed [bitwidth-1:0] sum_y;

integer j;
always @(*) begin
	sum_x = {(bitwidth-1){1'b0}}; // all zero
	sum_y = {(bitwidth-1){1'b0}}; // all zero
		for(j = 0; j < N; j=j+1) begin
			sum_x = sum_x + phasor_out_x[j];
			sum_y = sum_y + phasor_out_y[j];
		end
	end
assign audio_syn_out_x = sum_x;
assign audio_syn_out_y = sum_y;

always @(posedge CLOCK_50) begin //CLOCK_50
	// reset state machine and read/write controls
	if (pio_reset) begin
		for(j=0; j<21; j=j+1) begin
			coeff_a[j] <= 0;
			coeff_b[j] <= 0;
			coeff_c[j] <= 0;
			coeff_d[j] <= 0;
		end
	end else begin
		if (pio_wr_en) begin
			coeff_a[pio_wr_addr[4:0]] <= pio_a << amp_shift;
			coeff_b[pio_wr_addr[4:0]] <= pio_b << amp_shift;
			coeff_c[pio_wr_addr[4:0]] <= pio_c << amp_shift;
			coeff_d[pio_wr_addr[4:0]] <= pio_d << amp_shift;
		end 
	end
end

assign GPIO_0[4] = pio_a[0];
assign GPIO_0[5] = pio_b[0];
assign GPIO_0[6] = pio_c[0];
assign GPIO_0[7] = pio_d[0];
assign GPIO_0[8] = pio_reset;
assign GPIO_0[9] = pio_wr_en;

// get some signals exposed
// connect bus master signals to i/o for probes
assign GPIO_0[0] = bus_write ;
assign GPIO_0[1] = bus_read ;
assign GPIO_0[2] = decimated_audio_ready ;
assign GPIO_0[3] = audio_input_ready ;

// ===============================================
// === Audio bus master state machine ============
// ===============================================
// writes, then reads the audio interface, if data
// is ready (FIFO indicates data). Sensing the FIFO
// effectively syncs data generation to the Audio 
// rate.
// 
// The audio_input_ready signal goes high for one
// cycle when there is new audio input data
//
// 32-bit audio ADC data is on:
//   right_audio_input, left_audio_input ;
// Every write requires 32-bit data on: 
//   right_audio_output, left_audio_output ;
	
// 6:1 decimated clock = 8KHz rate
reg decimated_audio_ready ; 
reg [3:0] decimated_audio_clk_counter ;
	
always @(posedge CLOCK_50) begin //CLOCK_50
	// reset state machine and read/write controls
	if (reset) begin
		state <= 0 ;
		bus_read <= 0 ; // set to one if a read opeation from bus
		bus_write <= 0 ; // set to one if a write operation to bus
		timer <= 0;
		// phasor_clk <= 0;
		audio_clk <= 0;
		// small sound
		mag_cos <= 27'd5 << 14;
		mag_sin <= 27'd8 << 14;
	end
	else begin
		// timer just for deubgging
		timer <= timer + 1;
	end
	
	// === writing stereo to the audio FIFO ==========
	// set up read FIFO available space
	if (state==4'd0) begin
		bus_addr <= audio_fifo_address ;
		bus_read <= 1'b1 ;
		bus_byte_enable <= 4'b1111;
		state <= 4'd1 ; // wait for read ACK
	end
	
	// wait for read ACK and read the fifo available
	// bus ACK is high when data is available
	if (state==4'd1 && bus_ack==1) begin
		state <= 4'd2 ; //4'd2
		// FIFO write space is in high byte
		fifo_space <= (bus_read_data>>24) ;
		// end the read
		bus_read <= 1'b0 ;
	end
	
	// When there is room in the FIFO
	// -- compute next DDS sine sample
	// -- start write to fifo for each channel
	// -- first the left channel
	if (state==4'd2 && fifo_space>8'd2) begin
		state <= 4'd3;	
		// IF SW=10'h200 
		// and Fout = (sample_rate)/(2^32)*{SW[9:0], 16'b0}
		// then Fout=48000/(2^32)*(2^25) = 375 Hz
		// dds_accum <= dds_accum + {SW[9:0], 16'b0};
		// convert 16-bit table to 32-bit format
		// bus_write_data <= (phasor_out << 5);
		bus_write_data <= (audio_syn_out_x << 5);
		// bus_write_data <= (sine_out << 16) ;
		bus_addr <= audio_data_right_address ;
		bus_byte_enable <= 4'b1111;
		bus_write <= 1'b1 ;
	end	
	// if no space, try again later
	else if (state==4'd2 && fifo_space<=8'd2) begin
		state <= 4'b0 ;
	end
	
	// detect bus-transaction-complete ACK 
	// for left channel write
	// You MUST do this check
	if (state==4'd3 && bus_ack==1) begin
		state <= 4'd4 ; // include right channel
		//state <= 4'd0 ; // left channel only!
		bus_write <= 0;
	end
	
	// -- now the right channel
	if (state==4'd4) begin // 
		state <= 4'd5;
		// bus_write_data <= (phasor_out << 5);
		bus_write_data <= (audio_syn_out_y << 5);
		// bus_write_data <= (sine_out << 16) ;
		bus_addr <= audio_data_left_address ;
		bus_write <= 1'b1 ;

		// To synchronize the phasor and the audio codec
		// phasor_clk <= 1;
		audio_clk <= 1;
	end	
	
	// detect bus-transaction-complete ACK
	// for right channel write
	// You MUST do this check
	if (state==4'd5 && bus_ack==1) begin
		state <= 4'd0 ; // for write only function
		// state <= 4'd6 ; // for read/write  function
		bus_write <= 0;

		// To synchronize the phasor and the audio codec
		// phasor_clk <= 0;
		audio_clk <= 0;
	end
	
	// NOT USING THIS PART
	// === reading stereo from the audio FIFO ==========
	// set up read FIFO for available read values
	if (state==4'd6 ) begin
		bus_addr <= audio_fifo_address ;
		bus_read <= 1'b1 ;
		bus_byte_enable <= 4'b1111;
		state <= 4'd7 ; // wait for read ACK
	end
	
	// wait for read ACK and read the fifo available
	// bus ACK is high when data is available
	if (state==4'd7 && bus_ack==1) begin
		state <= 4'd8 ; //4'dxx
		// FIFO read space is in low byte
		// which is zero when empty
		fifo_space <= bus_read_data & 8'hff ;
		// end the read
		bus_read <= 1'b0 ;
	end
	
	// When there is data in the read FIFO
	// -- read it from both channels
	// -- first the left channel
	if (state==4'd8 && fifo_space>8'd0) begin // 
		state <= 4'd9;	
		bus_addr <= audio_data_left_address ;
		bus_byte_enable <= 4'b1111;
		bus_read <= 1'b1 ;
	end	
	// if no data, try again later
	else if (state==4'd8 && fifo_space<=8'd0) begin
		state <= 4'b0 ;
	end
	
	// detect bus-transaction-complete ACK 
	// for left channel read
	// You MUST do this check
	if (state==4'd9 && bus_ack==1) begin
		state <= 4'd10 ; // include right channel
		left_audio_input <= bus_read_data ;
		bus_read <= 0;
	end
	
	// When there is data in the read FIFO
	// -- read it from both channels
	// -- now right channel
	if (state==4'd10) begin // 
		state <= 4'd11;	
		bus_addr <= audio_data_right_address ;
		bus_byte_enable <= 4'b1111;
		bus_read <= 1'b1 ;
	end	
	
	// detect bus-transaction-complete ACK 
	// for right channel read
	// You MUST do this check
	if (state==4'd11 && bus_ack==1) begin
		state <= 4'd12 ; // back to beginning
		right_audio_input <= bus_read_data ;
		// set the data-ready strobe
		audio_input_ready <= 1'b1;
		// increment/set decimated rate 
		if (decimated_audio_clk_counter==4'd5) begin
			decimated_audio_clk_counter <= 4'd0;
			decimated_audio_ready <= 1'b1;
		end
		else begin
			decimated_audio_clk_counter <= decimated_audio_clk_counter + 4'd1;
		end
		// finish the read
		bus_read <= 0;
	end
	
	// wait 1 cycle data-ready strobe
	if (state==4'd12) begin
		state <= 4'd13 ; // back to beginning
		//audio_input_ready <= 1'b0;
	end
	// end data-ready strobe
	if (state==4'd13) begin
		state <= 4'd0 ; // back to beginning
		audio_input_ready <= 1'b0;
		decimated_audio_ready <= 1'b0 ;
	end
	
end // always @(posedge state_clock)

//============================================
// END OF DEBUGGING===========================


//=======================================================
//  Structural coding
//=======================================================

Computer_System The_System (
	////////////////////////////////////
	// FPGA Side
	////////////////////////////////////

	// PIO ports
	.pio_a_external_connection_export(pio_a),    
	.pio_b_external_connection_export(pio_b),    
	.pio_c_external_connection_export(pio_c),    
	.pio_d_external_connection_export(pio_d),    
	.pio_reset_external_connection_export(pio_reset),
	.pio_wr_en_external_connection_export(pio_wr_en),
	.pio_wr_addr_external_connection_export(pio_wr_addr),

	// Global signals
	.system_pll_ref_clk_clk					(CLOCK_50),
	.system_pll_ref_reset_reset			(1'b0),

	// AV Config
	.av_config_SCLK							(FPGA_I2C_SCLK),
	.av_config_SDAT							(FPGA_I2C_SDAT),
	
	// Audio Subsystem
	.audio_pll_ref_clk_clk					(CLOCK3_50),
	.audio_pll_ref_reset_reset				(1'b0),
	.audio_clk_clk								(AUD_XCK),
	.audio_ADCDAT								(AUD_ADCDAT),
	.audio_ADCLRCK								(AUD_ADCLRCK),
	.audio_BCLK									(AUD_BCLK),
	.audio_DACDAT								(AUD_DACDAT),
	.audio_DACLRCK								(AUD_DACLRCK),

	// bus-master state machine interface
	.bus_master_audio_external_interface_address     (bus_addr),     
	.bus_master_audio_external_interface_byte_enable (bus_byte_enable), 
	.bus_master_audio_external_interface_read        (bus_read),        
	.bus_master_audio_external_interface_write       (bus_write),       
	.bus_master_audio_external_interface_write_data  (bus_write_data),  
	.bus_master_audio_external_interface_acknowledge (bus_ack),                                  
	.bus_master_audio_external_interface_read_data   (bus_read_data),  

	// VGA Subsystem
	.vga_pll_ref_clk_clk 					(CLOCK2_50),
	.vga_pll_ref_reset_reset				(1'b0),
	.vga_CLK										(VGA_CLK),  //25M
	.vga_BLANK									(VGA_BLANK_N),
	.vga_SYNC									(VGA_SYNC_N),
	.vga_HS										(VGA_HS),
	.vga_VS										(VGA_VS),
	.vga_R										(VGA_R),
	.vga_G										(VGA_G),
	.vga_B										(VGA_B),
	
	// SDRAM
	.sdram_clk_clk								(DRAM_CLK),
   .sdram_addr									(DRAM_ADDR),
	.sdram_ba									(DRAM_BA),
	.sdram_cas_n								(DRAM_CAS_N),
	.sdram_cke									(DRAM_CKE),
	.sdram_cs_n									(DRAM_CS_N),
	.sdram_dq									(DRAM_DQ),
	.sdram_dqm									({DRAM_UDQM,DRAM_LDQM}),
	.sdram_ras_n								(DRAM_RAS_N),
	.sdram_we_n									(DRAM_WE_N),
	
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
	
	// PIO ports

	// .pio_freq_external_connection_export ({pio_freq[0], pio_freq[1]}),    
	// .pio_mag_cos_external_connection_export ({pio_mag_cos[0], pio_mag_cos[1]}),       
	// .pio_mag_sin_external_connection_export ({pio_mag_sin[0], pio_mag_sin[1]}),

	// .pio_phasor_out_1_external_connection_export (pio_phasor_out[0]),
	// .pio_phasor_out_2_external_connection_export (pio_phasor_out[1]),
	
	// .pio_lorenz_clk_external_connection_export (pio_lorenz_clk),
	// .pio_lorenz_reset_external_connection_export (pio_lorenz_reset),
	
	
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


endmodule

///////////////////////////////////////////////////
//// signed mult of 2.16 format 2'comp ////////////
///////////////////////////////////////////////////
module signed_mult_2_16 (out, a, b);

	output 		[17:0]	out;
	input 	signed	[17:0] 	a;
	input 	signed	[17:0] 	b;
	
	wire	signed	[17:0]	out;
	wire 	signed	[35:0]	mult_out;

	assign mult_out = a * b;
	//assign out = mult_out[33:17];
	assign out = {mult_out[35], mult_out[32:16]};
endmodule
//////////////////////////////////////////////////


///////////////////////////////////////////////////////////////////
/// Second order IIR filter ///////////////////////////////////////
///////////////////////////////////////////////////////////////////
module IIR2_18bit_fixed (audio_out, audio_in, 
			b1, b2, b3, 
			a2, a3, 
			state_clk, audio_input_ready, reset) ;
// The filter is a "Direct Form II Transposed"
// 
//    a(1)*y(n) = b(1)*x(n) + b(2)*x(n-1) + ... + b(nb+1)*x(n-nb)
//                          - a(2)*y(n-1) - ... - a(na+1)*y(n-na)
// 
//    If a(1) is not equal to 1, FILTER normalizes the filter
//    coefficients by a(1). 
//
// one audio sample, 16 bit, 2's complement
output reg signed [15:0] audio_out ;
// one audio sample, 16 bit, 2's complement
input wire signed [15:0] audio_in ;
// filter coefficients
input wire signed [17:0] b1, b2, b3, a2, a3 ;
input wire state_clk, audio_input_ready, reset ;

/// filter vars //////////////////////////////////////////////////
wire signed [17:0] f1_mac_new, f1_coeff_x_value ;
reg signed [17:0] f1_coeff, f1_mac_old, f1_value ;

// input to filter
reg signed [17:0] x_n ;
// input history x(n-1), x(n-2)
reg signed [17:0] x_n1, x_n2 ; 

// output history: y_n is the new filter output, BUT it is
// immediately stored in f1_y_n1 for the next loop through 
// the filter state machine
reg signed [17:0] f1_y_n1, f1_y_n2 ; 

// MAC operation
signed_mult_2_16 f1_c_x_v (f1_coeff_x_value, f1_coeff, f1_value);
assign f1_mac_new = f1_mac_old + f1_coeff_x_value ;

// state variable 
reg [3:0] state ;
//oneshot gen to sync to audio clock
reg last_clk ; 
///////////////////////////////////////////////////////////////////

//Run the filter state machine FAST so that it completes in one 
//audio cycle
always @ (posedge state_clk) 
begin
	if (reset)
	begin
		state <= 4'd15 ; //turn off the filter state machine	
	end
	
	else begin
		case (state)
	
			1: 
			begin
				// set up b1*x(n)
				f1_mac_old <= 18'd0 ;
				f1_coeff <= b1 ;
				//f1_value <= {audio_in, 2'b0} ;	
				// sign extend
				f1_value <= {audio_in[15],audio_in[15], audio_in} ;	
				//register input
				//x_n <= {audio_in, 2'b0} ;	
				x_n <= {audio_in[15],audio_in[15], audio_in} ;			
				// next state
				state <= 4'd2;
			end
	
			2: 
			begin
				// set up b2*x(n-1) 
				f1_mac_old <= f1_mac_new ;
				f1_coeff <= b2 ;
				f1_value <= x_n1 ;				
				// next state
				state <= 4'd3;
			end
			
			3:
			begin
				// set up b3*x(n-2) 
				f1_mac_old <= f1_mac_new ;
				f1_coeff <= b3 ;
				f1_value <= x_n2 ;
				// next state
				state <= 4'd6;
			end
						
			6: 
			begin
				// set up -a2*y(n-1) 
				f1_mac_old <= f1_mac_new ;
				f1_coeff <= a2 ;
				f1_value <= f1_y_n1 ; 
				//next state 
				state <= 4'd7;
			end
			
			7: 
			begin
				// set up -a3*y(n-2) 
				f1_mac_old <= f1_mac_new ;
				f1_coeff <= a3 ;
				f1_value <= f1_y_n2 ; 				
				//next state 
				state <= 4'd10;
			end
			
			10: 
			begin
				// get the output 
				// and put it in the LAST output var
				// for the next pass thru the state machine
				//mult by scale because of coeff scaling
				// to prevent overflow
				f1_y_n1 <= f1_mac_new  ; 
				//audio_out <= f1_y_n1[17:2] ;				
				// update output history
				f1_y_n2 <= f1_y_n1 ;				
				// update input history
				x_n1 <= x_n ;
				x_n2 <= x_n1 ;
				//next state 
				state <= 4'd15;
			end	
			
			15:
			begin
				// wait for the audio_input_ready 
				if (audio_input_ready)
				begin
					state <= 4'd1 ; 
					audio_out <= f1_mac_new ; //f1_y_n1[17:2] ;	
				end
			end
			
			default:
			begin
				// default state is end state
				state <= 4'd15 ;
			end
		endcase
	end
end	

endmodule