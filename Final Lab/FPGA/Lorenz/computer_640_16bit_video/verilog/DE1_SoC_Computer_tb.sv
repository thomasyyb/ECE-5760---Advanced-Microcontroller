module DE1_SoC_Computer_tb();
	// Clock pins
logic						CLOCK_50;
logic						CLOCK2_50;
logic						CLOCK3_50;
logic						CLOCK4_50;

// ADC
logic						ADC_CS_N;
logic					ADC_DIN;
logic						ADC_DOUT;
logic					ADC_SCLK;

// Audio
logic						AUD_ADCDAT;
logic						AUD_ADCLRCK;
logic						AUD_BCLK;
logic					AUD_DACDAT;
logic						AUD_DACLRCK;
logic					AUD_XCK;

// SDRAM
logic 		[12: 0]	DRAM_ADDR;
logic		[ 1: 0]	DRAM_BA;
logic					DRAM_CAS_N;
logic					DRAM_CKE;
logic					DRAM_CLK;
logic					DRAM_CS_N;
logic			[15: 0]	DRAM_DQ;
logic					DRAM_LDQM;
logic					DRAM_RAS_N;
logic					DRAM_UDQM;
logic					DRAM_WE_N;

// I2C Bus for Configuration of the Audio and Video-In Chips
logic					FPGA_I2C_SCLK;
logic						FPGA_I2C_SDAT;

// 40-pin headers
logic			[35: 0]	GPIO_0;
logic			[35: 0]	GPIO_1;

// Seven Segment Displays
logic		[ 6: 0]	HEX0;
logic		[ 6: 0]	HEX1;
logic		[ 6: 0]	HEX2;
logic		[ 6: 0]	HEX3;
logic		[ 6: 0]	HEX4;
logic		[ 6: 0]	HEX5;

// IR
logic						IRDA_RXD;
logic					IRDA_TXD;

// Pushbuttons
logic			[ 3: 0]	KEY;

// LEDs
logic		[ 9: 0]	LEDR;

// PS2 Ports
logic						PS2_CLK;
logic						PS2_DAT;

logic						PS2_CLK2;
logic						PS2_DAT2;

// Slider Switches
logic			[ 9: 0]	SW;

// Video-In
logic						TD_CLK27;
logic			[ 7: 0]	TD_DATA;
logic						TD_HS;
logic					TD_RESET_N;
logic						TD_VS;

// VGA
logic		[ 7: 0]	VGA_B;
logic					VGA_BLANK_N;
logic					VGA_CLK;
logic		[ 7: 0]	VGA_G;
logic					VGA_HS;
logic		[ 7: 0]	VGA_R;
logic					VGA_SYNC_N;
logic					VGA_VS;



////////////////////////////////////
// HPS Pins
////////////////////////////////////
	
// DDR3 SDRAM
logic		[14: 0]	HPS_DDR3_ADDR;
logic		[ 2: 0]  HPS_DDR3_BA;
logic					HPS_DDR3_CAS_N;
logic					HPS_DDR3_CKE;
logic					HPS_DDR3_CK_N;
logic					HPS_DDR3_CK_P;
logic					HPS_DDR3_CS_N;
logic		[ 3: 0]	HPS_DDR3_DM;
logic			[31: 0]	HPS_DDR3_DQ;
logic			[ 3: 0]	HPS_DDR3_DQS_N;
logic			[ 3: 0]	HPS_DDR3_DQS_P;
logic					HPS_DDR3_ODT;
logic					HPS_DDR3_RAS_N;
logic					HPS_DDR3_RESET_N;
logic						HPS_DDR3_RZQ;
logic					HPS_DDR3_WE_N;

// Ethernet
logic					HPS_ENET_GTX_CLK;
logic						HPS_ENET_INT_N;
logic					HPS_ENET_MDC;
logic						HPS_ENET_MDIO;
logic						HPS_ENET_RX_CLK;
logic			[ 3: 0]	HPS_ENET_RX_DATA;
logic						HPS_ENET_RX_DV;
logic		[ 3: 0]	HPS_ENET_TX_DATA;
logic					HPS_ENET_TX_EN;

// Flash
logic			[ 3: 0]	HPS_FLASH_DATA;
logic					HPS_FLASH_DCLK;
logic					HPS_FLASH_NCSO;

// Accelerometer
logic						HPS_GSENSOR_INT;

// General Purpose I/O
logic			[ 1: 0]	HPS_GPIO;

// I2C
logic						HPS_I2C_CONTROL;
logic						HPS_I2C1_SCLK;
logic						HPS_I2C1_SDAT;
logic						HPS_I2C2_SCLK;
logic						HPS_I2C2_SDAT;

// Pushbutton
logic						HPS_KEY;

// LED
logic						HPS_LED;

// SD Card
logic					HPS_SD_CLK;
logic						HPS_SD_CMD;
logic			[ 3: 0]	HPS_SD_DATA;

// SPI
logic					HPS_SPIM_CLK;
logic						HPS_SPIM_MISO;
logic					HPS_SPIM_MOSI;
logic						HPS_SPIM_SS;

// UART
logic						HPS_UART_RX;
logic					HPS_UART_TX;

// USB
logic						HPS_CONV_USB_N;
logic						HPS_USB_CLKOUT;
logic			[ 7: 0]	HPS_USB_DATA;
logic						HPS_USB_DIR;
logic						HPS_USB_NXT;
logic					HPS_USB_STP;

DE1_SoC_Computer DUT (.*);

initial begin
	CLOCK_50 <= 0;
	forever #(50) CLOCK_50 <= ~CLOCK_50;
end


	
	initial begin
		@(posedge CLOCK_50);
		
		
		// note: need 'fix 7.20' format
		//sigma <= 10 << 20;
		//beta <= {7'h2, 20'hAAAAA}; //7d'2
		//rho <= 28 << 20;
		//dt <= {7'h0, 20'h01000};
		//x0 <= {7'h7F, 20'h00000};
		//y0 <= {7'h0, 20'h19999};
		//z0 <= 25 << 20;
		//SW[1] <= 0;  // integrator is reset low 
		//SW[0] <= 1;
		@(posedge CLOCK_50);
		
		SW[1] <= 1; 
		
		
		@(posedge CLOCK_50);
		repeat(5000) @(posedge CLOCK_50);
		SW[0] <= 0; @(posedge CLOCK_50);
		repeat(100)				@(posedge CLOCK_50);
		SW[0] <= 1; @(posedge CLOCK_50);
		repeat(5000) @(posedge CLOCK_50);
		
		
		$stop;
	
	end

endmodule 