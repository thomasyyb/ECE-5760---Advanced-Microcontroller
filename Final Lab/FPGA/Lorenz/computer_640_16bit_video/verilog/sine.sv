
//////////////////////////////////////////////////
////////////	Sin Wave ROM Table	//////////////
//////////////////////////////////////////////////
// produces a 2's comp, 16-bit, approximation
// of a sine wave, given an input phase (address)
module sync_rom (clock, address, sine, cosine);
	input clock;
	input [7:0] address;
	output [15:0] sine, cosine;
	reg signed [15:0] sine, cosine;
	always@(posedge clock)
		begin
			case(address)
					8'h00: begin sine = 16'h0000 ; cosine = 16'h3fff ; end
					8'h01: begin sine = 16'h0192 ; cosine = 16'h3ffa ; end
					8'h02: begin sine = 16'h0323 ; cosine = 16'h3feb ; end
					8'h03: begin sine = 16'h04b5 ; cosine = 16'h3fd2 ; end
					8'h04: begin sine = 16'h0645 ; cosine = 16'h3fb0 ; end
					8'h05: begin sine = 16'h07d5 ; cosine = 16'h3f83 ; end
					8'h06: begin sine = 16'h0963 ; cosine = 16'h3f4d ; end
					8'h07: begin sine = 16'h0af0 ; cosine = 16'h3f0d ; end
					8'h08: begin sine = 16'h0c7c ; cosine = 16'h3ec4 ; end
					8'h09: begin sine = 16'h0e05 ; cosine = 16'h3e70 ; end
					8'h0a: begin sine = 16'h0f8c ; cosine = 16'h3e14 ; end
					8'h0b: begin sine = 16'h1111 ; cosine = 16'h3dad ; end
					8'h0c: begin sine = 16'h1293 ; cosine = 16'h3d3d ; end
					8'h0d: begin sine = 16'h1413 ; cosine = 16'h3cc4 ; end
					8'h0e: begin sine = 16'h158f ; cosine = 16'h3c41 ; end
					8'h0f: begin sine = 16'h1708 ; cosine = 16'h3bb5 ; end
					8'h10: begin sine = 16'h187d ; cosine = 16'h3b1f ; end
					8'h11: begin sine = 16'h19ef ; cosine = 16'h3a81 ; end
					8'h12: begin sine = 16'h1b5c ; cosine = 16'h39da ; end
					8'h13: begin sine = 16'h1cc5 ; cosine = 16'h3929 ; end
					8'h14: begin sine = 16'h1e2a ; cosine = 16'h3870 ; end
					8'h15: begin sine = 16'h1f8b ; cosine = 16'h37ae ; end
					8'h16: begin sine = 16'h20e6 ; cosine = 16'h36e4 ; end
					8'h17: begin sine = 16'h223c ; cosine = 16'h3611 ; end
					8'h18: begin sine = 16'h238d ; cosine = 16'h3535 ; end
					8'h19: begin sine = 16'h24d9 ; cosine = 16'h3452 ; end
					8'h1a: begin sine = 16'h261f ; cosine = 16'h3366 ; end
					8'h1b: begin sine = 16'h275f ; cosine = 16'h3273 ; end
					8'h1c: begin sine = 16'h2899 ; cosine = 16'h3178 ; end
					8'h1d: begin sine = 16'h29cc ; cosine = 16'h3075 ; end
					8'h1e: begin sine = 16'h2afa ; cosine = 16'h2f6b ; end
					8'h1f: begin sine = 16'h2c20 ; cosine = 16'h2e59 ; end
					8'h20: begin sine = 16'h2d40 ; cosine = 16'h2d40 ; end
					8'h21: begin sine = 16'h2e59 ; cosine = 16'h2c20 ; end
					8'h22: begin sine = 16'h2f6b ; cosine = 16'h2afa ; end
					8'h23: begin sine = 16'h3075 ; cosine = 16'h29cc ; end
					8'h24: begin sine = 16'h3178 ; cosine = 16'h2899 ; end
					8'h25: begin sine = 16'h3273 ; cosine = 16'h275f ; end
					8'h26: begin sine = 16'h3366 ; cosine = 16'h261f ; end
					8'h27: begin sine = 16'h3452 ; cosine = 16'h24d9 ; end
					8'h28: begin sine = 16'h3535 ; cosine = 16'h238d ; end
					8'h29: begin sine = 16'h3611 ; cosine = 16'h223c ; end
					8'h2a: begin sine = 16'h36e4 ; cosine = 16'h20e6 ; end
					8'h2b: begin sine = 16'h37ae ; cosine = 16'h1f8b ; end
					8'h2c: begin sine = 16'h3870 ; cosine = 16'h1e2a ; end
					8'h2d: begin sine = 16'h3929 ; cosine = 16'h1cc5 ; end
					8'h2e: begin sine = 16'h39da ; cosine = 16'h1b5c ; end
					8'h2f: begin sine = 16'h3a81 ; cosine = 16'h19ef ; end
					8'h30: begin sine = 16'h3b1f ; cosine = 16'h187d ; end
					8'h31: begin sine = 16'h3bb5 ; cosine = 16'h1708 ; end
					8'h32: begin sine = 16'h3c41 ; cosine = 16'h158f ; end
					8'h33: begin sine = 16'h3cc4 ; cosine = 16'h1413 ; end
					8'h34: begin sine = 16'h3d3d ; cosine = 16'h1293 ; end
					8'h35: begin sine = 16'h3dad ; cosine = 16'h1111 ; end
					8'h36: begin sine = 16'h3e14 ; cosine = 16'h0f8c ; end
					8'h37: begin sine = 16'h3e70 ; cosine = 16'h0e05 ; end
					8'h38: begin sine = 16'h3ec4 ; cosine = 16'h0c7c ; end
					8'h39: begin sine = 16'h3f0d ; cosine = 16'h0af0 ; end
					8'h3a: begin sine = 16'h3f4d ; cosine = 16'h0963 ; end
					8'h3b: begin sine = 16'h3f83 ; cosine = 16'h07d5 ; end
					8'h3c: begin sine = 16'h3fb0 ; cosine = 16'h0645 ; end
					8'h3d: begin sine = 16'h3fd2 ; cosine = 16'h04b5 ; end
					8'h3e: begin sine = 16'h3feb ; cosine = 16'h0323 ; end
					8'h3f: begin sine = 16'h3ffa ; cosine = 16'h0192 ; end
					8'h40: begin sine = 16'h3fff ; cosine = 16'h0000 ;end
					8'h41: begin sine = 16'h3ffa ; cosine = 16'hfe6e ;end
					8'h42: begin sine = 16'h3feb ; cosine = 16'hfcdd ;end
					8'h43: begin sine = 16'h3fd2 ; cosine = 16'hfb4b ;end
					8'h44: begin sine = 16'h3fb0 ; cosine = 16'hf9bb ;end
					8'h45: begin sine = 16'h3f83 ; cosine = 16'hf82b ;end
					8'h46: begin sine = 16'h3f4d ; cosine = 16'hf69d ;end
					8'h47: begin sine = 16'h3f0d ; cosine = 16'hf510 ;end
					8'h48: begin sine = 16'h3ec4 ; cosine = 16'hf384 ;end
					8'h49: begin sine = 16'h3e70 ; cosine = 16'hf1fb ;end
					8'h4a: begin sine = 16'h3e14 ; cosine = 16'hf074 ;end
					8'h4b: begin sine = 16'h3dad ; cosine = 16'heeef ;end
					8'h4c: begin sine = 16'h3d3d ; cosine = 16'hed6d ;end
					8'h4d: begin sine = 16'h3cc4 ; cosine = 16'hebed ;end
					8'h4e: begin sine = 16'h3c41 ; cosine = 16'hea71 ;end
					8'h4f: begin sine = 16'h3bb5 ; cosine = 16'he8f8 ;end
					8'h50: begin sine = 16'h3b1f ; cosine = 16'he783 ;end
					8'h51: begin sine = 16'h3a81 ; cosine = 16'he611 ;end
					8'h52: begin sine = 16'h39da ; cosine = 16'he4a4 ;end
					8'h53: begin sine = 16'h3929 ; cosine = 16'he33b ;end
					8'h54: begin sine = 16'h3870 ; cosine = 16'he1d6 ;end
					8'h55: begin sine = 16'h37ae ; cosine = 16'he075 ;end
					8'h56: begin sine = 16'h36e4 ; cosine = 16'hdf1a ;end
					8'h57: begin sine = 16'h3611 ; cosine = 16'hddc4 ;end
					8'h58: begin sine = 16'h3535 ; cosine = 16'hdc73 ;end
					8'h59: begin sine = 16'h3452 ; cosine = 16'hdb27 ;end
					8'h5a: begin sine = 16'h3366 ; cosine = 16'hd9e1 ;end
					8'h5b: begin sine = 16'h3273 ; cosine = 16'hd8a1 ;end
					8'h5c: begin sine = 16'h3178 ; cosine = 16'hd767 ;end
					8'h5d: begin sine = 16'h3075 ; cosine = 16'hd634 ;end
					8'h5e: begin sine = 16'h2f6b ; cosine = 16'hd506 ;end
					8'h5f: begin sine = 16'h2e59 ; cosine = 16'hd3e0 ;end
					8'h60: begin sine = 16'h2d40 ; cosine = 16'hd2c0 ;end
					8'h61: begin sine = 16'h2c20 ; cosine = 16'hd1a7 ;end
					8'h62: begin sine = 16'h2afa ; cosine = 16'hd095 ;end
					8'h63: begin sine = 16'h29cc ; cosine = 16'hcf8b ;end
					8'h64: begin sine = 16'h2899 ; cosine = 16'hce88 ;end
					8'h65: begin sine = 16'h275f ; cosine = 16'hcd8d ;end
					8'h66: begin sine = 16'h261f ; cosine = 16'hcc9a ;end
					8'h67: begin sine = 16'h24d9 ; cosine = 16'hcbae ;end
					8'h68: begin sine = 16'h238d ; cosine = 16'hcacb ;end
					8'h69: begin sine = 16'h223c ; cosine = 16'hc9ef ;end
					8'h6a: begin sine = 16'h20e6 ; cosine = 16'hc91c ;end
					8'h6b: begin sine = 16'h1f8b ; cosine = 16'hc852 ;end
					8'h6c: begin sine = 16'h1e2a ; cosine = 16'hc790 ;end
					8'h6d: begin sine = 16'h1cc5 ; cosine = 16'hc6d7 ;end
					8'h6e: begin sine = 16'h1b5c ; cosine = 16'hc626 ;end
					8'h6f: begin sine = 16'h19ef ; cosine = 16'hc57f ;end
					8'h70: begin sine = 16'h187d ; cosine = 16'hc4e1 ;end
					8'h71: begin sine = 16'h1708 ; cosine = 16'hc44b ;end
					8'h72: begin sine = 16'h158f ; cosine = 16'hc3bf ;end
					8'h73: begin sine = 16'h1413 ; cosine = 16'hc33c ;end
					8'h74: begin sine = 16'h1293 ; cosine = 16'hc2c3 ;end
					8'h75: begin sine = 16'h1111 ; cosine = 16'hc253 ;end
					8'h76: begin sine = 16'h0f8c ; cosine = 16'hc1ec ;end
					8'h77: begin sine = 16'h0e05 ; cosine = 16'hc190 ;end
					8'h78: begin sine = 16'h0c7c ; cosine = 16'hc13c ;end
					8'h79: begin sine = 16'h0af0 ; cosine = 16'hc0f3 ;end
					8'h7a: begin sine = 16'h0963 ; cosine = 16'hc0b3 ;end
					8'h7b: begin sine = 16'h07d5 ; cosine = 16'hc07d ;end
					8'h7c: begin sine = 16'h0645 ; cosine = 16'hc050 ;end
					8'h7d: begin sine = 16'h04b5 ; cosine = 16'hc02e ;end
					8'h7e: begin sine = 16'h0323 ; cosine = 16'hc015 ;end
					8'h7f: begin sine = 16'h0192 ; cosine = 16'hc006 ;end
					8'h80: begin sine = 16'h0000 ; cosine = 16'hc001 ;end
					8'h81: begin sine = 16'hfe6e ; cosine = 16'hc006 ;end
					8'h82: begin sine = 16'hfcdd ; cosine = 16'hc015 ;end
					8'h83: begin sine = 16'hfb4b ; cosine = 16'hc02e ;end
					8'h84: begin sine = 16'hf9bb ; cosine = 16'hc050 ;end
					8'h85: begin sine = 16'hf82b ; cosine = 16'hc07d ;end
					8'h86: begin sine = 16'hf69d ; cosine = 16'hc0b3 ;end
					8'h87: begin sine = 16'hf510 ; cosine = 16'hc0f3 ;end
					8'h88: begin sine = 16'hf384 ; cosine = 16'hc13c ;end
					8'h89: begin sine = 16'hf1fb ; cosine = 16'hc190 ;end
					8'h8a: begin sine = 16'hf074 ; cosine = 16'hc1ec ;end
					8'h8b: begin sine = 16'heeef ; cosine = 16'hc253 ;end
					8'h8c: begin sine = 16'hed6d ; cosine = 16'hc2c3 ;end
					8'h8d: begin sine = 16'hebed ; cosine = 16'hc33c ;end
					8'h8e: begin sine = 16'hea71 ; cosine = 16'hc3bf ;end
					8'h8f: begin sine = 16'he8f8 ; cosine = 16'hc44b ;end
					8'h90: begin sine = 16'he783 ; cosine = 16'hc4e1 ;end
					8'h91: begin sine = 16'he611 ; cosine = 16'hc57f ;end
					8'h92: begin sine = 16'he4a4 ; cosine = 16'hc626 ;end
					8'h93: begin sine = 16'he33b ; cosine = 16'hc6d7 ;end
					8'h94: begin sine = 16'he1d6 ; cosine = 16'hc790 ;end
					8'h95: begin sine = 16'he075 ; cosine = 16'hc852 ;end
					8'h96: begin sine = 16'hdf1a ; cosine = 16'hc91c ;end
					8'h97: begin sine = 16'hddc4 ; cosine = 16'hc9ef ;end
					8'h98: begin sine = 16'hdc73 ; cosine = 16'hcacb ;end
					8'h99: begin sine = 16'hdb27 ; cosine = 16'hcbae ;end
					8'h9a: begin sine = 16'hd9e1 ; cosine = 16'hcc9a ;end
					8'h9b: begin sine = 16'hd8a1 ; cosine = 16'hcd8d ;end
					8'h9c: begin sine = 16'hd767 ; cosine = 16'hce88 ;end
					8'h9d: begin sine = 16'hd634 ; cosine = 16'hcf8b ;end
					8'h9e: begin sine = 16'hd506 ; cosine = 16'hd095 ;end
					8'h9f: begin sine = 16'hd3e0 ; cosine = 16'hd1a7 ;end
					8'ha0: begin sine = 16'hd2c0 ; cosine = 16'hd2c0 ;end
					8'ha1: begin sine = 16'hd1a7 ; cosine = 16'hd3e0 ;end
					8'ha2: begin sine = 16'hd095 ; cosine = 16'hd506 ;end
					8'ha3: begin sine = 16'hcf8b ; cosine = 16'hd634 ;end
					8'ha4: begin sine = 16'hce88 ; cosine = 16'hd767 ;end
					8'ha5: begin sine = 16'hcd8d ; cosine = 16'hd8a1 ;end
					8'ha6: begin sine = 16'hcc9a ; cosine = 16'hd9e1 ;end
					8'ha7: begin sine = 16'hcbae ; cosine = 16'hdb27 ;end
					8'ha8: begin sine = 16'hcacb ; cosine = 16'hdc73 ;end
					8'ha9: begin sine = 16'hc9ef ; cosine = 16'hddc4 ;end
					8'haa: begin sine = 16'hc91c ; cosine = 16'hdf1a ;end
					8'hab: begin sine = 16'hc852 ; cosine = 16'he075 ;end
					8'hac: begin sine = 16'hc790 ; cosine = 16'he1d6 ;end
					8'had: begin sine = 16'hc6d7 ; cosine = 16'he33b ;end
					8'hae: begin sine = 16'hc626 ; cosine = 16'he4a4 ;end
					8'haf: begin sine = 16'hc57f ; cosine = 16'he611 ;end
					8'hb0: begin sine = 16'hc4e1 ; cosine = 16'he783 ;end
					8'hb1: begin sine = 16'hc44b ; cosine = 16'he8f8 ;end
					8'hb2: begin sine = 16'hc3bf ; cosine = 16'hea71 ;end
					8'hb3: begin sine = 16'hc33c ; cosine = 16'hebed ;end
					8'hb4: begin sine = 16'hc2c3 ; cosine = 16'hed6d ;end
					8'hb5: begin sine = 16'hc253 ; cosine = 16'heeef ;end
					8'hb6: begin sine = 16'hc1ec ; cosine = 16'hf074 ;end
					8'hb7: begin sine = 16'hc190 ; cosine = 16'hf1fb ;end
					8'hb8: begin sine = 16'hc13c ; cosine = 16'hf384 ;end
					8'hb9: begin sine = 16'hc0f3 ; cosine = 16'hf510 ;end
					8'hba: begin sine = 16'hc0b3 ; cosine = 16'hf69d ;end
					8'hbb: begin sine = 16'hc07d ; cosine = 16'hf82b ;end
					8'hbc: begin sine = 16'hc050 ; cosine = 16'hf9bb ;end
					8'hbd: begin sine = 16'hc02e ; cosine = 16'hfb4b ;end
					8'hbe: begin sine = 16'hc015 ; cosine = 16'hfcdd ;end
					8'hbf: begin sine = 16'hc006 ; cosine = 16'hfe6e ;end
					8'hc0: begin sine = 16'hc001 ; cosine = 16'h0000 ; end
					8'hc1: begin sine = 16'hc006 ; cosine = 16'h0192 ; end
					8'hc2: begin sine = 16'hc015 ; cosine = 16'h0323 ; end
					8'hc3: begin sine = 16'hc02e ; cosine = 16'h04b5 ; end
					8'hc4: begin sine = 16'hc050 ; cosine = 16'h0645 ; end
					8'hc5: begin sine = 16'hc07d ; cosine = 16'h07d5 ; end
					8'hc6: begin sine = 16'hc0b3 ; cosine = 16'h0963 ; end
					8'hc7: begin sine = 16'hc0f3 ; cosine = 16'h0af0 ; end
					8'hc8: begin sine = 16'hc13c ; cosine = 16'h0c7c ; end
					8'hc9: begin sine = 16'hc190 ; cosine = 16'h0e05 ; end
					8'hca: begin sine = 16'hc1ec ; cosine = 16'h0f8c ; end
					8'hcb: begin sine = 16'hc253 ; cosine = 16'h1111 ; end
					8'hcc: begin sine = 16'hc2c3 ; cosine = 16'h1293 ; end
					8'hcd: begin sine = 16'hc33c ; cosine = 16'h1413 ; end
					8'hce: begin sine = 16'hc3bf ; cosine = 16'h158f ; end
					8'hcf: begin sine = 16'hc44b ; cosine = 16'h1708 ; end
					8'hd0: begin sine = 16'hc4e1 ; cosine = 16'h187d ; end
					8'hd1: begin sine = 16'hc57f ; cosine = 16'h19ef ; end
					8'hd2: begin sine = 16'hc626 ; cosine = 16'h1b5c ; end
					8'hd3: begin sine = 16'hc6d7 ; cosine = 16'h1cc5 ; end
					8'hd4: begin sine = 16'hc790 ; cosine = 16'h1e2a ; end
					8'hd5: begin sine = 16'hc852 ; cosine = 16'h1f8b ; end
					8'hd6: begin sine = 16'hc91c ; cosine = 16'h20e6 ; end
					8'hd7: begin sine = 16'hc9ef ; cosine = 16'h223c ; end
					8'hd8: begin sine = 16'hcacb ; cosine = 16'h238d ; end
					8'hd9: begin sine = 16'hcbae ; cosine = 16'h24d9 ; end
					8'hda: begin sine = 16'hcc9a ; cosine = 16'h261f ; end
					8'hdb: begin sine = 16'hcd8d ; cosine = 16'h275f ; end
					8'hdc: begin sine = 16'hce88 ; cosine = 16'h2899 ; end
					8'hdd: begin sine = 16'hcf8b ; cosine = 16'h29cc ; end
					8'hde: begin sine = 16'hd095 ; cosine = 16'h2afa ; end
					8'hdf: begin sine = 16'hd1a7 ; cosine = 16'h2c20 ; end
					8'he0: begin sine = 16'hd2c0 ; cosine = 16'h2d40 ; end
					8'he1: begin sine = 16'hd3e0 ; cosine = 16'h2e59 ; end
					8'he2: begin sine = 16'hd506 ; cosine = 16'h2f6b ; end
					8'he3: begin sine = 16'hd634 ; cosine = 16'h3075 ; end
					8'he4: begin sine = 16'hd767 ; cosine = 16'h3178 ; end
					8'he5: begin sine = 16'hd8a1 ; cosine = 16'h3273 ; end
					8'he6: begin sine = 16'hd9e1 ; cosine = 16'h3366 ; end
					8'he7: begin sine = 16'hdb27 ; cosine = 16'h3452 ; end
					8'he8: begin sine = 16'hdc73 ; cosine = 16'h3535 ; end
					8'he9: begin sine = 16'hddc4 ; cosine = 16'h3611 ; end
					8'hea: begin sine = 16'hdf1a ; cosine = 16'h36e4 ; end
					8'heb: begin sine = 16'he075 ; cosine = 16'h37ae ; end
					8'hec: begin sine = 16'he1d6 ; cosine = 16'h3870 ; end
					8'hed: begin sine = 16'he33b ; cosine = 16'h3929 ; end
					8'hee: begin sine = 16'he4a4 ; cosine = 16'h39da ; end
					8'hef: begin sine = 16'he611 ; cosine = 16'h3a81 ; end
					8'hf0: begin sine = 16'he783 ; cosine = 16'h3b1f ; end
					8'hf1: begin sine = 16'he8f8 ; cosine = 16'h3bb5 ; end
					8'hf2: begin sine = 16'hea71 ; cosine = 16'h3c41 ; end
					8'hf3: begin sine = 16'hebed ; cosine = 16'h3cc4 ; end
					8'hf4: begin sine = 16'hed6d ; cosine = 16'h3d3d ; end
					8'hf5: begin sine = 16'heeef ; cosine = 16'h3dad ; end
					8'hf6: begin sine = 16'hf074 ; cosine = 16'h3e14 ; end
					8'hf7: begin sine = 16'hf1fb ; cosine = 16'h3e70 ; end
					8'hf8: begin sine = 16'hf384 ; cosine = 16'h3ec4 ; end
					8'hf9: begin sine = 16'hf510 ; cosine = 16'h3f0d ; end
					8'hfa: begin sine = 16'hf69d ; cosine = 16'h3f4d ; end
					8'hfb: begin sine = 16'hf82b ; cosine = 16'h3f83 ; end
					8'hfc: begin sine = 16'hf9bb ; cosine = 16'h3fb0 ; end
					8'hfd: begin sine = 16'hfb4b ; cosine = 16'h3fd2 ; end
					8'hfe: begin sine = 16'hfcdd ; cosine = 16'h3feb ; end
					8'hff: begin sine = 16'hfe6e ; cosine = 16'h3ffa ; end
			endcase
		end
endmodule
