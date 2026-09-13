//This module encapsulates all Analogizer adapter signals
// Original work by @RndMnkIII. 
// Date: 05/2024 
// Releases: 
// 1.0 Initial RGBS output mode
// 1.1 Added SOG modes: RGsB, YPbPt
// 1.2 Added Mike Simon Y/C module, Scandoubler SVGA Mist module.     

// *** Analogizer R.2 adapter ***
// * WHEN SOG SWITCH IS IN ON POSITION, OUTPUTS CSYNC ON G CHANNEL
// # WHEN YPbPr VIDEO OUTPUT IS SELECTED, Y->G, Pr->R, Pb->B
//Pin mappings:                                               VGA CONNECTOR                                                                                          USB3 TYPE A FEMALE CONNECTOR (SNAC)
//                        ______________________________________________________________________________________________________________________________________________________________________________________________________                             
//                       /                              VS  HS          R#  G*# B#                                                                  1      2       3       4      5       6       7       8       9              \
//                       |                              |   |           |   |   |                                                                 VBUS   D-      D+      GND     RX-     RX+     GND_D   TX-     TX+             |
//FUNCTION:              |                              |   |           |   |   |                                                                 +5V    OUT1    OUT2    GND     IO3     IN4     IO5     IO6     IN7             |
//                       |  A                           |   |           |   |   |                                                                          ^       ^              ^       |       ^       ^       |              |
//                       |  N             SOG           |   |           |   |   |                                                                          |       |              V       V       V       V       V              |
//                       |  A           -------         |   |           |   |   |                                                                                                                                                |                              
//                       |  O    OFF   |   S   |--GND   |   |         +------------+                                                                                                                                             |
//                       |  L          |   W   |        |   |   SYNC  |            |                                                                                                                                             |            
//  PIN DIR:             |  G          |   I   +--------------------->|            |---------------------------------------------------------------------------------------------------------+                                   |
//  ^ OUTPUT             |  I          |   T   |        |   |         |  RGB DAC   |                                                                                                         |                                   |
//  V INPUT              |  Z          |   C   |        |   |         |            |===================================================================++                                    |                                   |
//                       |  E    ON ===|   H   |--------+   |         +------------+                                                                   ||                                    |                                   |
//                       |  R           -------         |   |            ||  |   | /BLANK                                                              ||                                    |                                   |         
//                       |                              |   +--------+   ||  |   +------------------------------------------------------------------+  ||                                    |                                   |                                  |
//                       |  R                           +------+     |   ||  +===============================++                                     |  ||                                    |                                   |
//                       |  2                                  |     |   ||                                  ||                                     |  ||                                    |                                   |
//                       |     CONF.B        IO5V       ---    |     |   \\================================  \\================================     |  \\================================   VID               IO3^  IO6^         |  
//                       |     CONF.A   IN4  ---  IN7   IO3V   VS    HS    R0    R1    R2    R3    R4    R5    G0    G1    G2    G3    G4    G5   /BLK   B0    B1    B2    B3    B4    B5   CLK  OUT1   OUT2  IO5^  IO6V         |  
//                       |      __3.3V__ |___ | __ |_____|_____|_____|_____|_____|_____|_____|_____|_____|_____|_____|_____|_____|_____|_____|_____|_____|_____|_____|_____|_____|_____|_____|_____|_____|_____|_____^__GND__    |                                
//POCKET                 |     /         V    V    V     V     ^     ^     ^     ^     ^     ^     ^     ^     ^     ^     ^     ^     ^     ^     ^     ^     ^     ^     ^     ^     ^     ^     ^     ^     ^     V       \   | 
//CARTRIDGE PIN #:       \____|     1    2    3    4     5     6     7     8     9    10    11    12    13    14    15    16    17    18    19    20    21    22    23    24    25    26    27    28    29    30    31   32  |___/
//                             \_________|____|____|_____|_____|_____|_____|_____|_____|_____|_____|_____|_____|_____|_____|_____|_____|_____|_____|_____|_____|_____|_____|_____|_____|_____|_____|_____|_____|_____|_______/
//Pocket Pin Name:                       |    |    |     |     |     |     |     |     |     |     |     |     |     |     |     |     |     |     |     |     |     |     |     |     |     |     |     |     |     | 
//cart_tran_bank0[7] --------------------+    |    |     |     |     |     |     |     |     |     |     |     |     |     |     |     |     |     |     |     |     |     |     |     |     |     |     |     |     | 
//cart_tran_bank0[6] -------------------------+    |     |     |     |     |     |     |     |     |     |     |     |     |     |     |     |     |     |     |     |     |     |     |     |     |     |     |     |
//cart_tran_bank0[5] ------------------------------+     |     |     |     |     |     |     |     |     |     |     |     |     |     |     |     |     |     |     |     |     |     |     |     |     |     |     |
//cart_tran_bank0[4] ------------------------------------+     |     |     |     |     |     |     |     |     |     |     |     |     |     |     |     |     |     |     |     |     |     |     |     |     |     |
//cart_tran_bank3[0] ------------------------------------------+     |     |     |     |     |     |     |     |     |     |     |     |     |     |     |     |     |     |     |     |     |     |     |     |     | 
//cart_tran_bank3[1] ------------------------------------------------+     |     |     |     |     |     |     |     |     |     |     |     |     |     |     |     |     |     |     |     |     |     |     |     |     
//cart_tran_bank3[2] ------------------------------------------------------+     |     |     |     |     |     |     |     |     |     |     |     |     |     |     |     |     |     |     |     |     |     |     |
//cart_tran_bank3[3] ------------------------------------------------------------+     |     |     |     |     |     |     |     |     |     |     |     |     |     |     |     |     |     |     |     |     |     |
//cart_tran_bank3[4] ------------------------------------------------------------------+     |     |     |     |     |     |     |     |     |     |     |     |     |     |     |     |     |     |     |     |     |
//cart_tran_bank3[5] ------------------------------------------------------------------------+     |     |     |     |     |     |     |     |     |     |     |     |     |     |     |     |     |     |     |     |
//cart_tran_bank3[6] ------------------------------------------------------------------------------+     |     |     |     |     |     |     |     |     |     |     |     |     |     |     |     |     |     |     |
//cart_tran_bank3[7] ------------------------------------------------------------------------------------+     |     |     |     |     |     |     |     |     |     |     |     |     |     |     |     |     |     |
//------------------                                                                                           |     |     |     |     |     |     |     |     |     |     |     |     |     |     |     |     |     |
//cart_tran_bank2[0] ------------------------------------------------------------------------------------------+     |     |     |     |     |     |     |     |     |     |     |     |     |     |     |     |     |     
//cart_tran_bank2[1] ------------------------------------------------------------------------------------------------+     |     |     |     |     |     |     |     |     |     |     |     |     |     |     |     |
//cart_tran_bank2[2] ------------------------------------------------------------------------------------------------------+     |     |     |     |     |     |     |     |     |     |     |     |     |     |     |
//cart_tran_bank2[3] ------------------------------------------------------------------------------------------------------------+     |     |     |     |     |     |     |     |     |     |     |     |     |     |
//cart_tran_bank2[4] ------------------------------------------------------------------------------------------------------------------+     |     |     |     |     |     |     |     |     |     |     |     |     |
//cart_tran_bank2[5] ------------------------------------------------------------------------------------------------------------------------+     |     |     |     |     |     |     |     |     |     |     |     |
//cart_tran_bank2[6] ------------------------------------------------------------------------------------------------------------------------------+     |     |     |     |     |     |     |     |     |     |     |
//cart_tran_bank2[7] ------------------------------------------------------------------------------------------------------------------------------------+     |     |     |     |     |     |     |     |     |     |                                   
//------------------                                                                                                                                           |     |     |     |     |     |     |     |     |     |
//cart_tran_bank1[0] ------------------------------------------------------------------------------------------------------------------------------------------+     |     |     |     |     |     |     |     |     |
//cart_tran_bank1[1] ------------------------------------------------------------------------------------------------------------------------------------------------+     |     |     |     |     |     |     |     |
//cart_tran_bank1[2] ------------------------------------------------------------------------------------------------------------------------------------------------------+     |     |     |     |     |     |     |
//cart_tran_bank1[3] ------------------------------------------------------------------------------------------------------------------------------------------------------------+     |     |     |     |     |     |
//cart_tran_bank1[4] ------------------------------------------------------------------------------------------------------------------------------------------------------------------+     |     |     |     |     |
//cart_tran_bank1[5] ------------------------------------------------------------------------------------------------------------------------------------------------------------------------+     |     |     |     |
//cart_tran_bank1[6] ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+     |     |     |
//cart_tran_bank1[7] ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+     |     |
//cart_tran_pin30    ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+     | 
//cart_tran_pin31    ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
`default_nettype none
`timescale 1ns / 1ps

// EN_YPBPR / EN_YC gate the analog *output encoders*.  They default to 1 so
// every existing consumer keeps full functionality; a resource-constrained
// core that only outputs RGBS/RGsB/VGA (scandoubler) can set them to 0 to drop
// the YPbPr (vga_out, ~230-400 ALMs) and Y/C composite (yc_out, ~400-490 ALMs)
// encoders entirely.  When 0 the corresponding mode-mux inputs are tied off, so
// selecting a YPbPr/Y-C video_type just outputs black instead of the encoder.
module openFPGA_Pocket_Analogizer #(
	parameter MASTER_CLK_FREQ=50_000_000,
	parameter EN_YPBPR=1,
	parameter EN_YC=1
) (
	input wire i_clk,
    input wire i_rst,
	input wire i_ena,
	//Video interface
	input wire video_clk,
	input wire [3:0] analog_video_type,
	input wire [7:0] R,
	input wire [7:0] G,
	input wire [7:0] B,
	input wire Hblank,
	input wire Vblank,
	input wire BLANKn,
	input wire Hsync,
	input wire Vsync,
	input wire Csync,
	//Video SVGA Scandoubler interface (internal scandoubler re-instated)
	input wire ce_pix,
	input wire scandoubler, //logic for disable/enable the scandoubler
	input wire [2:0] fx, //0 disable, 1 scanlines 25%, 2 50%, 3 75%, 4 hq2x
	//Video Y/C Encoder interface
	input wire [39:0] CHROMA_PHASE_INC,
	input wire PALFLAG,
	// SNAC cart pin pass-through (driven by CPU SNAC shifter/GPIO)
	input wire [7:4] snac_bank0_out,     // CPU-driven output values for bank0[7:4]
	input wire       snac_bank0_dir,     // 1=output, 0=input (whole nibble)
	input wire [7:6] snac_bank1_76_out,  // CPU-driven output values for bank1[7:6]
	input wire       snac_enable,        // keep OUT1/OUT2 alive even when analog video is off
	input wire       snac_pin30_out,
	input wire       snac_pin30_dir,
	input wire       snac_pin31_out,
	input wire       snac_pin31_dir,
	// Pocket Analogizer IO interface: video output on bank1-3.
	inout   wire    [7:0]   cart_tran_bank2,
	output  wire            cart_tran_bank2_dir,
	inout   wire    [7:0]   cart_tran_bank3,
	output  wire            cart_tran_bank3_dir,
	inout   wire    [7:0]   cart_tran_bank1,
	output  wire            cart_tran_bank1_dir
);
	// RndMnkIII Analogizer/SNAC physical pinout.  The OS-side raw shifter
	// or optional PSX poller drives these pass-through pins.
	wire [7:4] CART_BK0_OUT    = snac_bank0_out;
	wire       CART_BK0_DIR    = snac_bank0_dir;
	wire [7:6] CART_BK1_OUT_P76 = snac_bank1_76_out;
	wire       CART_PIN30_OUT  = snac_pin30_out;
	wire       CART_PIN30_DIR  = snac_pin30_dir;
	wire       CART_PIN31_OUT  = snac_pin31_out;
	wire       CART_PIN31_DIR  = snac_pin31_dir;


	//Choose type of analog video type of signal
		reg [5:0] Rout, Gout, Bout;
		reg HsyncOut, VsyncOut, BLANKnOut;
		wire [7:0] Yout, PrOut, PbOut;
		wire [5:0] R_Sd, G_Sd, B_Sd;
		wire Hsync_Sd, Vsync_Sd;
		wire Hblank_Sd, Vblank_Sd;
		wire BLANKn_SD = ~(Hblank_Sd || Vblank_Sd);

	always @(*) begin
		case(analog_video_type)
			4'h0, 4'h8: begin //RGBS
				Rout = R[7:2]&{6{BLANKn}};
				Gout = G[7:2]&{6{BLANKn}};
				Bout = B[7:2]&{6{BLANKn}};
				HsyncOut = Csync;
				VsyncOut = 1'b1;
				BLANKnOut = BLANKn;
			end
			4'h3, 4'h4, 4'hB, 4'hC: begin// Y/C Modes works for Analogizer R1, R2 Adapters
				Rout = yc_o[23:18];
				Gout = yc_o[15:10];
				Bout = yc_o[7:2];
				HsyncOut = yc_cs;
				VsyncOut = 1'b1;
				BLANKnOut = 1'b1;
			end
			4'h1, 4'h9: begin //RGsB
				Rout = R[7:2]&{6{BLANKn}};
				Gout = G[7:2]&{6{BLANKn}};
				Bout = B[7:2]&{6{BLANKn}};
				HsyncOut = 1'b1;
				VsyncOut = Csync;
				BLANKnOut = BLANKn;
			end
			4'h2, 4'hA: begin //YPbPr
				Rout = PrOut[7:2];
				Gout = Yout[7:2];
				Bout = PbOut[7:2];
				HsyncOut = 1'b1;
				VsyncOut = YPbPr_sync;
				BLANKnOut = 1'b1;
			end
			4'h5, 4'h6, 4'h7, 4'hD, 4'hE, 4'hF: begin //Scandoubler modes
				Rout = R_Sd;
				Gout = G_Sd;
				Bout = B_Sd;
				HsyncOut = Hsync_Sd;
				VsyncOut = Vsync_Sd;
				BLANKnOut = BLANKn_SD;
			end
			default: begin
				Rout = 6'h0;
				Gout = 6'h0;
				Bout = 6'h0;
				HsyncOut = Hsync;
				VsyncOut = 1'b1;
				BLANKnOut = BLANKn;
			end
		endcase
	end

	//First Stage: video fix
	// wire hs_fix,vs_fix;
	// sync_fix sync_v(video_clk, HSync, hs_fix);
	// sync_fix sync_h(video_clk, VSync, vs_fix);

	// reg [DW-1:0] RGB_fix;

	// reg CE_fix,HS_fix,VS_fix,HBL_fix,VBL_fix;
	// always @(posedge video_clk) begin
	// 	reg old_ce;
	// 	old_ce <= ce_pix;
	// 	CE_fix <= 0;
	// 	if(~old_ce & ce_pix) begin
	// 		CE_fix <= 1;
	// 		HS_fix <= hs_fix;
	// 		if(~HS_fix & hs_fix) VS_fix <= vs_fix;

	// 		RGB_fix <= {R,G,B};
	// 		HBL_fix <= HBlank;
	// 		if(HBL_fix & ~HBlank) VBL_fix <= VBlank;
	// 	end
	// end

	// //Csync generation
	// wire CSYNC_fix;
	// csync csync_fix(video_clk, HS_fix, VS_fix, CSYNC_fix);

	wire YPbPr_sync, YPbPr_blank;
	generate if (EN_YPBPR) begin : g_ypbpr
		vga_out ybpr_video
		(
			.clk(video_clk),
			.ypbpr_en(1'b1),
			.csync(Csync),
			.de(BLANKn),
			.din({R&{8{BLANKn}},G&{8{BLANKn}},B&{8{BLANKn}}}), //NES specific override, because not zero color data while blanking period.
			.dout({PrOut,Yout,PbOut}),
			.csync_o(YPbPr_sync),
			.de_o(YPbPr_blank)
		);
	end else begin : g_no_ypbpr
		assign {PrOut,Yout,PbOut} = 24'd0;
		assign YPbPr_sync  = 1'b0;
		assign YPbPr_blank = 1'b0;
	end endgenerate

		wire [23:0] yc_o;
		//wire yc_hs, yc_vs,
		wire yc_cs;
	generate if (EN_YC) begin : g_yc
		yc_out yc_out
		(
			.clk(i_clk),
			.PHASE_INC(CHROMA_PHASE_INC),
			.PAL_EN(PALFLAG),
			.hsync(Hsync),
			.vsync(Vsync),
			.csync(Csync),
	    	.din({R&{8{BLANKn}},G&{8{BLANKn}},B&{8{BLANKn}}}),
			.dout(yc_o),
			.hsync_o(),
			.vsync_o(),
			.csync_o(yc_cs)
		);
	end else begin : g_no_yc
		assign yc_o  = 24'd0;
		assign yc_cs = 1'b0;
	end endgenerate

	// Internal scandoubler (upstream Analogizer): when `scandoubler`=1 it
	// line-doubles a 240p source to 480p; when `scandoubler`=0 it BYPASSES
	// (passes the input straight through), for a source that is already at the
	// output resolution (openfpgaOS drives the Analogizer from the 640x480/31 kHz
	// LCD video, so it bypasses).  pixel_ena is left UNCONNECTED and the DAC
	// clock at the cart pin is the real PLL clock video_clk (see cart_video_clk
	// below) — NOT a logic-derived enable.  Routing a logic enable onto the DAC
	// clock pin is off the clock network with the wrong duty cycle: it sims fine
	// but gives a dark VGA on hardware.
	scandoubler #(
		.HCNT_WIDTH(10),
		.COLOR_DEPTH(6),
		.OUT_COLOR_DEPTH(6)
	) sc_video (
		.clk_sys(i_clk),
		.bypass(~scandoubler),
		.ce_divider(3'd3),
		.pixel_ena(),
		.scanlines(fx[1:0]),
		.hb_in(Hblank),
		.vb_in(Vblank),
		.hs_in(Hsync),
		.vs_in(Vsync),
		.r_in(R[7:2] & {6{BLANKn}}),
		.g_in(G[7:2] & {6{BLANKn}}),
		.b_in(B[7:2] & {6{BLANKn}}),
		.hb_out(Hblank_Sd),
		.vb_out(Vblank_Sd),
		.hs_out(Hsync_Sd),
		.vs_out(Vsync_Sd),
		.r_out(R_Sd),
		.g_out(G_Sd),
		.b_out(B_Sd)
	);

	// =====================================================================
	// OS25 ANALOGIZER DIAG V2
	// Standalone PocketDoom-style 240p RGBS generator.
	//
	// This deliberately bypasses:
	//   * app framebuffer / OpenJazz
	//   * OS25 dedicated analog raster
	//   * normal Analogizer R/G/B/sync inputs
	//   * menu settings and source selection
	//
	// V1 core_top supplies video_clk = clk_core_12288, matching PocketDoom.
	//
	// Timing:
	//   H: 58 sync + 62 back + 640 active + 20 front = 780 clocks
	//   V:  3 sync + 15 back + 240 active +  4 front = 262 lines
	//   12.288 MHz / 780 = ~15.754 kHz H
	//   12.288 MHz / 780 / 262 = ~60.13 Hz V

	// =====================================================================

	// OS25 ANALOGIZER V10 BLANKING-CLEANUP
	//
	// Goal: keep the exact stable progressive frame period from V8, but stop
	// varying the horizontal period on VISIBLE lines.  The V8 build solved the
	// vertical shake by distributing 781/782-clock lines across the whole
	// frame, which can show up on an analog CRT as slight line-to-line
	// horizontal phase variation in sharp menu text.
	//
	// Exact source-frame duration at video_clk:
	//   24.576 MHz / 780 / 525 = 60.014652 Hz source
	//   video_clk = 12.288 MHz
	//   clocks per source frame = 204750
	//
	// Keep a TRUE progressive 262-line frame every time:
	//   240 active lines x 781 clocks = 187440
	//   remaining blanking clocks     =  17310
	//
	// Put ALL variable-length lines in VERTICAL BLANKING ONLY:
	//   4 lines  x 786 clocks =  3144   (front porch)
	//   18 lines x 787 clocks = 14166   (sync + back porch)
	//   total blanking clocks = 17310
	//
	// Total frame clocks:
	//   187440 + 17310 = 204750 exact
	//
	// Visible lines are therefore all identical 781-clock lines, so the CRT
	// should no longer reveal a tiny "squiggle" from active-line timing
	// dithering, while vertical stability is preserved.

	reg [9:0] diag_h_ctr;
	reg [8:0] diag_v_ctr;

	// Source-frame event is used ONLY ONCE for initial phase alignment.
	reg diag_frame_s1;
	reg diag_frame_s2;
	reg diag_frame_seen;
	reg diag_frame_locked;

	// Active-low RGBS timing.
	wire diag_hsync = (diag_h_ctr < 10'd58) ? 1'b0 : 1'b1;

	// 240p: 240 active + 4 front + 3 V-sync + 15 back = 262 lines.
	wire diag_vactive = (diag_v_ctr < 9'd240);
	wire diag_vsync   = !((diag_v_ctr >= 9'd244) &&
	                      (diag_v_ctr <  9'd247));
	wire diag_csync   = ~(diag_hsync ^ diag_vsync);

	// Horizontal totals:
	//   visible lines      : 781 clocks (last = 780)
	//   4-line front porch : 786 clocks (last = 785)
	//   sync + back porch  : 787 clocks (last = 786)
	wire [9:0] diag_h_last =
		diag_vactive              ? 10'd780 :
		(diag_v_ctr < 9'd244)     ? 10'd785 :
		                            10'd786;

	always @(posedge video_clk or posedge i_rst) begin
		if (i_rst) begin
			diag_h_ctr        <= 10'd0;
			diag_v_ctr        <= 9'd0;
			diag_frame_s1     <= 1'b0;
			diag_frame_s2     <= 1'b0;
			diag_frame_seen   <= 1'b0;
			diag_frame_locked <= 1'b0;
		end else begin
			diag_frame_s1 <= src_frame_toggle;
			diag_frame_s2 <= diag_frame_s1;

			if (diag_h_ctr == diag_h_last) begin
				diag_h_ctr <= 10'd0;

				// One-time phase alignment to source active-frame start.
				if (!diag_frame_locked &&
				    (diag_frame_s2 != diag_frame_seen)) begin
					diag_frame_seen   <= diag_frame_s2;
					diag_frame_locked <= 1'b1;
					diag_v_ctr        <= 9'd0;
				end else if (diag_v_ctr == 9'd261) begin
					diag_v_ctr <= 9'd0;
				end else begin
					diag_v_ctr <= diag_v_ctr + 9'd1;
				end
			end else begin
				diag_h_ctr <= diag_h_ctr + 10'd1;
			end
		end
	end

	// H positions are identical on all visible lines.
	wire diag_hactive = (diag_h_ctr >= 10'd120) &&
	                    (diag_h_ctr < 10'd760);
	wire diag_blankn  = diag_hactive && diag_vactive;
	wire [9:0] diag_x = diag_h_ctr - 10'd120;

	// =====================================================================
	// OS25 ANALOGIZER DIAG V5 LCD TAP
	//
	// The dedicated OS25 analog framebuffer fetch is bypassed completely.
	//
	// R/G/B + Hblank/Vblank now carry the KNOWN-GOOD Pocket/Dock 480p
	// stream.  Capture every other active LCD line (480 -> 240) at the
	// 24.576 MHz source pixel rate, then replay the completed line through
	// V2's proven 12.288 MHz / 15.75 kHz RGBS raster.
	//
	// i_clk = 49.152 MHz, exactly 2x the LCD pixel rate.  Each source pixel
	// is stable for two i_clk cycles.  The sampler resets its phase at the
	// active-line edge and stores one sample every two i_clk clocks.
	// =====================================================================

	(* ramstyle = "M10K, no_rw_check" *) reg [23:0] live_line0 [0:639];
	(* ramstyle = "M10K, no_rw_check" *) reg [23:0] live_line1 [0:639];

	reg        src_hblank_d;
	reg        src_vblank_d;
	reg        src_frame_toggle;
	reg        src_line_parity;
	reg        src_capture;
	reg        src_sample_phase;
	reg [9:0]  src_wr_x;
	reg        live_wr_bank;
	reg        live_complete_bank;
	reg        live_ready_toggle;

	always @(posedge i_clk or posedge i_rst) begin
		if (i_rst) begin
			src_hblank_d      <= 1'b1;
			src_vblank_d      <= 1'b1;
			src_frame_toggle    <= 1'b0;
			src_line_parity   <= 1'b0;
			src_capture       <= 1'b0;
			src_sample_phase  <= 1'b0;
			src_wr_x          <= 10'd0;
			live_wr_bank      <= 1'b0;
			live_complete_bank<= 1'b0;
			live_ready_toggle <= 1'b0;
		end else begin
			src_hblank_d <= Hblank;
			src_vblank_d <= Vblank;

			// First active source line of a new 480p frame.
			if (src_vblank_d && !Vblank)
				src_frame_toggle <= ~src_frame_toggle;

			// Reset 2:1 vertical decimation at every source-frame blanking.
			if (Vblank) begin
				src_line_parity  <= 1'b0;
				src_capture      <= 1'b0;
				src_sample_phase <= 1'b0;
				src_wr_x         <= 10'd0;
			end else begin
				// Falling Hblank = first active pixel of a source line.
				if (src_hblank_d && !Hblank) begin
					src_capture      <= ~src_line_parity; // lines 0,2,4,...
					src_line_parity  <= ~src_line_parity;
					src_sample_phase <= 1'b0;
					src_wr_x         <= 10'd0;
				end else if (!Hblank && src_capture) begin
					src_sample_phase <= ~src_sample_phase;

					// Sample near the middle of each 24.576-MHz pixel.
					if (!src_sample_phase) begin
						if (!live_wr_bank)
							live_line0[src_wr_x] <= {R,G,B};
						else
							live_line1[src_wr_x] <= {R,G,B};

						if (src_wr_x == 10'd639) begin
							live_complete_bank <= live_wr_bank;
							live_ready_toggle  <= ~live_ready_toggle;
							live_wr_bank       <= ~live_wr_bank;
							src_capture        <= 1'b0;
						end else begin
							src_wr_x <= src_wr_x + 10'd1;
						end
					end
				end
			end
		end
	end

	// Completed-line ownership crosses into the 12.288-MHz output clock.
	// completed_bank is quasi-static before ready_toggle changes.
	reg live_ready_s1, live_ready_s2, live_ready_seen;
	reg live_bank_s1,  live_bank_s2;
	reg live_read_bank;
	reg live_pending_bank;
	reg live_pending_valid;

	reg [9:0]  live_rd_addr;
	reg [23:0] live_q0;
	reg [23:0] live_q1;

	always @(posedge video_clk or posedge i_rst) begin
		if (i_rst) begin
			live_ready_s1   <= 1'b0;
			live_ready_s2   <= 1'b0;
			live_ready_seen <= 1'b0;
			live_bank_s1    <= 1'b0;
			live_bank_s2    <= 1'b0;
			live_read_bank  <= 1'b0;
			live_pending_bank <= 1'b0;
			live_pending_valid<= 1'b0;
			live_rd_addr    <= 10'd0;
			live_q0         <= 24'h0;
			live_q1         <= 24'h0;
		end else begin
			live_ready_s1 <= live_ready_toggle;
			live_ready_s2 <= live_ready_s1;
			live_bank_s1  <= live_complete_bank;
			live_bank_s2  <= live_bank_s1;

			if (live_ready_s2 != live_ready_seen) begin
				live_ready_seen    <= live_ready_s2;
				live_pending_bank  <= live_bank_s2;
				live_pending_valid <= 1'b1;
			end

			// Never splice two captured source rows into one physical CRT line.
			if ((diag_h_ctr == diag_h_last) && live_pending_valid) begin
				live_read_bank     <= live_pending_bank;
				live_pending_valid <= 1'b0;
			end

			if (diag_hactive)
				live_rd_addr <= diag_x;
			else
				live_rd_addr <= 10'd0;

			// Separate read ports let Quartus infer simple dual-clock RAMs.
			live_q0 <= live_line0[live_rd_addr];
			live_q1 <= live_line1[live_rd_addr];
		end
	end

	wire [23:0] live_pixel = live_read_bank ? live_q1 : live_q0;

	// OS25 ANALOGIZER V9 CLEAN
	reg [5:0] diag_r;
	reg [5:0] diag_g;
	reg [5:0] diag_b;

	always @(*) begin
		diag_r = 6'h00;
		diag_g = 6'h00;
		diag_b = 6'h00;

		if (diag_blankn) begin
			diag_r = live_pixel[23:18];
			diag_g = live_pixel[15:10];
			diag_b = live_pixel[7:2];
		end
	end
	// =====================================================================
	// OS25 ANALOGIZER V13 V10 FAST PATH
	//
	// Keep the V10 line-buffer/timing implementation in its original source
	// location and preserve its exact RGBS electrical mapping. Menu control is
	// applied ONLY at the final cartridge-pin selector.
	//
	// This test is intentionally conservative: first prove that restoring the
	// V10 physical/layout structure also restores the sharp, shimmer-free RGBS
	// picture while retaining Enable Off and RGBS/RGsB/SC selection.
	// =====================================================================

	wire v13_is_rgbs = (analog_video_type == 4'h0) || (analog_video_type == 4'h8);
	wire v13_is_rgsb = (analog_video_type == 4'h1) || (analog_video_type == 4'h9);
	wire v13_is_sc   = (analog_video_type == 4'h5) || (analog_video_type == 4'h6) ||
	                   (analog_video_type == 4'h7) || (analog_video_type == 4'hD) ||
	                   (analog_video_type == 4'hE) || (analog_video_type == 4'hF);

	reg [5:0] v13_r;
	reg [5:0] v13_g;
	reg [5:0] v13_b;
	reg       v13_hs;
	reg       v13_vs;
	reg       v13_blankn;

	always @(*) begin
		// Default to the normal Analogizer mux. This preserves the other
		// choices for experimentation, but RGBS below does not pass through it.
		v13_r      = Rout;
		v13_g      = Gout;
		v13_b      = Bout;
		v13_hs     = HsyncOut;
		v13_vs     = VsyncOut;
		v13_blankn = BLANKnOut;

		if (v13_is_rgbs) begin
			// Bit-for-bit V10 direct RGBS path.
			v13_r      = diag_r;
			v13_g      = diag_g;
			v13_b      = diag_b;
			v13_hs     = diag_csync;
			v13_vs     = 1'b1;
			v13_blankn = diag_blankn;
		end else if (v13_is_rgsb) begin
			// Same proven V10 pixels/timing; only SOG sync routing differs.
			v13_r      = diag_r;
			v13_g      = diag_g;
			v13_b      = diag_b;
			v13_hs     = 1'b1;
			v13_vs     = diag_csync;
			v13_blankn = diag_blankn;
		end else if (v13_is_sc) begin
			// Normal 480p/31-kHz path.
			v13_r      = R_Sd;
			v13_g      = G_Sd;
			v13_b      = B_Sd;
			v13_hs     = Hsync_Sd;
			v13_vs     = Vsync_Sd;
			v13_blankn = BLANKn_SD;
		end
	end

	// Enable Off now gates only the physical pins; it does not disturb the
	// V10 line-buffer machinery or its phase while the menu is open.
	wire v13_video_drive = i_ena && !i_rst;

	assign cart_tran_bank3 =
		v13_video_drive ? {v13_r, v13_hs, v13_vs} : 8'hZZ;
	assign cart_tran_bank3_dir = v13_video_drive;

	assign cart_tran_bank2 =
		v13_video_drive ? {v13_b[0], v13_blankn, v13_g} : 8'hZZ;
	assign cart_tran_bank2_dir = v13_video_drive;

	wire v13_bank1_drive = (i_ena || snac_enable) && !i_rst;
	assign cart_tran_bank1 =
		v13_bank1_drive ?
			{snac_enable ? CART_BK1_OUT_P76 : 2'b00,
			 i_ena ? {video_clk, v13_b[5:1]} : 6'b0}
			: 8'hZZ;
	assign cart_tran_bank1_dir = v13_bank1_drive;

endmodule