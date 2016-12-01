
`timescale 1ns / 1ps
`define DLY #1


//***********************************Entity Declaration************************
(* CORE_GENERATION_INFO = "serdes_coe,gtwizard_v2_7,{protocol_file=Start_from_scratch}" *)
module serdes_coe_exdes #
(
    parameter EXAMPLE_CONFIG_INDEPENDENT_LANES     =   0,//configuration for frame gen and check
    parameter STABLE_CLOCK_PERIOD                  =   10, // Period of the stable clock driving this init module, unit is [ns] 
    parameter EXAMPLE_LANE_WITH_START_CHAR         =   0,         // specifies lane with unique start frame char
    parameter EXAMPLE_WORDS_IN_BRAM                =   512,       // specifies amount of data in BRAM
    parameter EXAMPLE_SIM_GTRESET_SPEEDUP          =   "TRUE",    // simulation setting for GT SecureIP model
    parameter EXAMPLE_USE_CHIPSCOPE                =   0,         // Set to 1 to use Chipscope to drive resets
    parameter EXAMPLE_SIMULATION                   =   0          // Set to 1 for Simulation

)
(
    Q0_CLK0_GTREFCLK_PAD_N_IN,
    Q0_CLK0_GTREFCLK_PAD_P_IN,
    DRP_CLK_IN,
    I_sys_rst_n,
    RXN_IN,
    RXP_IN,
    TXN_OUT,
    TXP_OUT,
    gt0_txcharisk_i,
    gt1_txcharisk_i,
    gt2_txcharisk_i,
    gt3_txcharisk_i,
    gt0_rxcharisk_i,
    gt1_rxcharisk_i,
    gt2_rxcharisk_i,
    gt3_rxcharisk_i,
    gt0_txdata_i,
    gt1_txdata_i,
    gt2_txdata_i,
    gt3_txdata_i,
    gt0_rxdata_i,
    gt1_rxdata_i,
    gt2_rxdata_i,
    gt3_rxdata_i,
    gt0_txusrclk_i,
    gt1_txusrclk_i,
    gt2_txusrclk_i,
    gt3_txusrclk_i,
    gt0_rxusrclk_i,
    gt1_rxusrclk_i,
    gt2_rxusrclk_i,
    gt3_rxusrclk_i
);

    input   Q0_CLK0_GTREFCLK_PAD_N_IN;
    input   Q0_CLK0_GTREFCLK_PAD_P_IN;
    input   DRP_CLK_IN;
    input   I_sys_rst_n;
    input   [3:0]   RXN_IN;
    input   [3:0]   RXP_IN;
    output  [3:0]   TXN_OUT;
    output  [3:0]   TXP_OUT;
    input   [1:0]   gt0_txcharisk_i;
    input   [1:0]   gt1_txcharisk_i;
    input   [1:0]   gt2_txcharisk_i;
    input   [1:0]   gt3_txcharisk_i;
    output  [1:0]   gt0_rxcharisk_i;
    output  [1:0]   gt1_rxcharisk_i;
    output  [1:0]   gt2_rxcharisk_i;
    output  [1:0]   gt3_rxcharisk_i;
    input   [15:0]  gt0_txdata_i;
    input   [15:0]  gt1_txdata_i;
    input   [15:0]  gt2_txdata_i;
    input   [15:0]  gt3_txdata_i;
    output  [15:0]  gt0_rxdata_i;
    output  [15:0]  gt1_rxdata_i;
    output  [15:0]  gt2_rxdata_i;
    output  [15:0]  gt3_rxdata_i;
    output  gt0_txusrclk_i;
    output  gt1_txusrclk_i;
    output  gt2_txusrclk_i;
    output  gt3_txusrclk_i;
    output  gt0_rxusrclk_i;
    output  gt1_rxusrclk_i;
    output  gt2_rxusrclk_i;
    output  gt3_rxusrclk_i;
//************************** Register Declarations ****************************

    wire            gt0_txfsmresetdone_i;
    wire            gt0_rxfsmresetdone_i;
    reg             gt0_txfsmresetdone_r;
    reg             gt0_txfsmresetdone_r2;
    reg             gt0_rxresetdone_r;
    reg             gt0_rxresetdone_r2;
    reg             gt0_rxresetdone_r3;

    wire            gt1_txfsmresetdone_i;
    wire            gt1_rxfsmresetdone_i;
    reg             gt1_txfsmresetdone_r;
    reg             gt1_txfsmresetdone_r2;
    reg             gt1_rxresetdone_r;
    reg             gt1_rxresetdone_r2;
    reg             gt1_rxresetdone_r3;

    wire            gt2_txfsmresetdone_i;
    wire            gt2_rxfsmresetdone_i;
    reg             gt2_txfsmresetdone_r;
    reg             gt2_txfsmresetdone_r2;
    reg             gt2_rxresetdone_r;
    reg             gt2_rxresetdone_r2;
    reg             gt2_rxresetdone_r3;

    wire            gt3_txfsmresetdone_i;
    wire            gt3_rxfsmresetdone_i;
    reg             gt3_txfsmresetdone_r;
    reg             gt3_txfsmresetdone_r2;
    reg             gt3_rxresetdone_r;
    reg             gt3_rxresetdone_r2;
    reg             gt3_rxresetdone_r3;

    reg [5:0] reset_counter = 0;
    reg     [3:0]   reset_pulse;

//**************************** Wire Declarations ******************************//
    //------------------------ GT Wrapper Wires ------------------------------
    //________________________________________________________________________
    //________________________________________________________________________
    //GT0   (X1Y0)
    //------------------------------- CPLL Ports -------------------------------
    wire            gt0_cpllfbclklost_i;
    wire            gt0_cplllock_i;
    wire            gt0_cpllrefclklost_i;
    wire            gt0_cpllreset_i;
    //-------------------------- Channel - DRP Ports  --------------------------
    wire    [8:0]   gt0_drpaddr_i;
    wire    [15:0]  gt0_drpdi_i;
    wire    [15:0]  gt0_drpdo_i;
    wire            gt0_drpen_i;
    wire            gt0_drprdy_i;
    wire            gt0_drpwe_i;
    //----------------------------- Loopback Ports -----------------------------
    wire    [2:0]   gt0_loopback_i;
    //------------------- RX Initialization and Reset Ports --------------------
    wire            gt0_rxuserrdy_i;
    //------------------------ RX Margin Analysis Ports ------------------------
    wire            gt0_eyescandataerror_i;
    //----------------------- Receive Ports - CDR Ports ------------------------
    wire            gt0_rxcdrlock_i;
    //---------------- Receive Ports - FPGA RX interface Ports -----------------
    wire    [15:0]  gt0_rxdata_i;
    //---------------- Receive Ports - RX 8B/10B Decoder Ports -----------------
    wire    [1:0]   gt0_rxdisperr_i;
    wire    [1:0]   gt0_rxnotintable_i;
    //------------------------- Receive Ports - RX AFE -------------------------
    wire            gt0_gtxrxp_i;
    //---------------------- Receive Ports - RX AFE Ports ----------------------
    wire            gt0_gtxrxn_i;
    //---------------- Receive Ports - RX Channel Bonding Ports ----------------
    wire            gt0_rxchanbondseq_i;
    wire            gt0_rxchbonden_i;
    //--------------- Receive Ports - RX Channel Bonding Ports  ----------------
    wire            gt0_rxchanisaligned_i;
    wire            gt0_rxchanrealign_i;
    //------------- Receive Ports - RX Fabric Output Control Ports -------------
    wire            gt0_rxoutclk_i;
    //----------- Receive Ports - RX Initialization and Reset Ports ------------
    wire            gt0_gtrxreset_i;
    wire            gt0_rxpmareset_i;
    //----------------- Receive Ports - RX8B/10B Decoder Ports -----------------
    wire    [1:0]   gt0_rxcharisk_i;
    //------------ Receive Ports -RX Initialization and Reset Ports ------------
    wire            gt0_rxresetdone_i;
    //------------------- TX Initialization and Reset Ports --------------------
    wire            gt0_gttxreset_i;
    wire            gt0_txuserrdy_i;
    //---------------- Transmit Ports - TX Data Path interface -----------------
    wire    [15:0]  gt0_txdata_i;
    //-------------- Transmit Ports - TX Driver and OOB signaling --------------
    wire            gt0_gtxtxn_i;
    wire            gt0_gtxtxp_i;
    //--------- Transmit Ports - TX Fabric Clock Output Control Ports ----------
    wire            gt0_txoutclk_i;
    wire            gt0_txoutclkfabric_i;
    wire            gt0_txoutclkpcs_i;
    //------------------- Transmit Ports - TX Gearbox Ports --------------------
    wire    [1:0]   gt0_txcharisk_i;
    //----------- Transmit Ports - TX Initialization and Reset Ports -----------
    wire            gt0_txresetdone_i;

    //________________________________________________________________________
    //________________________________________________________________________
    //GT1   (X1Y1)
    //------------------------------- CPLL Ports -------------------------------
    wire            gt1_cpllfbclklost_i;
    wire            gt1_cplllock_i;
    wire            gt1_cpllrefclklost_i;
    wire            gt1_cpllreset_i;
    //-------------------------- Channel - DRP Ports  --------------------------
    wire    [8:0]   gt1_drpaddr_i;
    wire    [15:0]  gt1_drpdi_i;
    wire    [15:0]  gt1_drpdo_i;
    wire            gt1_drpen_i;
    wire            gt1_drprdy_i;
    wire            gt1_drpwe_i;
    //----------------------------- Loopback Ports -----------------------------
    wire    [2:0]   gt1_loopback_i;
    //------------------- RX Initialization and Reset Ports --------------------
    wire            gt1_rxuserrdy_i;
    //------------------------ RX Margin Analysis Ports ------------------------
    wire            gt1_eyescandataerror_i;
    //----------------------- Receive Ports - CDR Ports ------------------------
    wire            gt1_rxcdrlock_i;
    //---------------- Receive Ports - FPGA RX interface Ports -----------------
    wire    [15:0]  gt1_rxdata_i;
    //---------------- Receive Ports - RX 8B/10B Decoder Ports -----------------
    wire    [1:0]   gt1_rxdisperr_i;
    wire    [1:0]   gt1_rxnotintable_i;
    //------------------------- Receive Ports - RX AFE -------------------------
    wire            gt1_gtxrxp_i;
    //---------------------- Receive Ports - RX AFE Ports ----------------------
    wire            gt1_gtxrxn_i;
    //---------------- Receive Ports - RX Channel Bonding Ports ----------------
    wire            gt1_rxchanbondseq_i;
    wire            gt1_rxchbonden_i;
    //--------------- Receive Ports - RX Channel Bonding Ports  ----------------
    wire            gt1_rxchanisaligned_i;
    wire            gt1_rxchanrealign_i;
    //------------- Receive Ports - RX Fabric Output Control Ports -------------
    wire            gt1_rxoutclk_i;
    //----------- Receive Ports - RX Initialization and Reset Ports ------------
    wire            gt1_gtrxreset_i;
    wire            gt1_rxpmareset_i;
    //----------------- Receive Ports - RX8B/10B Decoder Ports -----------------
    wire    [1:0]   gt1_rxcharisk_i;
    //------------ Receive Ports -RX Initialization and Reset Ports ------------
    wire            gt1_rxresetdone_i;
    //------------------- TX Initialization and Reset Ports --------------------
    wire            gt1_gttxreset_i;
    wire            gt1_txuserrdy_i;
    //---------------- Transmit Ports - TX Data Path interface -----------------
    wire    [15:0]  gt1_txdata_i;
    //-------------- Transmit Ports - TX Driver and OOB signaling --------------
    wire            gt1_gtxtxn_i;
    wire            gt1_gtxtxp_i;
    //--------- Transmit Ports - TX Fabric Clock Output Control Ports ----------
    wire            gt1_txoutclk_i;
    wire            gt1_txoutclkfabric_i;
    wire            gt1_txoutclkpcs_i;
    //------------------- Transmit Ports - TX Gearbox Ports --------------------
    wire    [1:0]   gt1_txcharisk_i;
    //----------- Transmit Ports - TX Initialization and Reset Ports -----------
    wire            gt1_txresetdone_i;

    //________________________________________________________________________
    //________________________________________________________________________
    //GT2   (X1Y2)
    //------------------------------- CPLL Ports -------------------------------
    wire            gt2_cpllfbclklost_i;
    wire            gt2_cplllock_i;
    wire            gt2_cpllrefclklost_i;
    wire            gt2_cpllreset_i;
    //-------------------------- Channel - DRP Ports  --------------------------
    wire    [8:0]   gt2_drpaddr_i;
    wire    [15:0]  gt2_drpdi_i;
    wire    [15:0]  gt2_drpdo_i;
    wire            gt2_drpen_i;
    wire            gt2_drprdy_i;
    wire            gt2_drpwe_i;
    //----------------------------- Loopback Ports -----------------------------
    wire    [2:0]   gt2_loopback_i;
    //------------------- RX Initialization and Reset Ports --------------------
    wire            gt2_rxuserrdy_i;
    //------------------------ RX Margin Analysis Ports ------------------------
    wire            gt2_eyescandataerror_i;
    //----------------------- Receive Ports - CDR Ports ------------------------
    wire            gt2_rxcdrlock_i;
    //---------------- Receive Ports - FPGA RX interface Ports -----------------
    wire    [15:0]  gt2_rxdata_i;
    //---------------- Receive Ports - RX 8B/10B Decoder Ports -----------------
    wire    [1:0]   gt2_rxdisperr_i;
    wire    [1:0]   gt2_rxnotintable_i;
    //------------------------- Receive Ports - RX AFE -------------------------
    wire            gt2_gtxrxp_i;
    //---------------------- Receive Ports - RX AFE Ports ----------------------
    wire            gt2_gtxrxn_i;
    //---------------- Receive Ports - RX Channel Bonding Ports ----------------
    wire            gt2_rxchanbondseq_i;
    wire            gt2_rxchbonden_i;
    //--------------- Receive Ports - RX Channel Bonding Ports  ----------------
    wire            gt2_rxchanisaligned_i;
    wire            gt2_rxchanrealign_i;
    //------------- Receive Ports - RX Fabric Output Control Ports -------------
    wire            gt2_rxoutclk_i;
    //----------- Receive Ports - RX Initialization and Reset Ports ------------
    wire            gt2_gtrxreset_i;
    wire            gt2_rxpmareset_i;
    //----------------- Receive Ports - RX8B/10B Decoder Ports -----------------
    wire    [1:0]   gt2_rxcharisk_i;
    //------------ Receive Ports -RX Initialization and Reset Ports ------------
    wire            gt2_rxresetdone_i;
    //------------------- TX Initialization and Reset Ports --------------------
    wire            gt2_gttxreset_i;
    wire            gt2_txuserrdy_i;
    //---------------- Transmit Ports - TX Data Path interface -----------------
    wire    [15:0]  gt2_txdata_i;
    //-------------- Transmit Ports - TX Driver and OOB signaling --------------
    wire            gt2_gtxtxn_i;
    wire            gt2_gtxtxp_i;
    //--------- Transmit Ports - TX Fabric Clock Output Control Ports ----------
    wire            gt2_txoutclk_i;
    wire            gt2_txoutclkfabric_i;
    wire            gt2_txoutclkpcs_i;
    //------------------- Transmit Ports - TX Gearbox Ports --------------------
    wire    [1:0]   gt2_txcharisk_i;
    //----------- Transmit Ports - TX Initialization and Reset Ports -----------
    wire            gt2_txresetdone_i;

    //________________________________________________________________________
    //________________________________________________________________________
    //GT3   (X1Y3)
    //------------------------------- CPLL Ports -------------------------------
    wire            gt3_cpllfbclklost_i;
    wire            gt3_cplllock_i;
    wire            gt3_cpllrefclklost_i;
    wire            gt3_cpllreset_i;
    //-------------------------- Channel - DRP Ports  --------------------------
    wire    [8:0]   gt3_drpaddr_i;
    wire    [15:0]  gt3_drpdi_i;
    wire    [15:0]  gt3_drpdo_i;
    wire            gt3_drpen_i;
    wire            gt3_drprdy_i;
    wire            gt3_drpwe_i;
    //----------------------------- Loopback Ports -----------------------------
    wire    [2:0]   gt3_loopback_i;
    //------------------- RX Initialization and Reset Ports --------------------
    wire            gt3_rxuserrdy_i;
    //------------------------ RX Margin Analysis Ports ------------------------
    wire            gt3_eyescandataerror_i;
    //----------------------- Receive Ports - CDR Ports ------------------------
    wire            gt3_rxcdrlock_i;
    //---------------- Receive Ports - FPGA RX interface Ports -----------------
    wire    [15:0]  gt3_rxdata_i;
    //---------------- Receive Ports - RX 8B/10B Decoder Ports -----------------
    wire    [1:0]   gt3_rxdisperr_i;
    wire    [1:0]   gt3_rxnotintable_i;
    //------------------------- Receive Ports - RX AFE -------------------------
    wire            gt3_gtxrxp_i;
    //---------------------- Receive Ports - RX AFE Ports ----------------------
    wire            gt3_gtxrxn_i;
    //---------------- Receive Ports - RX Channel Bonding Ports ----------------
    wire            gt3_rxchanbondseq_i;
    wire            gt3_rxchbonden_i;
    //--------------- Receive Ports - RX Channel Bonding Ports  ----------------
    wire            gt3_rxchanisaligned_i;
    wire            gt3_rxchanrealign_i;
    //------------- Receive Ports - RX Fabric Output Control Ports -------------
    wire            gt3_rxoutclk_i;
    //----------- Receive Ports - RX Initialization and Reset Ports ------------
    wire            gt3_gtrxreset_i;
    wire            gt3_rxpmareset_i;
    //----------------- Receive Ports - RX8B/10B Decoder Ports -----------------
    wire    [1:0]   gt3_rxcharisk_i;
    //------------ Receive Ports -RX Initialization and Reset Ports ------------
    wire            gt3_rxresetdone_i;
    //------------------- TX Initialization and Reset Ports --------------------
    wire            gt3_gttxreset_i;
    wire            gt3_txuserrdy_i;
    //---------------- Transmit Ports - TX Data Path interface -----------------
    wire    [15:0]  gt3_txdata_i;
    //-------------- Transmit Ports - TX Driver and OOB signaling --------------
    wire            gt3_gtxtxn_i;
    wire            gt3_gtxtxp_i;
    //--------- Transmit Ports - TX Fabric Clock Output Control Ports ----------
    wire            gt3_txoutclk_i;
    wire            gt3_txoutclkfabric_i;
    wire            gt3_txoutclkpcs_i;
    //------------------- Transmit Ports - TX Gearbox Ports --------------------
    wire    [1:0]   gt3_txcharisk_i;
    //----------- Transmit Ports - TX Initialization and Reset Ports -----------
    wire            gt3_txresetdone_i;

    //____________________________COMMON PORTS________________________________
    //----------------------- Common Block - QPLL Ports ------------------------
    wire            gt0_qplllock_i;
    wire            gt0_qpllrefclklost_i;
    wire            gt0_qpllreset_i;

    //------------------------ Channel Bonding Wires ---------------------------
    wire    [4:0]   gt0_rxchbondo_i;
    wire    [4:0]   gt1_rxchbondo_i;
    wire    [4:0]   gt2_rxchbondo_i;
    wire    [4:0]   gt3_rxchbondo_i;

    //----------------------------- Global Signals -----------------------------

    wire            drpclk_in_i;
    wire            tied_to_ground_i;
    wire    [63:0]  tied_to_ground_vec_i;
    wire            tied_to_vcc_i;
    wire    [7:0]   tied_to_vcc_vec_i;
    wire            GTTXRESET_IN;
    wire            GTRXRESET_IN;
    wire            CPLLRESET_IN;
    wire            QPLLRESET_IN;

     //--------------------------- User Clocks ---------------------------------
    (* keep = "TRUE" *) wire            gt0_txusrclk_i; 
    (* keep = "TRUE" *) wire            gt0_txusrclk2_i; 
    (* keep = "TRUE" *) wire            gt0_rxusrclk_i; 
    (* keep = "TRUE" *) wire            gt0_rxusrclk2_i; 
    (* keep = "TRUE" *) wire            gt1_txusrclk_i; 
    (* keep = "TRUE" *) wire            gt1_txusrclk2_i; 
    (* keep = "TRUE" *) wire            gt1_rxusrclk_i; 
    (* keep = "TRUE" *) wire            gt1_rxusrclk2_i; 
    (* keep = "TRUE" *) wire            gt2_txusrclk_i; 
    (* keep = "TRUE" *) wire            gt2_txusrclk2_i; 
    (* keep = "TRUE" *) wire            gt2_rxusrclk_i; 
    (* keep = "TRUE" *) wire            gt2_rxusrclk2_i; 
    (* keep = "TRUE" *) wire            gt3_txusrclk_i; 
    (* keep = "TRUE" *) wire            gt3_txusrclk2_i; 
    (* keep = "TRUE" *) wire            gt3_rxusrclk_i; 
    (* keep = "TRUE" *) wire            gt3_rxusrclk2_i; 
 
    //--------------------------- Reference Clocks ----------------------------
    
    wire            q0_clk0_refclk_i;


    //--------------------- Frame check/gen Module Signals --------------------
    wire            gt0_matchn_i;
    
    wire    [5:0]   gt0_txcharisk_float_i;
   
    wire    [15:0]  gt0_txdata_float16_i;
    wire    [47:0]  gt0_txdata_float_i;
    
    
    wire            gt0_block_sync_i;
    wire            gt0_track_data_i;
    wire    [7:0]   gt0_error_count_i;
    wire            gt0_frame_check_reset_i;
    wire            gt0_inc_in_i;
    wire            gt0_inc_out_i;
    wire    [15:0]  gt0_unscrambled_data_i;

    wire            gt1_matchn_i;
    
    wire    [5:0]   gt1_txcharisk_float_i;
   
    wire    [15:0]  gt1_txdata_float16_i;
    wire    [47:0]  gt1_txdata_float_i;
    
    
    wire            gt1_block_sync_i;
    wire            gt1_track_data_i;
    wire    [7:0]   gt1_error_count_i;
    wire            gt1_frame_check_reset_i;
    wire            gt1_inc_in_i;
    wire            gt1_inc_out_i;
    wire    [15:0]  gt1_unscrambled_data_i;

    wire            gt2_matchn_i;
    
    wire    [5:0]   gt2_txcharisk_float_i;
   
    wire    [15:0]  gt2_txdata_float16_i;
    wire    [47:0]  gt2_txdata_float_i;
    
    
    wire            gt2_block_sync_i;
    wire            gt2_track_data_i;
    wire    [7:0]   gt2_error_count_i;
    wire            gt2_frame_check_reset_i;
    wire            gt2_inc_in_i;
    wire            gt2_inc_out_i;
    wire    [15:0]  gt2_unscrambled_data_i;

    wire            gt3_matchn_i;
    
    wire    [5:0]   gt3_txcharisk_float_i;
   
    wire    [15:0]  gt3_txdata_float16_i;
    wire    [47:0]  gt3_txdata_float_i;
    
    
    wire            gt3_block_sync_i;
    wire            gt3_track_data_i;
    wire    [7:0]   gt3_error_count_i;
    wire            gt3_frame_check_reset_i;
    wire            gt3_inc_in_i;
    wire            gt3_inc_out_i;
    wire    [15:0]  gt3_unscrambled_data_i;

    wire            reset_on_data_error_i;
    wire            track_data_out_i;
  



    


//**************************** Main Body of Code *******************************

    //  Static signal Assigments    
    assign tied_to_ground_i             = 1'b0;
    assign tied_to_ground_vec_i         = 64'h0000000000000000;
    assign tied_to_vcc_i                = 1'b1;
    assign tied_to_vcc_vec_i            = 8'hff;


    serdes_coe_GT_USRCLK_SOURCE gt_usrclk_source
   (
    .Q0_CLK0_GTREFCLK_PAD_N_IN  (Q0_CLK0_GTREFCLK_PAD_N_IN),
    .Q0_CLK0_GTREFCLK_PAD_P_IN  (Q0_CLK0_GTREFCLK_PAD_P_IN),
    .Q0_CLK0_GTREFCLK_OUT       (q0_clk0_refclk_i),
 
    .GT0_TXUSRCLK_OUT    (gt0_txusrclk_i),
    .GT0_TXUSRCLK2_OUT   (gt0_txusrclk2_i),
    .GT0_TXOUTCLK_IN     (gt0_txoutclk_i),
    .GT0_RXUSRCLK_OUT    (gt0_rxusrclk_i),
    .GT0_RXUSRCLK2_OUT   (gt0_rxusrclk2_i),
 
 
    .GT1_TXUSRCLK_OUT    (gt1_txusrclk_i),
    .GT1_TXUSRCLK2_OUT   (gt1_txusrclk2_i),
    .GT1_TXOUTCLK_IN     (gt1_txoutclk_i),
    .GT1_RXUSRCLK_OUT    (gt1_rxusrclk_i),
    .GT1_RXUSRCLK2_OUT   (gt1_rxusrclk2_i),
 
 
    .GT2_TXUSRCLK_OUT    (gt2_txusrclk_i),
    .GT2_TXUSRCLK2_OUT   (gt2_txusrclk2_i),
    .GT2_TXOUTCLK_IN     (gt2_txoutclk_i),
    .GT2_RXUSRCLK_OUT    (gt2_rxusrclk_i),
    .GT2_RXUSRCLK2_OUT   (gt2_rxusrclk2_i),
 
 
    .GT3_TXUSRCLK_OUT    (gt3_txusrclk_i),
    .GT3_TXUSRCLK2_OUT   (gt3_txusrclk2_i),
    .GT3_TXOUTCLK_IN     (gt3_txoutclk_i),
    .GT3_RXUSRCLK_OUT    (gt3_rxusrclk_i),
    .GT3_RXUSRCLK2_OUT   (gt3_rxusrclk2_i),
 
    .DRPCLK_IN (DRP_CLK_IN),
    .DRPCLK_OUT(drpclk_in_i)
);

    //***********************************************************************//
    //                                                                       //
    //--------------------------- The GT Wrapper ----------------------------//
    //                                                                       //
    //***********************************************************************//
    
    // Use the instantiation template in the example directory to add the GT wrapper to your design.
    // In this example, the wrapper is wired up for basic operation with a frame generator and frame 
    // checker. The GTs will reset, then attempt to align and transmit data. If channel bonding is 
    // enabled, bonding should occur after alignment.
    
    serdes_coe_init #
    (
        .EXAMPLE_SIM_GTRESET_SPEEDUP    (EXAMPLE_SIM_GTRESET_SPEEDUP),
        .EXAMPLE_SIMULATION             (EXAMPLE_SIMULATION),
        .STABLE_CLOCK_PERIOD            (STABLE_CLOCK_PERIOD),
        .EXAMPLE_USE_CHIPSCOPE          (EXAMPLE_USE_CHIPSCOPE)
    )
    serdes_coe_init_i
    (
        .SYSCLK_IN                      (drpclk_in_i),
        .SOFT_RESET_IN                  (~I_sys_rst_n),
        .DONT_RESET_ON_DATA_ERROR_IN    (tied_to_ground_i),
        .GT0_TX_FSM_RESET_DONE_OUT      (gt0_txfsmresetdone_i),
        .GT0_RX_FSM_RESET_DONE_OUT      (gt0_rxfsmresetdone_i),
        .GT0_DATA_VALID_IN              (gt0_track_data_i),
        .GT1_TX_FSM_RESET_DONE_OUT      (gt1_txfsmresetdone_i),
        .GT1_RX_FSM_RESET_DONE_OUT      (gt1_rxfsmresetdone_i),
        .GT1_DATA_VALID_IN              (gt1_track_data_i),
        .GT2_TX_FSM_RESET_DONE_OUT      (gt2_txfsmresetdone_i),
        .GT2_RX_FSM_RESET_DONE_OUT      (gt2_rxfsmresetdone_i),
        .GT2_DATA_VALID_IN              (gt2_track_data_i),
        .GT3_TX_FSM_RESET_DONE_OUT      (gt3_txfsmresetdone_i),
        .GT3_RX_FSM_RESET_DONE_OUT      (gt3_rxfsmresetdone_i),
        .GT3_DATA_VALID_IN              (gt3_track_data_i),
 
 

        //_____________________________________________________________________
        //_____________________________________________________________________
        //GT0  (X1Y0)

        //------------------------------- CPLL Ports -------------------------------
        .GT0_CPLLFBCLKLOST_OUT          (gt0_cpllfbclklost_i),
        .GT0_CPLLLOCK_OUT               (gt0_cplllock_i),
        .GT0_CPLLLOCKDETCLK_IN          (drpclk_in_i),
        .GT0_CPLLRESET_IN               (gt0_cpllreset_i),
        //------------------------ Channel - Clocking Ports ------------------------
        .GT0_GTREFCLK0_IN               (q0_clk0_refclk_i),
        //-------------------------- Channel - DRP Ports  --------------------------
        .GT0_DRPADDR_IN                 (gt0_drpaddr_i),
        .GT0_DRPCLK_IN                  (drpclk_in_i),
        .GT0_DRPDI_IN                   (gt0_drpdi_i),
        .GT0_DRPDO_OUT                  (gt0_drpdo_i),
        .GT0_DRPEN_IN                   (gt0_drpen_i),
        .GT0_DRPRDY_OUT                 (gt0_drprdy_i),
        .GT0_DRPWE_IN                   (gt0_drpwe_i),
        //----------------------------- Loopback Ports -----------------------------
        .GT0_LOOPBACK_IN                (gt0_loopback_i),
        //------------------- RX Initialization and Reset Ports --------------------
        .GT0_RXUSERRDY_IN               (gt0_rxuserrdy_i),
        //------------------------ RX Margin Analysis Ports ------------------------
        .GT0_EYESCANDATAERROR_OUT       (gt0_eyescandataerror_i),
        //----------------------- Receive Ports - CDR Ports ------------------------
        .GT0_RXCDRLOCK_OUT              (gt0_rxcdrlock_i),
        //---------------- Receive Ports - FPGA RX Interface Ports -----------------
        .GT0_RXUSRCLK_IN                (gt0_txusrclk_i),
        .GT0_RXUSRCLK2_IN               (gt0_txusrclk_i),
        //---------------- Receive Ports - FPGA RX interface Ports -----------------
        .GT0_RXDATA_OUT                 (gt0_rxdata_i),
        //---------------- Receive Ports - RX 8B/10B Decoder Ports -----------------
        .GT0_RXDISPERR_OUT              (gt0_rxdisperr_i),
        .GT0_RXNOTINTABLE_OUT           (gt0_rxnotintable_i),
        //------------------------- Receive Ports - RX AFE -------------------------
        .GT0_GTXRXP_IN                  (RXP_IN[0]),
        //---------------------- Receive Ports - RX AFE Ports ----------------------
        .GT0_GTXRXN_IN                  (RXN_IN[0]),
        //---------------- Receive Ports - RX Channel Bonding Ports ----------------
        .GT0_RXCHANBONDSEQ_OUT          (gt0_rxchanbondseq_i),
        .GT0_RXCHBONDEN_IN              (gt0_rxchbonden_i),
        .GT0_RXCHBONDLEVEL_IN           (3'b000),
        .GT0_RXCHBONDMASTER_IN          (tied_to_ground_i),
        .GT0_RXCHBONDO_OUT              (gt0_rxchbondo_i),
        .GT0_RXCHBONDSLAVE_IN           (tied_to_vcc_i),
        //--------------- Receive Ports - RX Channel Bonding Ports  ----------------
        .GT0_RXCHANISALIGNED_OUT        (gt0_rxchanisaligned_i),
        .GT0_RXCHANREALIGN_OUT          (gt0_rxchanrealign_i),
        //----------- Receive Ports - RX Initialization and Reset Ports ------------
        .GT0_GTRXRESET_IN               (gt0_gtrxreset_i),
        .GT0_RXPMARESET_IN              (gt0_rxpmareset_i),
        //----------------- Receive Ports - RX8B/10B Decoder Ports -----------------
        .GT0_RXCHARISK_OUT              (gt0_rxcharisk_i),
        //---------------- Receive Ports - Rx Channel Bonding Ports ----------------
        .GT0_RXCHBONDI_IN               (gt1_rxchbondo_i),
        //------------ Receive Ports -RX Initialization and Reset Ports ------------
        .GT0_RXRESETDONE_OUT            (gt0_rxresetdone_i),
        //------------------- TX Initialization and Reset Ports --------------------
        .GT0_GTTXRESET_IN               (gt0_gttxreset_i),
        .GT0_TXUSERRDY_IN               (gt0_txuserrdy_i),
        //---------------- Transmit Ports - FPGA TX Interface Ports ----------------
        .GT0_TXUSRCLK_IN                (gt0_txusrclk_i),
        .GT0_TXUSRCLK2_IN               (gt0_txusrclk_i),
        //---------------- Transmit Ports - TX Data Path interface -----------------
        .GT0_TXDATA_IN                  (gt0_txdata_i),
        //-------------- Transmit Ports - TX Driver and OOB signaling --------------
        .GT0_GTXTXN_OUT                 (TXN_OUT[0]),
        .GT0_GTXTXP_OUT                 (TXP_OUT[0]),
        //--------- Transmit Ports - TX Fabric Clock Output Control Ports ----------
        .GT0_TXOUTCLK_OUT               (gt0_txoutclk_i),
        .GT0_TXOUTCLKFABRIC_OUT         (gt0_txoutclkfabric_i),
        .GT0_TXOUTCLKPCS_OUT            (gt0_txoutclkpcs_i),
        //------------------- Transmit Ports - TX Gearbox Ports --------------------
        .GT0_TXCHARISK_IN               (gt0_txcharisk_i),
        //----------- Transmit Ports - TX Initialization and Reset Ports -----------
        .GT0_TXRESETDONE_OUT            (gt0_txresetdone_i),


 
 

        //_____________________________________________________________________
        //_____________________________________________________________________
        //GT1  (X1Y1)

        //------------------------------- CPLL Ports -------------------------------
        .GT1_CPLLFBCLKLOST_OUT          (gt1_cpllfbclklost_i),
        .GT1_CPLLLOCK_OUT               (gt1_cplllock_i),
        .GT1_CPLLLOCKDETCLK_IN          (drpclk_in_i),
        .GT1_CPLLRESET_IN               (gt1_cpllreset_i),
        //------------------------ Channel - Clocking Ports ------------------------
        .GT1_GTREFCLK0_IN               (q0_clk0_refclk_i),
        //-------------------------- Channel - DRP Ports  --------------------------
        .GT1_DRPADDR_IN                 (gt1_drpaddr_i),
        .GT1_DRPCLK_IN                  (drpclk_in_i),
        .GT1_DRPDI_IN                   (gt1_drpdi_i),
        .GT1_DRPDO_OUT                  (gt1_drpdo_i),
        .GT1_DRPEN_IN                   (gt1_drpen_i),
        .GT1_DRPRDY_OUT                 (gt1_drprdy_i),
        .GT1_DRPWE_IN                   (gt1_drpwe_i),
        //----------------------------- Loopback Ports -----------------------------
        .GT1_LOOPBACK_IN                (gt1_loopback_i),
        //------------------- RX Initialization and Reset Ports --------------------
        .GT1_RXUSERRDY_IN               (gt1_rxuserrdy_i),
        //------------------------ RX Margin Analysis Ports ------------------------
        .GT1_EYESCANDATAERROR_OUT       (gt1_eyescandataerror_i),
        //----------------------- Receive Ports - CDR Ports ------------------------
        .GT1_RXCDRLOCK_OUT              (gt1_rxcdrlock_i),
        //---------------- Receive Ports - FPGA RX Interface Ports -----------------
        .GT1_RXUSRCLK_IN                (gt0_txusrclk_i),
        .GT1_RXUSRCLK2_IN               (gt0_txusrclk_i),
        //---------------- Receive Ports - FPGA RX interface Ports -----------------
        .GT1_RXDATA_OUT                 (gt1_rxdata_i),
        //---------------- Receive Ports - RX 8B/10B Decoder Ports -----------------
        .GT1_RXDISPERR_OUT              (gt1_rxdisperr_i),
        .GT1_RXNOTINTABLE_OUT           (gt1_rxnotintable_i),
        //------------------------- Receive Ports - RX AFE -------------------------
        .GT1_GTXRXP_IN                  (RXP_IN[1]),
        //---------------------- Receive Ports - RX AFE Ports ----------------------
        .GT1_GTXRXN_IN                  (RXN_IN[1]),
        //---------------- Receive Ports - RX Channel Bonding Ports ----------------
        .GT1_RXCHANBONDSEQ_OUT          (gt1_rxchanbondseq_i),
        .GT1_RXCHBONDEN_IN              (gt1_rxchbonden_i),
        .GT1_RXCHBONDLEVEL_IN           (3'b001),
        .GT1_RXCHBONDMASTER_IN          (tied_to_ground_i),
        .GT1_RXCHBONDO_OUT              (gt1_rxchbondo_i),
        .GT1_RXCHBONDSLAVE_IN           (tied_to_vcc_i),
        //--------------- Receive Ports - RX Channel Bonding Ports  ----------------
        .GT1_RXCHANISALIGNED_OUT        (gt1_rxchanisaligned_i),
        .GT1_RXCHANREALIGN_OUT          (gt1_rxchanrealign_i),
        //----------- Receive Ports - RX Initialization and Reset Ports ------------
        .GT1_GTRXRESET_IN               (gt1_gtrxreset_i),
        .GT1_RXPMARESET_IN              (gt1_rxpmareset_i),
        //----------------- Receive Ports - RX8B/10B Decoder Ports -----------------
        .GT1_RXCHARISK_OUT              (gt1_rxcharisk_i),
        //---------------- Receive Ports - Rx Channel Bonding Ports ----------------
        .GT1_RXCHBONDI_IN               (gt2_rxchbondo_i),
        //------------ Receive Ports -RX Initialization and Reset Ports ------------
        .GT1_RXRESETDONE_OUT            (gt1_rxresetdone_i),
        //------------------- TX Initialization and Reset Ports --------------------
        .GT1_GTTXRESET_IN               (gt1_gttxreset_i),
        .GT1_TXUSERRDY_IN               (gt1_txuserrdy_i),
        //---------------- Transmit Ports - FPGA TX Interface Ports ----------------
        .GT1_TXUSRCLK_IN                (gt0_txusrclk_i),
        .GT1_TXUSRCLK2_IN               (gt0_txusrclk_i),
        //---------------- Transmit Ports - TX Data Path interface -----------------
        .GT1_TXDATA_IN                  (gt1_txdata_i),
        //-------------- Transmit Ports - TX Driver and OOB signaling --------------
        .GT1_GTXTXN_OUT                 (TXN_OUT[1]),
        .GT1_GTXTXP_OUT                 (TXP_OUT[1]),
        //--------- Transmit Ports - TX Fabric Clock Output Control Ports ----------
        .GT1_TXOUTCLK_OUT               (gt1_txoutclk_i),
        .GT1_TXOUTCLKFABRIC_OUT         (gt1_txoutclkfabric_i),
        .GT1_TXOUTCLKPCS_OUT            (gt1_txoutclkpcs_i),
        //------------------- Transmit Ports - TX Gearbox Ports --------------------
        .GT1_TXCHARISK_IN               (gt1_txcharisk_i),
        //----------- Transmit Ports - TX Initialization and Reset Ports -----------
        .GT1_TXRESETDONE_OUT            (gt1_txresetdone_i),


 
 

        //_____________________________________________________________________
        //_____________________________________________________________________
        //GT2  (X1Y2)

        //------------------------------- CPLL Ports -------------------------------
        .GT2_CPLLFBCLKLOST_OUT          (gt2_cpllfbclklost_i),
        .GT2_CPLLLOCK_OUT               (gt2_cplllock_i),
        .GT2_CPLLLOCKDETCLK_IN          (drpclk_in_i),
        .GT2_CPLLRESET_IN               (gt2_cpllreset_i),
        //------------------------ Channel - Clocking Ports ------------------------
        .GT2_GTREFCLK0_IN               (q0_clk0_refclk_i),
        //-------------------------- Channel - DRP Ports  --------------------------
        .GT2_DRPADDR_IN                 (gt2_drpaddr_i),
        .GT2_DRPCLK_IN                  (drpclk_in_i),
        .GT2_DRPDI_IN                   (gt2_drpdi_i),
        .GT2_DRPDO_OUT                  (gt2_drpdo_i),
        .GT2_DRPEN_IN                   (gt2_drpen_i),
        .GT2_DRPRDY_OUT                 (gt2_drprdy_i),
        .GT2_DRPWE_IN                   (gt2_drpwe_i),
        //----------------------------- Loopback Ports -----------------------------
        .GT2_LOOPBACK_IN                (gt2_loopback_i),
        //------------------- RX Initialization and Reset Ports --------------------
        .GT2_RXUSERRDY_IN               (gt2_rxuserrdy_i),
        //------------------------ RX Margin Analysis Ports ------------------------
        .GT2_EYESCANDATAERROR_OUT       (gt2_eyescandataerror_i),
        //----------------------- Receive Ports - CDR Ports ------------------------
        .GT2_RXCDRLOCK_OUT              (gt2_rxcdrlock_i),
        //---------------- Receive Ports - FPGA RX Interface Ports -----------------
        .GT2_RXUSRCLK_IN                (gt0_txusrclk_i),
        .GT2_RXUSRCLK2_IN               (gt0_txusrclk_i),
        //---------------- Receive Ports - FPGA RX interface Ports -----------------
        .GT2_RXDATA_OUT                 (gt2_rxdata_i),
        //---------------- Receive Ports - RX 8B/10B Decoder Ports -----------------
        .GT2_RXDISPERR_OUT              (gt2_rxdisperr_i),
        .GT2_RXNOTINTABLE_OUT           (gt2_rxnotintable_i),
        //------------------------- Receive Ports - RX AFE -------------------------
        .GT2_GTXRXP_IN                  (RXP_IN[2]),
        //---------------------- Receive Ports - RX AFE Ports ----------------------
        .GT2_GTXRXN_IN                  (RXN_IN[2]),
        //---------------- Receive Ports - RX Channel Bonding Ports ----------------
        .GT2_RXCHANBONDSEQ_OUT          (gt2_rxchanbondseq_i),
        .GT2_RXCHBONDEN_IN              (gt2_rxchbonden_i),
        .GT2_RXCHBONDLEVEL_IN           (3'b010),
        .GT2_RXCHBONDMASTER_IN          (tied_to_vcc_i),
        .GT2_RXCHBONDO_OUT              (gt2_rxchbondo_i),
        .GT2_RXCHBONDSLAVE_IN           (tied_to_ground_i),
        //--------------- Receive Ports - RX Channel Bonding Ports  ----------------
        .GT2_RXCHANISALIGNED_OUT        (gt2_rxchanisaligned_i),
        .GT2_RXCHANREALIGN_OUT          (gt2_rxchanrealign_i),
        //----------- Receive Ports - RX Initialization and Reset Ports ------------
        .GT2_GTRXRESET_IN               (gt2_gtrxreset_i),
        .GT2_RXPMARESET_IN              (gt2_rxpmareset_i),
        //----------------- Receive Ports - RX8B/10B Decoder Ports -----------------
        .GT2_RXCHARISK_OUT              (gt2_rxcharisk_i),
        //---------------- Receive Ports - Rx Channel Bonding Ports ----------------
        .GT2_RXCHBONDI_IN               (tied_to_ground_vec_i[4:0]),
        //------------ Receive Ports -RX Initialization and Reset Ports ------------
        .GT2_RXRESETDONE_OUT            (gt2_rxresetdone_i),
        //------------------- TX Initialization and Reset Ports --------------------
        .GT2_GTTXRESET_IN               (gt2_gttxreset_i),
        .GT2_TXUSERRDY_IN               (gt2_txuserrdy_i),
        //---------------- Transmit Ports - FPGA TX Interface Ports ----------------
        .GT2_TXUSRCLK_IN                (gt0_txusrclk_i),
        .GT2_TXUSRCLK2_IN               (gt0_txusrclk_i),
        //---------------- Transmit Ports - TX Data Path interface -----------------
        .GT2_TXDATA_IN                  (gt2_txdata_i),
        //-------------- Transmit Ports - TX Driver and OOB signaling --------------
        .GT2_GTXTXN_OUT                 (TXN_OUT[2]),
        .GT2_GTXTXP_OUT                 (TXP_OUT[2]),
        //--------- Transmit Ports - TX Fabric Clock Output Control Ports ----------
        .GT2_TXOUTCLK_OUT               (gt2_txoutclk_i),
        .GT2_TXOUTCLKFABRIC_OUT         (gt2_txoutclkfabric_i),
        .GT2_TXOUTCLKPCS_OUT            (gt2_txoutclkpcs_i),
        //------------------- Transmit Ports - TX Gearbox Ports --------------------
        .GT2_TXCHARISK_IN               (gt2_txcharisk_i),
        //----------- Transmit Ports - TX Initialization and Reset Ports -----------
        .GT2_TXRESETDONE_OUT            (gt2_txresetdone_i),


 
 

        //_____________________________________________________________________
        //_____________________________________________________________________
        //GT3  (X1Y3)

        //------------------------------- CPLL Ports -------------------------------
        .GT3_CPLLFBCLKLOST_OUT          (gt3_cpllfbclklost_i),
        .GT3_CPLLLOCK_OUT               (gt3_cplllock_i),
        .GT3_CPLLLOCKDETCLK_IN          (drpclk_in_i),
        .GT3_CPLLRESET_IN               (gt3_cpllreset_i),
        //------------------------ Channel - Clocking Ports ------------------------
        .GT3_GTREFCLK0_IN               (q0_clk0_refclk_i),
        //-------------------------- Channel - DRP Ports  --------------------------
        .GT3_DRPADDR_IN                 (gt3_drpaddr_i),
        .GT3_DRPCLK_IN                  (drpclk_in_i),
        .GT3_DRPDI_IN                   (gt3_drpdi_i),
        .GT3_DRPDO_OUT                  (gt3_drpdo_i),
        .GT3_DRPEN_IN                   (gt3_drpen_i),
        .GT3_DRPRDY_OUT                 (gt3_drprdy_i),
        .GT3_DRPWE_IN                   (gt3_drpwe_i),
        //----------------------------- Loopback Ports -----------------------------
        .GT3_LOOPBACK_IN                (gt3_loopback_i),
        //------------------- RX Initialization and Reset Ports --------------------
        .GT3_RXUSERRDY_IN               (gt3_rxuserrdy_i),
        //------------------------ RX Margin Analysis Ports ------------------------
        .GT3_EYESCANDATAERROR_OUT       (gt3_eyescandataerror_i),
        //----------------------- Receive Ports - CDR Ports ------------------------
        .GT3_RXCDRLOCK_OUT              (gt3_rxcdrlock_i),
        //---------------- Receive Ports - FPGA RX Interface Ports -----------------
        .GT3_RXUSRCLK_IN                (gt0_txusrclk_i),
        .GT3_RXUSRCLK2_IN               (gt0_txusrclk_i),
        //---------------- Receive Ports - FPGA RX interface Ports -----------------
        .GT3_RXDATA_OUT                 (gt3_rxdata_i),
        //---------------- Receive Ports - RX 8B/10B Decoder Ports -----------------
        .GT3_RXDISPERR_OUT              (gt3_rxdisperr_i),
        .GT3_RXNOTINTABLE_OUT           (gt3_rxnotintable_i),
        //------------------------- Receive Ports - RX AFE -------------------------
        .GT3_GTXRXP_IN                  (RXP_IN[3]),
        //---------------------- Receive Ports - RX AFE Ports ----------------------
        .GT3_GTXRXN_IN                  (RXN_IN[3]),
        //---------------- Receive Ports - RX Channel Bonding Ports ----------------
        .GT3_RXCHANBONDSEQ_OUT          (gt3_rxchanbondseq_i),
        .GT3_RXCHBONDEN_IN              (gt3_rxchbonden_i),
        .GT3_RXCHBONDLEVEL_IN           (3'b001),
        .GT3_RXCHBONDMASTER_IN          (tied_to_ground_i),
        .GT3_RXCHBONDO_OUT              (gt3_rxchbondo_i),
        .GT3_RXCHBONDSLAVE_IN           (tied_to_vcc_i),
        //--------------- Receive Ports - RX Channel Bonding Ports  ----------------
        .GT3_RXCHANISALIGNED_OUT        (gt3_rxchanisaligned_i),
        .GT3_RXCHANREALIGN_OUT          (gt3_rxchanrealign_i),
        //----------- Receive Ports - RX Initialization and Reset Ports ------------
        .GT3_GTRXRESET_IN               (gt3_gtrxreset_i),
        .GT3_RXPMARESET_IN              (gt3_rxpmareset_i),
        //----------------- Receive Ports - RX8B/10B Decoder Ports -----------------
        .GT3_RXCHARISK_OUT              (gt3_rxcharisk_i),
        //---------------- Receive Ports - Rx Channel Bonding Ports ----------------
        .GT3_RXCHBONDI_IN               (gt2_rxchbondo_i),
        //------------ Receive Ports -RX Initialization and Reset Ports ------------
        .GT3_RXRESETDONE_OUT            (gt3_rxresetdone_i),
        //------------------- TX Initialization and Reset Ports --------------------
        .GT3_GTTXRESET_IN               (gt3_gttxreset_i),
        .GT3_TXUSERRDY_IN               (gt3_txuserrdy_i),
        //---------------- Transmit Ports - FPGA TX Interface Ports ----------------
        .GT3_TXUSRCLK_IN                (gt0_txusrclk_i),
        .GT3_TXUSRCLK2_IN               (gt0_txusrclk_i),
        //---------------- Transmit Ports - TX Data Path interface -----------------
        .GT3_TXDATA_IN                  (gt3_txdata_i),
        //-------------- Transmit Ports - TX Driver and OOB signaling --------------
        .GT3_GTXTXN_OUT                 (TXN_OUT[3]),
        .GT3_GTXTXP_OUT                 (TXP_OUT[3]),
        //--------- Transmit Ports - TX Fabric Clock Output Control Ports ----------
        .GT3_TXOUTCLK_OUT               (gt3_txoutclk_i),
        .GT3_TXOUTCLKFABRIC_OUT         (gt3_txoutclkfabric_i),
        .GT3_TXOUTCLKPCS_OUT            (gt3_txoutclkpcs_i),
        //------------------- Transmit Ports - TX Gearbox Ports --------------------
        .GT3_TXCHARISK_IN               (gt3_txcharisk_i),
        //----------- Transmit Ports - TX Initialization and Reset Ports -----------
        .GT3_TXRESETDONE_OUT            (gt3_txresetdone_i),




    //____________________________COMMON PORTS________________________________
        //-------------------- Common Block  - Ref Clock Ports ---------------------
        .GT0_GTREFCLK0_COMMON_IN        (q0_clk0_refclk_i),
        //----------------------- Common Block - QPLL Ports ------------------------
        .GT0_QPLLLOCK_OUT               (gt0_qplllock_i),
        .GT0_QPLLLOCKDETCLK_IN          (drpclk_in_i),
        .GT0_QPLLRESET_IN               (gt0_qpllreset_i)

    );

assign gt0_track_data_i = 1'b1;
assign gt1_track_data_i = 1'b1;
assign gt2_track_data_i = 1'b1;
assign gt3_track_data_i = 1'b1;




//-------------------------------------------------------------
    assign gt0_loopback_i   = tied_to_ground_vec_i[2:0];
    assign gt0_rxpmareset_i = tied_to_ground_i;
    assign gt0_drpaddr_i    = tied_to_ground_vec_i[8:0];
    assign gt0_drpdi_i      = tied_to_ground_vec_i[15:0];
    assign gt0_drpen_i      = tied_to_ground_i;
    assign gt0_drpwe_i      = tied_to_ground_i;
    assign gt1_loopback_i   = tied_to_ground_vec_i[2:0];
    assign gt1_rxpmareset_i = tied_to_ground_i;
    assign gt1_drpaddr_i    = tied_to_ground_vec_i[8:0];
    assign gt1_drpdi_i      = tied_to_ground_vec_i[15:0];
    assign gt1_drpen_i      = tied_to_ground_i;
    assign gt1_drpwe_i      = tied_to_ground_i;
    assign gt2_loopback_i   = tied_to_ground_vec_i[2:0];
    assign gt2_rxpmareset_i = tied_to_ground_i;
    assign gt2_drpaddr_i    = tied_to_ground_vec_i[8:0];
    assign gt2_drpdi_i      = tied_to_ground_vec_i[15:0];
    assign gt2_drpen_i      = tied_to_ground_i;
    assign gt2_drpwe_i      = tied_to_ground_i;
    assign gt3_loopback_i   = tied_to_ground_vec_i[2:0];
    assign gt3_rxpmareset_i = tied_to_ground_i;
    assign gt3_drpaddr_i    = tied_to_ground_vec_i[8:0];
    assign gt3_drpdi_i      = tied_to_ground_vec_i[15:0];
    assign gt3_drpen_i      = tied_to_ground_i;
    assign gt3_drpwe_i      = tied_to_ground_i;
    assign gt4_loopback_i   = tied_to_ground_vec_i[2:0];
    assign gt4_rxpmareset_i = tied_to_ground_i;
    assign gt4_drpaddr_i    = tied_to_ground_vec_i[8:0];
    assign gt4_drpdi_i      = tied_to_ground_vec_i[15:0];
    assign gt4_drpen_i      = tied_to_ground_i;
    assign gt4_drpwe_i      = tied_to_ground_i;
    assign gt5_loopback_i   = tied_to_ground_vec_i[2:0];
    assign gt5_rxpmareset_i = tied_to_ground_i;
    assign gt5_drpaddr_i    = tied_to_ground_vec_i[8:0];
    assign gt5_drpdi_i      = tied_to_ground_vec_i[15:0];
    assign gt5_drpen_i      = tied_to_ground_i;
    assign gt5_drpwe_i      = tied_to_ground_i;
    assign gt6_loopback_i   = tied_to_ground_vec_i[2:0];
    assign gt6_rxpmareset_i = tied_to_ground_i;
    assign gt6_drpaddr_i    = tied_to_ground_vec_i[8:0];
    assign gt6_drpdi_i      = tied_to_ground_vec_i[15:0];
    assign gt6_drpen_i      = tied_to_ground_i;
    assign gt6_drpwe_i      = tied_to_ground_i;
    assign gt7_loopback_i   = tied_to_ground_vec_i[2:0];
    assign gt7_rxpmareset_i = tied_to_ground_i;
    assign gt7_drpaddr_i    = tied_to_ground_vec_i[8:0];
    assign gt7_drpdi_i      = tied_to_ground_vec_i[15:0];
    assign gt7_drpen_i      = tied_to_ground_i;
    assign gt7_drpwe_i      = tied_to_ground_i;


endmodule
    
