`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    18:56:37 04/16/2016 
// Design Name: 
// Module Name:    rgmii_top 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module rgmii_top(
    I_125mhz_clk      ,
    I_sys_rst_n     ,
    
    
    //=========GMAC-RGMII=========                    
    //=======rx=============                           
    rgmii_rxc		    ,  
    rgmii_rxd		    ,  
    rgmii_rx_ctl	    ,          
                                                        
    //========tx============                          
    rgmii_txc		    ,		  
    rgmii_txd		    ,		  
    rgmii_tx_ctl	    ,	
    	          
    //======output========                            
    mdc                 ,                      
    mdio                ,		   
    serial_response     ,
    phy_resetn
    
    );
input               I_125mhz_clk      ;
input               I_sys_rst_n     ; 



//====output====                   
output              serial_response     ;
output              phy_resetn          ;  
input               rgmii_rxc		    ;	
input[3:0]          rgmii_rxd		    ;	
input               rgmii_rx_ctl		;	    
output              rgmii_txc	        ; 
output[3:0]         rgmii_txd	        ;  
output              rgmii_tx_ctl	    ;			                                     
output              mdc                 ;                                         
output              mdio                ;

wire                gtx_clk_bufg    ;
wire                s_axi_aclk      ;
wire                refclk_bufg     ;
wire                gtx_clk90_bufg  ;
wire                dcm_locked      ; 


wire               rx_mac_aclk          ;       
wire               tx_mac_aclk          ;       
wire[7:0]          rx_axis_mac_tdata    ;       
wire               rx_axis_mac_tvalid   ;  
wire               rx_axis_mac_tlast    ;     
wire               tx_axis_mac_tready   ;       
wire[7:0]          tx_axis_mac_tdata    ;       
wire               tx_axis_mac_tvalid   ;       
wire               tx_axis_mac_tlast    ;       



rgmii_coe_clk_wiz clock_generator
  (
      // Clock in ports
      .I_125mhz_clk  (I_125mhz_clk      ),
      
      // Clock out ports
      .CLK_OUT1      (gtx_clk_bufg      ),
      .CLK_OUT2      (s_axi_aclk        ),
      .CLK_OUT3      (refclk_bufg       ),
      .CLK_OUT4      (gtx_clk90_bufg    ),
      // Status and control signals
      .RESET         (~I_sys_rst_n      ),
      .LOCKED        (dcm_locked        )
 );



rgmii_coe_example_design u_rgmii_coe_example_design (
    .glbl_rst               (~I_sys_rst_n           ),    
    .gtx_clk_bufg           (gtx_clk_bufg           ),
    .s_axi_aclk             (s_axi_aclk             ),
    .refclk_bufg            (refclk_bufg            ),
    .gtx_clk90_bufg         (gtx_clk90_bufg         ),
    .dcm_locked             (dcm_locked             ),
    
    
    .phy_resetn             (phy_resetn             ), 
    .rgmii_txd              (rgmii_txd              ), 
    .rgmii_tx_ctl           (rgmii_tx_ctl           ), 
    .rgmii_txc              (rgmii_txc              ), 
    .rgmii_rxd              (rgmii_rxd              ), 
    .rgmii_rx_ctl           (rgmii_rx_ctl           ), 
    .rgmii_rxc              (rgmii_rxc              ), 
    .mdio                   (mdio                   ), 
    .mdc                    (mdc                    ), 
    .tx_statistics_s        (tx_statistics_s        ), 
    .rx_statistics_s        (rx_statistics_s        ), 

    .serial_response        (serial_response        ), 
    .frame_error            (frame_error            ), 
    .frame_errorn           (frame_errorn           ), 
    .activity_flash         (activity_flash         ), 
    .activity_flashn        (activity_flashn        ),
    .rx_axis_mac_tdata      (rx_axis_mac_tdata      ),
    .rx_axis_mac_tvalid     (rx_axis_mac_tvalid     ),    
    .rx_axis_mac_tlast      (rx_axis_mac_tlast      ),
    .rx_mac_aclk            (rx_mac_aclk            ),
    .tx_axis_mac_tdata      (tx_axis_mac_tdata      ),
    .tx_axis_mac_tvalid     (tx_axis_mac_tvalid     ),
    .tx_axis_mac_tlast      (tx_axis_mac_tlast      ),
    .tx_axis_mac_tready     (tx_axis_mac_tready     ),
    .tx_mac_aclk            (tx_mac_aclk            )
                            
    );


gmac_if gmac_if_u(
    //====system reset====
    .I_reset_n               (I_sys_rst_n         ),
    
    //====system clock====
    .I_sys_clk               (s_axi_aclk        ),
    
    //====GMAC signal====
    //====Receiver Interface====
    .I_rx_mac_aclk           (rx_mac_aclk         ),
    .I_rx_reset              (W_rx_reset          ),
    .I_rx_axis_mac_tdata     (rx_axis_mac_tdata   ),
    .I_rx_axis_mac_tvalid    (rx_axis_mac_tvalid  ),
    .I_rx_axis_mac_tlast     (rx_axis_mac_tlast   ),
    .I_rx_axis_mac_tuser     (W_rx_axis_mac_tuser ),

    //====Transmitter Interface====
    .I_tx_mac_aclk           (W_tx_mac_aclk       ),
    .I_tx_reset              (W_tx_reset          ),
    .O_tx_axis_mac_tdata     (tx_axis_mac_tdata   ),
    .I_tx_axis_mac_tvalid    (tx_axis_mac_tvalid  ),
    .O_tx_axis_mac_tlast     (tx_axis_mac_tlast   ),
    .O_tx_axis_mac_tuser     (W_tx_axis_mac_tuser ),
    .O_tx_axis_mac_tready    (tx_axis_mac_tready),
    
    //====ctrl signal====
    //====input====
    .I_answer_rx_ena         (I_answer_rx_ena     ),
    .I_answer_rx_dat         (I_answer_rx_dat     ),
    
    //====output====
    .O_config_ena            (O_config_ena        ),
    .O_config_dat            (O_config_dat        ),
    .O_cof_data              (W_cof_data          ),
    .O_cfar_cof              (W_cfar_cof          ),
    
    //====input====
    //====from FPGA1====
    .I_target_end            (W_target_end        ),
    .I_target_ena            (W_target_ena        ),
    .I_target_energy         (W_target_energy     ),
    .I_target_range          (W_target_range      ),
    
    //====cfar input====                          
    .I_cfar_ena              (W_cfar_data_ena     ),
    .I_cfar_range            (W_cfar_range        ),
    .I_cfar_energy           (W_cfar_energy       ),
    .I_cfar_speed            (W_cfar_speed        )
    );
//-------------------------------GMAC------------------------------------

endmodule
