`timescale 1ns / 1ps
`define DLY #1

(* DowngradeIPIdentifiedWarnings="yes" *)
//***********************************Entity Declaration************************
(* CORE_GENERATION_INFO = "serdes,gtwizard_v3_6_1,{protocol_file=Start_from_scratch}" *)
module serdes_exdes (
    input  wire       Q1_CLK0_GTREFCLK_PAD_N_IN,
    input  wire       Q1_CLK0_GTREFCLK_PAD_P_IN,
    input  wire       DRP_CLK_IN_P             ,
    input  wire       DRP_CLK_IN_N             ,
    input  wire       RESET_N                  ,
    input  wire [3:0] RXN_IN                   ,
    input  wire [3:0] RXP_IN                   ,
    output wire [3:0] TXN_OUT                  ,
    output wire [3:0] TXP_OUT
);
    reg soft_reset;
    reg soft_reset_i;

//************************** Register Declarations ****************************

    wire            gt_txfsmresetdone_i;
    wire            gt_rxfsmresetdone_i;
    (* ASYNC_REG = "TRUE" *)reg             gt_txfsmresetdone_r;
    (* ASYNC_REG = "TRUE" *)reg             gt_txfsmresetdone_r2;
    wire            gt0_txfsmresetdone_i;
    wire            gt0_rxfsmresetdone_i;
    (* ASYNC_REG = "TRUE" *)reg             gt0_txfsmresetdone_r;
    (* ASYNC_REG = "TRUE" *)reg             gt0_txfsmresetdone_r2;
    (* ASYNC_REG = "TRUE" *)reg             gt0_rxfsmresetdone_r;
    (* ASYNC_REG = "TRUE" *)reg             gt0_rxfsmresetdone_r2;
    (* ASYNC_REG = "TRUE" *)reg             gt0_rxresetdone_r;
    (* ASYNC_REG = "TRUE" *)reg             gt0_rxresetdone_r2;
    (* ASYNC_REG = "TRUE" *)reg             gt0_rxresetdone_r3;
    (* ASYNC_REG = "TRUE" *)reg             gt0_rxresetdone_vio_r;
    (* ASYNC_REG = "TRUE" *)reg             gt0_rxresetdone_vio_r2;
    (* ASYNC_REG = "TRUE" *)reg             gt0_rxresetdone_vio_r3;

    wire            gt1_txfsmresetdone_i;
    wire            gt1_rxfsmresetdone_i;
    (* ASYNC_REG = "TRUE" *)reg             gt1_txfsmresetdone_r;
    (* ASYNC_REG = "TRUE" *)reg             gt1_txfsmresetdone_r2;
    (* ASYNC_REG = "TRUE" *)reg             gt1_rxfsmresetdone_r;
    (* ASYNC_REG = "TRUE" *)reg             gt1_rxfsmresetdone_r2;
    (* ASYNC_REG = "TRUE" *)reg             gt1_rxresetdone_r;
    (* ASYNC_REG = "TRUE" *)reg             gt1_rxresetdone_r2;
    (* ASYNC_REG = "TRUE" *)reg             gt1_rxresetdone_r3;
    (* ASYNC_REG = "TRUE" *)reg             gt1_rxresetdone_vio_r;
    (* ASYNC_REG = "TRUE" *)reg             gt1_rxresetdone_vio_r2;
    (* ASYNC_REG = "TRUE" *)reg             gt1_rxresetdone_vio_r3;

    wire            gt2_txfsmresetdone_i;
    wire            gt2_rxfsmresetdone_i;
    (* ASYNC_REG = "TRUE" *)reg             gt2_txfsmresetdone_r;
    (* ASYNC_REG = "TRUE" *)reg             gt2_txfsmresetdone_r2;
    (* ASYNC_REG = "TRUE" *)reg             gt2_rxfsmresetdone_r;
    (* ASYNC_REG = "TRUE" *)reg             gt2_rxfsmresetdone_r2;
    (* ASYNC_REG = "TRUE" *)reg             gt2_rxresetdone_r;
    (* ASYNC_REG = "TRUE" *)reg             gt2_rxresetdone_r2;
    (* ASYNC_REG = "TRUE" *)reg             gt2_rxresetdone_r3;
    (* ASYNC_REG = "TRUE" *)reg             gt2_rxresetdone_vio_r;
    (* ASYNC_REG = "TRUE" *)reg             gt2_rxresetdone_vio_r2;
    (* ASYNC_REG = "TRUE" *)reg             gt2_rxresetdone_vio_r3;

    wire            gt3_txfsmresetdone_i;
    wire            gt3_rxfsmresetdone_i;
    (* ASYNC_REG = "TRUE" *)reg             gt3_txfsmresetdone_r;
    (* ASYNC_REG = "TRUE" *)reg             gt3_txfsmresetdone_r2;
    (* ASYNC_REG = "TRUE" *)reg             gt3_rxfsmresetdone_r;
    (* ASYNC_REG = "TRUE" *)reg             gt3_rxfsmresetdone_r2;
    (* ASYNC_REG = "TRUE" *)reg             gt3_rxresetdone_r;
    (* ASYNC_REG = "TRUE" *)reg             gt3_rxresetdone_r2;
    (* ASYNC_REG = "TRUE" *)reg             gt3_rxresetdone_r3;
    (* ASYNC_REG = "TRUE" *)reg             gt3_rxresetdone_vio_r;
    (* ASYNC_REG = "TRUE" *)reg             gt3_rxresetdone_vio_r2;
    (* ASYNC_REG = "TRUE" *)reg             gt3_rxresetdone_vio_r3;

    reg [5:0] reset_counter = 0;
    reg     [3:0]   reset_pulse;

//**************************** Wire Declarations ******************************//
    //------------------------ GT Wrapper Wires ------------------------------
    //________________________________________________________________________
    //________________________________________________________________________
    //GT0  (X1Y4)
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
    //------------------------- Digital Monitor Ports --------------------------
    wire    [7:0]   gt0_dmonitorout_i;
    //----------------------------- Loopback Ports -----------------------------
    wire    [2:0]   gt0_loopback_i;
    //------------------- RX Initialization and Reset Ports --------------------
    wire            gt0_eyescanreset_i;
    wire            gt0_rxuserrdy_i;
    //------------------------ RX Margin Analysis Ports ------------------------
    wire            gt0_eyescandataerror_i;
    wire            gt0_eyescantrigger_i;
    //---------------- Receive Ports - FPGA RX interface Ports -----------------
    wire    [15:0]  gt0_rxdata_i;
    //---------------- Receive Ports - RX 8B/10B Decoder Ports -----------------
    wire    [1:0]   gt0_rxdisperr_i;
    wire    [1:0]   gt0_rxnotintable_i;
    //------------------------- Receive Ports - RX AFE -------------------------
    wire            gt0_gtxrxp_i;
    //---------------------- Receive Ports - RX AFE Ports ----------------------
    wire            gt0_gtxrxn_i;
    //------------------- Receive Ports - RX Equalizer Ports -------------------
    wire            gt0_rxdfelpmreset_i;
    wire    [6:0]   gt0_rxmonitorout_i;
    wire    [1:0]   gt0_rxmonitorsel_i;
    //------------- Receive Ports - RX Fabric Output Control Ports -------------
    wire            gt0_rxoutclk_i;
    wire            gt0_rxoutclkfabric_i;
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
    //GT1  (X1Y5)
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
    //------------------------- Digital Monitor Ports --------------------------
    wire    [7:0]   gt1_dmonitorout_i;
    //----------------------------- Loopback Ports -----------------------------
    wire    [2:0]   gt1_loopback_i;
    //------------------- RX Initialization and Reset Ports --------------------
    wire            gt1_eyescanreset_i;
    wire            gt1_rxuserrdy_i;
    //------------------------ RX Margin Analysis Ports ------------------------
    wire            gt1_eyescandataerror_i;
    wire            gt1_eyescantrigger_i;
    //---------------- Receive Ports - FPGA RX interface Ports -----------------
    wire    [15:0]  gt1_rxdata_i;
    //---------------- Receive Ports - RX 8B/10B Decoder Ports -----------------
    wire    [1:0]   gt1_rxdisperr_i;
    wire    [1:0]   gt1_rxnotintable_i;
    //------------------------- Receive Ports - RX AFE -------------------------
    wire            gt1_gtxrxp_i;
    //---------------------- Receive Ports - RX AFE Ports ----------------------
    wire            gt1_gtxrxn_i;
    //------------------- Receive Ports - RX Equalizer Ports -------------------
    wire            gt1_rxdfelpmreset_i;
    wire    [6:0]   gt1_rxmonitorout_i;
    wire    [1:0]   gt1_rxmonitorsel_i;
    //------------- Receive Ports - RX Fabric Output Control Ports -------------
    wire            gt1_rxoutclk_i;
    wire            gt1_rxoutclkfabric_i;
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
    //GT2  (X1Y6)
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
    //------------------------- Digital Monitor Ports --------------------------
    wire    [7:0]   gt2_dmonitorout_i;
    //----------------------------- Loopback Ports -----------------------------
    wire    [2:0]   gt2_loopback_i;
    //------------------- RX Initialization and Reset Ports --------------------
    wire            gt2_eyescanreset_i;
    wire            gt2_rxuserrdy_i;
    //------------------------ RX Margin Analysis Ports ------------------------
    wire            gt2_eyescandataerror_i;
    wire            gt2_eyescantrigger_i;
    //---------------- Receive Ports - FPGA RX interface Ports -----------------
    wire    [15:0]  gt2_rxdata_i;
    //---------------- Receive Ports - RX 8B/10B Decoder Ports -----------------
    wire    [1:0]   gt2_rxdisperr_i;
    wire    [1:0]   gt2_rxnotintable_i;
    //------------------------- Receive Ports - RX AFE -------------------------
    wire            gt2_gtxrxp_i;
    //---------------------- Receive Ports - RX AFE Ports ----------------------
    wire            gt2_gtxrxn_i;
    //------------------- Receive Ports - RX Equalizer Ports -------------------
    wire            gt2_rxdfelpmreset_i;
    wire    [6:0]   gt2_rxmonitorout_i;
    wire    [1:0]   gt2_rxmonitorsel_i;
    //------------- Receive Ports - RX Fabric Output Control Ports -------------
    wire            gt2_rxoutclk_i;
    wire            gt2_rxoutclkfabric_i;
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
    //GT3  (X1Y7)
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
    //------------------------- Digital Monitor Ports --------------------------
    wire    [7:0]   gt3_dmonitorout_i;
    //----------------------------- Loopback Ports -----------------------------
    wire    [2:0]   gt3_loopback_i;
    //------------------- RX Initialization and Reset Ports --------------------
    wire            gt3_eyescanreset_i;
    wire            gt3_rxuserrdy_i;
    //------------------------ RX Margin Analysis Ports ------------------------
    wire            gt3_eyescandataerror_i;
    wire            gt3_eyescantrigger_i;
    //---------------- Receive Ports - FPGA RX interface Ports -----------------
    wire    [15:0]  gt3_rxdata_i;
    //---------------- Receive Ports - RX 8B/10B Decoder Ports -----------------
    wire    [1:0]   gt3_rxdisperr_i;
    wire    [1:0]   gt3_rxnotintable_i;
    //------------------------- Receive Ports - RX AFE -------------------------
    wire            gt3_gtxrxp_i;
    //---------------------- Receive Ports - RX AFE Ports ----------------------
    wire            gt3_gtxrxn_i;
    //------------------- Receive Ports - RX Equalizer Ports -------------------
    wire            gt3_rxdfelpmreset_i;
    wire    [6:0]   gt3_rxmonitorout_i;
    wire    [1:0]   gt3_rxmonitorsel_i;
    //------------- Receive Ports - RX Fabric Output Control Ports -------------
    wire            gt3_rxoutclk_i;
    wire            gt3_rxoutclkfabric_i;
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
    //-------------------- Common Block  - Ref Clock Ports ---------------------
    wire            gt0_gtrefclk1_common_i;
    //----------------------- Common Block - QPLL Ports ------------------------
    wire            gt0_qplllock_i;
    wire            gt0_qpllrefclklost_i;
    wire            gt0_qpllreset_i;


    //----------------------------- Global Signals -----------------------------

    wire            drpclk_in_i;
    wire            DRPCLK_IN;
    wire            gt0_tx_system_reset_c;
    wire            gt0_rx_system_reset_c;
    wire            gt1_tx_system_reset_c;
    wire            gt1_rx_system_reset_c;
    wire            gt2_tx_system_reset_c;
    wire            gt2_rx_system_reset_c;
    wire            gt3_tx_system_reset_c;
    wire            gt3_rx_system_reset_c;
    wire            tied_to_ground_i;
    wire    [63:0]  tied_to_ground_vec_i;
    wire            tied_to_vcc_i;
    wire    [7:0]   tied_to_vcc_vec_i;
    wire            GTTXRESET_IN;
    wire            GTRXRESET_IN;
    wire            CPLLRESET_IN;
    wire            QPLLRESET_IN;

     //--------------------------- User Clocks ---------------------------------
     wire            gt0_txusrclk_i; 
     wire            gt0_txusrclk2_i; 
     wire            gt0_rxusrclk_i; 
     wire            gt0_rxusrclk2_i; 
     wire            gt1_txusrclk_i; 
     wire            gt1_txusrclk2_i; 
     wire            gt1_rxusrclk_i; 
     wire            gt1_rxusrclk2_i; 
     wire            gt2_txusrclk_i; 
     wire            gt2_txusrclk2_i; 
     wire            gt2_rxusrclk_i; 
     wire            gt2_rxusrclk2_i; 
     wire            gt3_txusrclk_i; 
     wire            gt3_txusrclk2_i; 
     wire            gt3_rxusrclk_i; 
     wire            gt3_rxusrclk2_i; 
 
    //--------------------------- Reference Clocks ----------------------------
    
    wire            q1_clk0_refclk_i;


    //--------------------- Frame check/gen Module Signals --------------------
    wire            gt0_track_data_i;
    wire    [7:0]   gt0_error_count_i;
    wire            gt1_track_data_i;
    wire    [7:0]   gt1_error_count_i;
    wire            gt2_track_data_i;
    wire    [7:0]   gt2_error_count_i;
    wire            gt3_track_data_i;
    wire    [7:0]   gt3_error_count_i;
  

    //--------------------- Chipscope Signals ---------------------------------
    wire    [35:0]  tx_data_vio_control_i;
    wire    [35:0]  rx_data_vio_control_i;
    wire    [35:0]  shared_vio_control_i;
    wire    [35:0]  ila_control_i;
    wire    [35:0]  channel_drp_vio_control_i;
    wire    [35:0]  common_drp_vio_control_i;
    wire    [31:0]  tx_data_vio_async_in_i;
    wire    [31:0]  tx_data_vio_sync_in_i;
    wire    [31:0]  tx_data_vio_async_out_i;
    wire    [31:0]  tx_data_vio_sync_out_i;
    wire    [31:0]  rx_data_vio_async_in_i;
    wire    [31:0]  rx_data_vio_sync_in_i;
    wire    [31:0]  rx_data_vio_async_out_i;
    wire    [31:0]  rx_data_vio_sync_out_i;
    wire    [31:0]  shared_vio_in_i;
    wire    [31:0]  shared_vio_out_i;
    wire    [163:0] ila_in_i;
    wire    [31:0]  channel_drp_vio_async_in_i;
    wire    [31:0]  channel_drp_vio_sync_in_i;
    wire    [31:0]  channel_drp_vio_async_out_i;
    wire    [31:0]  channel_drp_vio_sync_out_i;
    wire    [31:0]  common_drp_vio_async_in_i;
    wire    [31:0]  common_drp_vio_sync_in_i;
    wire    [31:0]  common_drp_vio_async_out_i;
    wire    [31:0]  common_drp_vio_sync_out_i;

    wire    [31:0]  gt0_tx_data_vio_async_in_i;
    wire    [31:0]  gt0_tx_data_vio_sync_in_i;
    wire    [31:0]  gt0_tx_data_vio_async_out_i;
    wire    [31:0]  gt0_tx_data_vio_sync_out_i;
    wire    [31:0]  gt0_rx_data_vio_async_in_i;
    wire    [31:0]  gt0_rx_data_vio_sync_in_i;
    wire    [31:0]  gt0_rx_data_vio_async_out_i;
    wire    [31:0]  gt0_rx_data_vio_sync_out_i;
    wire    [163:0] gt0_ila_in_i;
    wire    [31:0]  gt0_channel_drp_vio_async_in_i;
    wire    [31:0]  gt0_channel_drp_vio_sync_in_i;
    wire    [31:0]  gt0_channel_drp_vio_async_out_i;
    wire    [31:0]  gt0_channel_drp_vio_sync_out_i;
    wire    [31:0]  gt0_common_drp_vio_async_in_i;
    wire    [31:0]  gt0_common_drp_vio_sync_in_i;
    wire    [31:0]  gt0_common_drp_vio_async_out_i;
    wire    [31:0]  gt0_common_drp_vio_sync_out_i;

    wire    [31:0]  gt1_tx_data_vio_async_in_i;
    wire    [31:0]  gt1_tx_data_vio_sync_in_i;
    wire    [31:0]  gt1_tx_data_vio_async_out_i;
    wire    [31:0]  gt1_tx_data_vio_sync_out_i;
    wire    [31:0]  gt1_rx_data_vio_async_in_i;
    wire    [31:0]  gt1_rx_data_vio_sync_in_i;
    wire    [31:0]  gt1_rx_data_vio_async_out_i;
    wire    [31:0]  gt1_rx_data_vio_sync_out_i;
    wire    [163:0] gt1_ila_in_i;
    wire    [31:0]  gt1_channel_drp_vio_async_in_i;
    wire    [31:0]  gt1_channel_drp_vio_sync_in_i;
    wire    [31:0]  gt1_channel_drp_vio_async_out_i;
    wire    [31:0]  gt1_channel_drp_vio_sync_out_i;
    wire    [31:0]  gt1_common_drp_vio_async_in_i;
    wire    [31:0]  gt1_common_drp_vio_sync_in_i;
    wire    [31:0]  gt1_common_drp_vio_async_out_i;
    wire    [31:0]  gt1_common_drp_vio_sync_out_i;

    wire    [31:0]  gt2_tx_data_vio_async_in_i;
    wire    [31:0]  gt2_tx_data_vio_sync_in_i;
    wire    [31:0]  gt2_tx_data_vio_async_out_i;
    wire    [31:0]  gt2_tx_data_vio_sync_out_i;
    wire    [31:0]  gt2_rx_data_vio_async_in_i;
    wire    [31:0]  gt2_rx_data_vio_sync_in_i;
    wire    [31:0]  gt2_rx_data_vio_async_out_i;
    wire    [31:0]  gt2_rx_data_vio_sync_out_i;
    wire    [163:0] gt2_ila_in_i;
    wire    [31:0]  gt2_channel_drp_vio_async_in_i;
    wire    [31:0]  gt2_channel_drp_vio_sync_in_i;
    wire    [31:0]  gt2_channel_drp_vio_async_out_i;
    wire    [31:0]  gt2_channel_drp_vio_sync_out_i;
    wire    [31:0]  gt2_common_drp_vio_async_in_i;
    wire    [31:0]  gt2_common_drp_vio_sync_in_i;
    wire    [31:0]  gt2_common_drp_vio_async_out_i;
    wire    [31:0]  gt2_common_drp_vio_sync_out_i;

    wire    [31:0]  gt3_tx_data_vio_async_in_i;
    wire    [31:0]  gt3_tx_data_vio_sync_in_i;
    wire    [31:0]  gt3_tx_data_vio_async_out_i;
    wire    [31:0]  gt3_tx_data_vio_sync_out_i;
    wire    [31:0]  gt3_rx_data_vio_async_in_i;
    wire    [31:0]  gt3_rx_data_vio_sync_in_i;
    wire    [31:0]  gt3_rx_data_vio_async_out_i;
    wire    [31:0]  gt3_rx_data_vio_sync_out_i;
    wire    [163:0] gt3_ila_in_i;
    wire    [31:0]  gt3_channel_drp_vio_async_in_i;
    wire    [31:0]  gt3_channel_drp_vio_sync_in_i;
    wire    [31:0]  gt3_channel_drp_vio_async_out_i;
    wire    [31:0]  gt3_channel_drp_vio_sync_out_i;
    wire    [31:0]  gt3_common_drp_vio_async_in_i;
    wire    [31:0]  gt3_common_drp_vio_sync_in_i;
    wire    [31:0]  gt3_common_drp_vio_async_out_i;
    wire    [31:0]  gt3_common_drp_vio_sync_out_i;


    wire            gttxreset_i;
    wire            gtrxreset_i;
    wire    [1:0]   mux_sel_i;

    wire            user_tx_reset_i;
    wire            user_rx_reset_i;
    wire            tx_vio_clk_i;
    wire            tx_vio_clk_mux_out_i;    
    wire            rx_vio_ila_clk_i;
    wire            rx_vio_ila_clk_mux_out_i;

    wire            cpllreset_i;
    


  wire [15:0] gt0_rxdata_ila ;
  wire [1:0]  gt0_rxcharisk_ila ;
  wire        gt0_rxresetdone_ila ;

  wire [15:0] gt1_rxdata_ila ;
  wire [1:0]  gt1_rxcharisk_ila ;
  wire        gt1_rxresetdone_ila ;

  wire [15:0] gt2_rxdata_ila ;
  wire [1:0]  gt2_rxcharisk_ila ;
  wire        gt2_rxresetdone_ila ;

  wire [15:0] gt3_rxdata_ila ;
  wire [1:0]  gt3_rxcharisk_ila ;
  wire        gt3_rxresetdone_ila ;

  wire [15:0] gt0_txdata_ila ;
  wire [1:0]  gt0_txcharisk_ila ;
  wire        gt0_txresetdone_ila ;

  wire [15:0] gt1_txdata_ila ;
  wire [1:0]  gt1_txcharisk_ila ;
  wire        gt1_txresetdone_ila ;

  wire [15:0] gt2_txdata_ila ;
  wire [1:0]  gt2_txcharisk_ila ;
  wire        gt2_txresetdone_ila ;

  wire [15:0] gt3_txdata_ila ;
  wire [1:0]  gt3_txcharisk_ila ;
  wire        gt3_txresetdone_ila ;

//**************************** Main Body of Code *******************************

    //  Static signal Assigments    
    assign tied_to_ground_i             = 1'b0;
    assign tied_to_ground_vec_i         = 64'h0000000000000000;
    assign tied_to_vcc_i                = 1'b1;
    assign tied_to_vcc_vec_i            = 8'hff;

    assign zero_vector_rx_80 = 0;
    assign zero_vector_rx_8 = 0;

    
assign  q1_clk0_refclk_i                     =  1'b0;

    //***********************************************************************//
    //                                                                       //
    //--------------------------- The GT Wrapper ----------------------------//
    //                                                                       //
    //***********************************************************************//
    
    // Use the instantiation template in the example directory to add the GT wrapper to your design.
    // In this example, the wrapper is wired up for basic operation with a frame generator and frame 
    // checker. The GTs will reset, then attempt to align and transmit data. If channel bonding is 
    // enabled, bonding should occur after alignment.


    serdes serdes_support_i (
        .soft_reset_tx_in           (soft_reset_i             ),
        .soft_reset_rx_in           (soft_reset_i             ),
        .dont_reset_on_data_error_in(tied_to_ground_i         ),
        .q1_clk0_gtrefclk_pad_n_in  (Q1_CLK0_GTREFCLK_PAD_N_IN),
        .q1_clk0_gtrefclk_pad_p_in  (Q1_CLK0_GTREFCLK_PAD_P_IN),
        .gt0_tx_fsm_reset_done_out  (gt0_txfsmresetdone_i     ),
        .gt0_rx_fsm_reset_done_out  (gt0_rxfsmresetdone_i     ),
        .gt0_data_valid_in          (1'b1                     ),
        .gt1_tx_fsm_reset_done_out  (gt1_txfsmresetdone_i     ),
        .gt1_rx_fsm_reset_done_out  (gt1_rxfsmresetdone_i     ),
        .gt1_data_valid_in          (1'b1                     ),
        .gt2_tx_fsm_reset_done_out  (gt2_txfsmresetdone_i     ),
        .gt2_rx_fsm_reset_done_out  (gt2_rxfsmresetdone_i     ),
        .gt2_data_valid_in          (1'b1                     ),
        .gt3_tx_fsm_reset_done_out  (gt3_txfsmresetdone_i     ),
        .gt3_rx_fsm_reset_done_out  (gt3_rxfsmresetdone_i     ),
        .gt3_data_valid_in          (1'b1                     ),
        
        .gt0_txusrclk_out           (gt0_txusrclk_i           ),
        .gt0_txusrclk2_out          (gt0_txusrclk2_i          ),
        .gt0_rxusrclk_out           (gt0_rxusrclk_i           ),
        .gt0_rxusrclk2_out          (gt0_rxusrclk2_i          ),
        
        .gt1_txusrclk_out           (gt1_txusrclk_i           ),
        .gt1_txusrclk2_out          (gt1_txusrclk2_i          ),
        .gt1_rxusrclk_out           (gt1_rxusrclk_i           ),
        .gt1_rxusrclk2_out          (gt1_rxusrclk2_i          ),
        
        .gt2_txusrclk_out           (gt2_txusrclk_i           ),
        .gt2_txusrclk2_out          (gt2_txusrclk2_i          ),
        .gt2_rxusrclk_out           (gt2_rxusrclk_i           ),
        .gt2_rxusrclk2_out          (gt2_rxusrclk2_i          ),
        
        .gt3_txusrclk_out           (gt3_txusrclk_i           ),
        .gt3_txusrclk2_out          (gt3_txusrclk2_i          ),
        .gt3_rxusrclk_out           (gt3_rxusrclk_i           ),
        .gt3_rxusrclk2_out          (gt3_rxusrclk2_i          ),
        
        
        //_____________________________________________________________________
        //_____________________________________________________________________
        //GT0  (X1Y4)
        
        //------------------------------- CPLL Ports -------------------------------
        .gt0_cpllfbclklost_out      (gt0_cpllfbclklost_i      ),
        .gt0_cplllock_out           (gt0_cplllock_i           ),
        .gt0_cpllreset_in           (tied_to_ground_i         ),
        //-------------------------- Channel - DRP Ports  --------------------------
        .gt0_drpaddr_in             (gt0_drpaddr_i            ),
        .gt0_drpdi_in               (gt0_drpdi_i              ),
        .gt0_drpdo_out              (gt0_drpdo_i              ),
        .gt0_drpen_in               (gt0_drpen_i              ),
        .gt0_drprdy_out             (gt0_drprdy_i             ),
        .gt0_drpwe_in               (gt0_drpwe_i              ),
        //------------------------- Digital Monitor Ports --------------------------
        .gt0_dmonitorout_out        (gt0_dmonitorout_i        ),
        //----------------------------- Loopback Ports -----------------------------
        .gt0_loopback_in            (gt0_loopback_i           ),
        //------------------- RX Initialization and Reset Ports --------------------
        .gt0_eyescanreset_in        (tied_to_ground_i         ),
        .gt0_rxuserrdy_in           (tied_to_ground_i         ),
        //------------------------ RX Margin Analysis Ports ------------------------
        .gt0_eyescandataerror_out   (gt0_eyescandataerror_i   ),
        .gt0_eyescantrigger_in      (tied_to_ground_i         ),
        //---------------- Receive Ports - FPGA RX interface Ports -----------------
        .gt0_rxdata_out             (gt0_rxdata_i             ),
        //---------------- Receive Ports - RX 8B/10B Decoder Ports -----------------
        .gt0_rxdisperr_out          (gt0_rxdisperr_i          ),
        .gt0_rxnotintable_out       (gt0_rxnotintable_i       ),
        //------------------------- Receive Ports - RX AFE -------------------------
        .gt0_gtxrxp_in              (RXP_IN[0]                ),
        //---------------------- Receive Ports - RX AFE Ports ----------------------
        .gt0_gtxrxn_in              (RXN_IN[0]                ),
        //------------------- Receive Ports - RX Equalizer Ports -------------------
        .gt0_rxdfelpmreset_in       (tied_to_ground_i         ),
        .gt0_rxmonitorout_out       (gt0_rxmonitorout_i       ),
        .gt0_rxmonitorsel_in        (2'b00                    ),
        //------------- Receive Ports - RX Fabric Output Control Ports -------------
        .gt0_rxoutclkfabric_out     (gt0_rxoutclkfabric_i     ),
        //----------- Receive Ports - RX Initialization and Reset Ports ------------
        .gt0_gtrxreset_in           (tied_to_ground_i         ),
        .gt0_rxpmareset_in          (gt0_rxpmareset_i         ),
        //----------------- Receive Ports - RX8B/10B Decoder Ports -----------------
        .gt0_rxcharisk_out          (gt0_rxcharisk_i          ),
        //------------ Receive Ports -RX Initialization and Reset Ports ------------
        .gt0_rxresetdone_out        (gt0_rxresetdone_i        ),
        //------------------- TX Initialization and Reset Ports --------------------
        .gt0_gttxreset_in           (tied_to_ground_i         ),
        .gt0_txuserrdy_in           (tied_to_ground_i         ),
        //---------------- Transmit Ports - TX Data Path interface -----------------
        .gt0_txdata_in              (gt0_txdata_i             ),
        //-------------- Transmit Ports - TX Driver and OOB signaling --------------
        .gt0_gtxtxn_out             (TXN_OUT[0]               ),
        .gt0_gtxtxp_out             (TXP_OUT[0]               ),
        //--------- Transmit Ports - TX Fabric Clock Output Control Ports ----------
        .gt0_txoutclkfabric_out     (gt0_txoutclkfabric_i     ),
        .gt0_txoutclkpcs_out        (gt0_txoutclkpcs_i        ),
        //------------------- Transmit Ports - TX Gearbox Ports --------------------
        .gt0_txcharisk_in           (gt0_txcharisk_i          ),
        //----------- Transmit Ports - TX Initialization and Reset Ports -----------
        .gt0_txresetdone_out        (gt0_txresetdone_i        ),
        
        
        
        //_____________________________________________________________________
        //_____________________________________________________________________
        //GT1  (X1Y5)
        
        //------------------------------- CPLL Ports -------------------------------
        .gt1_cpllfbclklost_out      (gt1_cpllfbclklost_i      ),
        .gt1_cplllock_out           (gt1_cplllock_i           ),
        .gt1_cpllreset_in           (tied_to_ground_i         ),
        //-------------------------- Channel - DRP Ports  --------------------------
        .gt1_drpaddr_in             (gt1_drpaddr_i            ),
        .gt1_drpdi_in               (gt1_drpdi_i              ),
        .gt1_drpdo_out              (gt1_drpdo_i              ),
        .gt1_drpen_in               (gt1_drpen_i              ),
        .gt1_drprdy_out             (gt1_drprdy_i             ),
        .gt1_drpwe_in               (gt1_drpwe_i              ),
        //------------------------- Digital Monitor Ports --------------------------
        .gt1_dmonitorout_out        (gt1_dmonitorout_i        ),
        //----------------------------- Loopback Ports -----------------------------
        .gt1_loopback_in            (gt1_loopback_i           ),
        //------------------- RX Initialization and Reset Ports --------------------
        .gt1_eyescanreset_in        (tied_to_ground_i         ),
        .gt1_rxuserrdy_in           (tied_to_ground_i         ),
        //------------------------ RX Margin Analysis Ports ------------------------
        .gt1_eyescandataerror_out   (gt1_eyescandataerror_i   ),
        .gt1_eyescantrigger_in      (tied_to_ground_i         ),
        //---------------- Receive Ports - FPGA RX interface Ports -----------------
        .gt1_rxdata_out             (gt1_rxdata_i             ),
        //---------------- Receive Ports - RX 8B/10B Decoder Ports -----------------
        .gt1_rxdisperr_out          (gt1_rxdisperr_i          ),
        .gt1_rxnotintable_out       (gt1_rxnotintable_i       ),
        //------------------------- Receive Ports - RX AFE -------------------------
        .gt1_gtxrxp_in              (RXP_IN[1]                ),
        //---------------------- Receive Ports - RX AFE Ports ----------------------
        .gt1_gtxrxn_in              (RXN_IN[1]                ),
        //------------------- Receive Ports - RX Equalizer Ports -------------------
        .gt1_rxdfelpmreset_in       (tied_to_ground_i         ),
        .gt1_rxmonitorout_out       (gt1_rxmonitorout_i       ),
        .gt1_rxmonitorsel_in        (2'b00                    ),
        //------------- Receive Ports - RX Fabric Output Control Ports -------------
        .gt1_rxoutclkfabric_out     (gt1_rxoutclkfabric_i     ),
        //----------- Receive Ports - RX Initialization and Reset Ports ------------
        .gt1_gtrxreset_in           (tied_to_ground_i         ),
        .gt1_rxpmareset_in          (gt1_rxpmareset_i         ),
        //----------------- Receive Ports - RX8B/10B Decoder Ports -----------------
        .gt1_rxcharisk_out          (gt1_rxcharisk_i          ),
        //------------ Receive Ports -RX Initialization and Reset Ports ------------
        .gt1_rxresetdone_out        (gt1_rxresetdone_i        ),
        //------------------- TX Initialization and Reset Ports --------------------
        .gt1_gttxreset_in           (tied_to_ground_i         ),
        .gt1_txuserrdy_in           (tied_to_ground_i         ),
        //---------------- Transmit Ports - TX Data Path interface -----------------
        .gt1_txdata_in              (gt1_txdata_i             ),
        //-------------- Transmit Ports - TX Driver and OOB signaling --------------
        .gt1_gtxtxn_out             (TXN_OUT[1]               ),
        .gt1_gtxtxp_out             (TXP_OUT[1]               ),
        //--------- Transmit Ports - TX Fabric Clock Output Control Ports ----------
        .gt1_txoutclkfabric_out     (gt1_txoutclkfabric_i     ),
        .gt1_txoutclkpcs_out        (gt1_txoutclkpcs_i        ),
        //------------------- Transmit Ports - TX Gearbox Ports --------------------
        .gt1_txcharisk_in           (gt1_txcharisk_i          ),
        //----------- Transmit Ports - TX Initialization and Reset Ports -----------
        .gt1_txresetdone_out        (gt1_txresetdone_i        ),
        
        
        
        //_____________________________________________________________________
        //_____________________________________________________________________
        //GT2  (X1Y6)
        
        //------------------------------- CPLL Ports -------------------------------
        .gt2_cpllfbclklost_out      (gt2_cpllfbclklost_i      ),
        .gt2_cplllock_out           (gt2_cplllock_i           ),
        .gt2_cpllreset_in           (tied_to_ground_i         ),
        //-------------------------- Channel - DRP Ports  --------------------------
        .gt2_drpaddr_in             (gt2_drpaddr_i            ),
        .gt2_drpdi_in               (gt2_drpdi_i              ),
        .gt2_drpdo_out              (gt2_drpdo_i              ),
        .gt2_drpen_in               (gt2_drpen_i              ),
        .gt2_drprdy_out             (gt2_drprdy_i             ),
        .gt2_drpwe_in               (gt2_drpwe_i              ),
        //------------------------- Digital Monitor Ports --------------------------
        .gt2_dmonitorout_out        (gt2_dmonitorout_i        ),
        //----------------------------- Loopback Ports -----------------------------
        .gt2_loopback_in            (gt2_loopback_i           ),
        //------------------- RX Initialization and Reset Ports --------------------
        .gt2_eyescanreset_in        (tied_to_ground_i         ),
        .gt2_rxuserrdy_in           (tied_to_ground_i         ),
        //------------------------ RX Margin Analysis Ports ------------------------
        .gt2_eyescandataerror_out   (gt2_eyescandataerror_i   ),
        .gt2_eyescantrigger_in      (tied_to_ground_i         ),
        //---------------- Receive Ports - FPGA RX interface Ports -----------------
        .gt2_rxdata_out             (gt2_rxdata_i             ),
        //---------------- Receive Ports - RX 8B/10B Decoder Ports -----------------
        .gt2_rxdisperr_out          (gt2_rxdisperr_i          ),
        .gt2_rxnotintable_out       (gt2_rxnotintable_i       ),
        //------------------------- Receive Ports - RX AFE -------------------------
        .gt2_gtxrxp_in              (RXP_IN[2]                ),
        //---------------------- Receive Ports - RX AFE Ports ----------------------
        .gt2_gtxrxn_in              (RXN_IN[2]                ),
        //------------------- Receive Ports - RX Equalizer Ports -------------------
        .gt2_rxdfelpmreset_in       (tied_to_ground_i         ),
        .gt2_rxmonitorout_out       (gt2_rxmonitorout_i       ),
        .gt2_rxmonitorsel_in        (2'b00                    ),
        //------------- Receive Ports - RX Fabric Output Control Ports -------------
        .gt2_rxoutclkfabric_out     (gt2_rxoutclkfabric_i     ),
        //----------- Receive Ports - RX Initialization and Reset Ports ------------
        .gt2_gtrxreset_in           (tied_to_ground_i         ),
        .gt2_rxpmareset_in          (gt2_rxpmareset_i         ),
        //----------------- Receive Ports - RX8B/10B Decoder Ports -----------------
        .gt2_rxcharisk_out          (gt2_rxcharisk_i          ),
        //------------ Receive Ports -RX Initialization and Reset Ports ------------
        .gt2_rxresetdone_out        (gt2_rxresetdone_i        ),
        //------------------- TX Initialization and Reset Ports --------------------
        .gt2_gttxreset_in           (tied_to_ground_i         ),
        .gt2_txuserrdy_in           (tied_to_ground_i         ),
        //---------------- Transmit Ports - TX Data Path interface -----------------
        .gt2_txdata_in              (gt2_txdata_i             ),
        //-------------- Transmit Ports - TX Driver and OOB signaling --------------
        .gt2_gtxtxn_out             (TXN_OUT[2]               ),
        .gt2_gtxtxp_out             (TXP_OUT[2]               ),
        //--------- Transmit Ports - TX Fabric Clock Output Control Ports ----------
        .gt2_txoutclkfabric_out     (gt2_txoutclkfabric_i     ),
        .gt2_txoutclkpcs_out        (gt2_txoutclkpcs_i        ),
        //------------------- Transmit Ports - TX Gearbox Ports --------------------
        .gt2_txcharisk_in           (gt2_txcharisk_i          ),
        //----------- Transmit Ports - TX Initialization and Reset Ports -----------
        .gt2_txresetdone_out        (gt2_txresetdone_i        ),
        
        
        
        //_____________________________________________________________________
        //_____________________________________________________________________
        //GT3  (X1Y7)
        
        //------------------------------- CPLL Ports -------------------------------
        .gt3_cpllfbclklost_out      (gt3_cpllfbclklost_i      ),
        .gt3_cplllock_out           (gt3_cplllock_i           ),
        .gt3_cpllreset_in           (tied_to_ground_i         ),
        //-------------------------- Channel - DRP Ports  --------------------------
        .gt3_drpaddr_in             (gt3_drpaddr_i            ),
        .gt3_drpdi_in               (gt3_drpdi_i              ),
        .gt3_drpdo_out              (gt3_drpdo_i              ),
        .gt3_drpen_in               (gt3_drpen_i              ),
        .gt3_drprdy_out             (gt3_drprdy_i             ),
        .gt3_drpwe_in               (gt3_drpwe_i              ),
        //------------------------- Digital Monitor Ports --------------------------
        .gt3_dmonitorout_out        (gt3_dmonitorout_i        ),
        //----------------------------- Loopback Ports -----------------------------
        .gt3_loopback_in            (gt3_loopback_i           ),
        //------------------- RX Initialization and Reset Ports --------------------
        .gt3_eyescanreset_in        (tied_to_ground_i         ),
        .gt3_rxuserrdy_in           (tied_to_ground_i         ),
        //------------------------ RX Margin Analysis Ports ------------------------
        .gt3_eyescandataerror_out   (gt3_eyescandataerror_i   ),
        .gt3_eyescantrigger_in      (tied_to_ground_i         ),
        //---------------- Receive Ports - FPGA RX interface Ports -----------------
        .gt3_rxdata_out             (gt3_rxdata_i             ),
        //---------------- Receive Ports - RX 8B/10B Decoder Ports -----------------
        .gt3_rxdisperr_out          (gt3_rxdisperr_i          ),
        .gt3_rxnotintable_out       (gt3_rxnotintable_i       ),
        //------------------------- Receive Ports - RX AFE -------------------------
        .gt3_gtxrxp_in              (RXP_IN[3]                ),
        //---------------------- Receive Ports - RX AFE Ports ----------------------
        .gt3_gtxrxn_in              (RXN_IN[3]                ),
        //------------------- Receive Ports - RX Equalizer Ports -------------------
        .gt3_rxdfelpmreset_in       (tied_to_ground_i         ),
        .gt3_rxmonitorout_out       (gt3_rxmonitorout_i       ),
        .gt3_rxmonitorsel_in        (2'b00                    ),
        //------------- Receive Ports - RX Fabric Output Control Ports -------------
        .gt3_rxoutclkfabric_out     (gt3_rxoutclkfabric_i     ),
        //----------- Receive Ports - RX Initialization and Reset Ports ------------
        .gt3_gtrxreset_in           (tied_to_ground_i         ),
        .gt3_rxpmareset_in          (gt3_rxpmareset_i         ),
        //----------------- Receive Ports - RX8B/10B Decoder Ports -----------------
        .gt3_rxcharisk_out          (gt3_rxcharisk_i          ),
        //------------ Receive Ports -RX Initialization and Reset Ports ------------
        .gt3_rxresetdone_out        (gt3_rxresetdone_i        ),
        //------------------- TX Initialization and Reset Ports --------------------
        .gt3_gttxreset_in           (tied_to_ground_i         ),
        .gt3_txuserrdy_in           (tied_to_ground_i         ),
        //---------------- Transmit Ports - TX Data Path interface -----------------
        .gt3_txdata_in              (gt3_txdata_i             ),
        //-------------- Transmit Ports - TX Driver and OOB signaling --------------
        .gt3_gtxtxn_out             (TXN_OUT[3]               ),
        .gt3_gtxtxp_out             (TXP_OUT[3]               ),
        //--------- Transmit Ports - TX Fabric Clock Output Control Ports ----------
        .gt3_txoutclkfabric_out     (gt3_txoutclkfabric_i     ),
        .gt3_txoutclkpcs_out        (gt3_txoutclkpcs_i        ),
        //------------------- Transmit Ports - TX Gearbox Ports --------------------
        .gt3_txcharisk_in           (gt3_txcharisk_i          ),
        //----------- Transmit Ports - TX Initialization and Reset Ports -----------
        .gt3_txresetdone_out        (gt3_txresetdone_i        ),
        
        
        //____________________________COMMON PORTS________________________________
        .gt0_qplloutclk_out         (                         ),
        .gt0_qplloutrefclk_out      (                         ),
        .sysclk_in                  (drpclk_in_i              )
    );

  clk_wiz_0 instance_name
   (
   // Clock in ports
    .clk_in1_p(DRP_CLK_IN_P),    // input clk_in1_p
    .clk_in1_n(DRP_CLK_IN_N),    // input clk_in1_n
    // Clock out ports
    .clk_out1(DRPCLK_IN));    // output clk_out1

    BUFG DRP_CLK_BUFG
    (
        .I                              (DRPCLK_IN),
        .O                              (drpclk_in_i) 
    );

 
    //***********************************************************************//
    //                                                                       //
    //--------------------------- User Module Resets-------------------------//
    //                                                                       //
    //***********************************************************************//
    // All the User Modules i.e. FRAME_GEN, FRAME_CHECK and the sync modules
    // are held in reset till the RESETDONE goes high. 
    // The RESETDONE is registered a couple of times on *USRCLK2 and connected 
    // to the reset of the modules
    
always @(posedge gt0_rxusrclk2_i or negedge gt0_rxresetdone_i)

    begin
        if (!gt0_rxresetdone_i)
        begin
            gt0_rxresetdone_r    <=   `DLY 1'b0;
            gt0_rxresetdone_r2   <=   `DLY 1'b0;
            gt0_rxresetdone_r3   <=   `DLY 1'b0;
        end
        else
        begin
            gt0_rxresetdone_r    <=   `DLY gt0_rxresetdone_i;
            gt0_rxresetdone_r2   <=   `DLY gt0_rxresetdone_r;
            gt0_rxresetdone_r3   <=   `DLY gt0_rxresetdone_r2;
        end
    end

    
    
always @(posedge  gt0_txusrclk2_i or negedge gt0_txfsmresetdone_i)

    begin
        if (!gt0_txfsmresetdone_i)
        begin
            gt0_txfsmresetdone_r    <=   `DLY 1'b0;
            gt0_txfsmresetdone_r2   <=   `DLY 1'b0;
        end
        else
        begin
            gt0_txfsmresetdone_r    <=   `DLY gt0_txfsmresetdone_i;
            gt0_txfsmresetdone_r2   <=   `DLY gt0_txfsmresetdone_r;
        end
    end

always @(posedge gt1_rxusrclk2_i or negedge gt1_rxresetdone_i)

    begin
        if (!gt1_rxresetdone_i)
        begin
            gt1_rxresetdone_r    <=   `DLY 1'b0;
            gt1_rxresetdone_r2   <=   `DLY 1'b0;
            gt1_rxresetdone_r3   <=   `DLY 1'b0;
        end
        else
        begin
            gt1_rxresetdone_r    <=   `DLY gt1_rxresetdone_i;
            gt1_rxresetdone_r2   <=   `DLY gt1_rxresetdone_r;
            gt1_rxresetdone_r3   <=   `DLY gt1_rxresetdone_r2;
        end
    end

    
    
always @(posedge  gt1_txusrclk2_i or negedge gt1_txfsmresetdone_i)

    begin
        if (!gt1_txfsmresetdone_i)
        begin
            gt1_txfsmresetdone_r    <=   `DLY 1'b0;
            gt1_txfsmresetdone_r2   <=   `DLY 1'b0;
        end
        else
        begin
            gt1_txfsmresetdone_r    <=   `DLY gt1_txfsmresetdone_i;
            gt1_txfsmresetdone_r2   <=   `DLY gt1_txfsmresetdone_r;
        end
    end

always @(posedge gt2_rxusrclk2_i or negedge gt2_rxresetdone_i)

    begin
        if (!gt2_rxresetdone_i)
        begin
            gt2_rxresetdone_r    <=   `DLY 1'b0;
            gt2_rxresetdone_r2   <=   `DLY 1'b0;
            gt2_rxresetdone_r3   <=   `DLY 1'b0;
        end
        else
        begin
            gt2_rxresetdone_r    <=   `DLY gt2_rxresetdone_i;
            gt2_rxresetdone_r2   <=   `DLY gt2_rxresetdone_r;
            gt2_rxresetdone_r3   <=   `DLY gt2_rxresetdone_r2;
        end
    end

    
    
always @(posedge  gt2_txusrclk2_i or negedge gt2_txfsmresetdone_i)

    begin
        if (!gt2_txfsmresetdone_i)
        begin
            gt2_txfsmresetdone_r    <=   `DLY 1'b0;
            gt2_txfsmresetdone_r2   <=   `DLY 1'b0;
        end
        else
        begin
            gt2_txfsmresetdone_r    <=   `DLY gt2_txfsmresetdone_i;
            gt2_txfsmresetdone_r2   <=   `DLY gt2_txfsmresetdone_r;
        end
    end

always @(posedge gt3_rxusrclk2_i or negedge gt3_rxresetdone_i)

    begin
        if (!gt3_rxresetdone_i)
        begin
            gt3_rxresetdone_r    <=   `DLY 1'b0;
            gt3_rxresetdone_r2   <=   `DLY 1'b0;
            gt3_rxresetdone_r3   <=   `DLY 1'b0;
        end
        else
        begin
            gt3_rxresetdone_r    <=   `DLY gt3_rxresetdone_i;
            gt3_rxresetdone_r2   <=   `DLY gt3_rxresetdone_r;
            gt3_rxresetdone_r3   <=   `DLY gt3_rxresetdone_r2;
        end
    end

    
    
always @(posedge  gt3_txusrclk2_i or negedge gt3_txfsmresetdone_i)

    begin
        if (!gt3_txfsmresetdone_i)
        begin
            gt3_txfsmresetdone_r    <=   `DLY 1'b0;
            gt3_txfsmresetdone_r2   <=   `DLY 1'b0;
        end
        else
        begin
            gt3_txfsmresetdone_r    <=   `DLY gt3_txfsmresetdone_i;
            gt3_txfsmresetdone_r2   <=   `DLY gt3_txfsmresetdone_r;
        end
    end

//-------------------------------------------------------------------------------------


//-------------------------Debug Signals assignment--------------------

//------------ optional Ports assignments --------------
assign  gt0_loopback_i                       =  3'b010;
 //------GTH/GTP
assign  gt0_rxdfelpmreset_i                  =  tied_to_ground_i;
assign  gt0_rxpmareset_i                     =  tied_to_ground_i;
assign  gt1_loopback_i                       =  3'b010;
 //------GTH/GTP
assign  gt1_rxdfelpmreset_i                  =  tied_to_ground_i;
assign  gt1_rxpmareset_i                     =  tied_to_ground_i;
assign  gt2_loopback_i                       =  3'b010;
 //------GTH/GTP
assign  gt2_rxdfelpmreset_i                  =  tied_to_ground_i;
assign  gt2_rxpmareset_i                     =  tied_to_ground_i;
assign  gt3_loopback_i                       =  3'b010;
 //------GTH/GTP
assign  gt3_rxdfelpmreset_i                  =  tied_to_ground_i;
assign  gt3_rxpmareset_i                     =  tied_to_ground_i;
//------------------------------------------------------
// assign resets for frame_gen modules
assign  gt0_tx_system_reset_c = !gt0_txfsmresetdone_r2;
assign  gt1_tx_system_reset_c = !gt1_txfsmresetdone_r2;
assign  gt2_tx_system_reset_c = !gt2_txfsmresetdone_r2;
assign  gt3_tx_system_reset_c = !gt3_txfsmresetdone_r2;

// assign resets for frame_check modules
assign  gt0_rx_system_reset_c = !gt0_rxresetdone_r3;
assign  gt1_rx_system_reset_c = !gt1_rxresetdone_r3;
assign  gt2_rx_system_reset_c = !gt2_rxresetdone_r3;
assign  gt3_rx_system_reset_c = !gt3_rxresetdone_r3;

assign gt0_drpaddr_i = 9'd0;
assign gt0_drpdi_i = 16'd0;
assign gt0_drpen_i = 1'b0;
assign gt0_drpwe_i = 1'b0;
assign gt1_drpaddr_i = 9'd0;
assign gt1_drpdi_i = 16'd0;
assign gt1_drpen_i = 1'b0;
assign gt1_drpwe_i = 1'b0;
assign gt2_drpaddr_i = 9'd0;
assign gt2_drpdi_i = 16'd0;
assign gt2_drpen_i = 1'b0;
assign gt2_drpwe_i = 1'b0;
assign gt3_drpaddr_i = 9'd0;
assign gt3_drpdi_i = 16'd0;
assign gt3_drpen_i = 1'b0;
assign gt3_drpwe_i = 1'b0;

//reset high valid
always @(posedge drpclk_in_i or negedge RESET_N) 
begin
    if(~RESET_N) begin
        soft_reset <= 1'b1;
    end else begin
        soft_reset <= 1'b0;
    end
end

always @(posedge drpclk_in_i or negedge RESET_N) 
begin
    if(~RESET_N) begin
        soft_reset_i <= 1'b1;
    end else begin
        soft_reset_i <= soft_reset;
    end
end

endmodule
    

