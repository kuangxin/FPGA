`timescale 1ns / 100ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   20:28:38 02/18/2016
// Design Name:   fft_rc
// Module Name:   G:/LFMCW/fft_simulation/K7_FFT/top.v
// Project Name:  K7_FFT
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: fft_rc
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

`timescale 1ns/100ps
module top(
    //====system reset signal====
    I_sys_rst_n                 ,
    I_400mhz_clk_p              ,
    I_400mhz_clk_n              ,
    I_100mhz_clk_p              ,
    I_100mhz_clk_n              ,
    I_125mhz_clk                ,
    
    
    //==== signal to 2-K7====
    O_m_ctrl_ena                ,
    O_m_ctrl_mode               ,
    O_s_ctrl_ena                ,
    O_s_ctrl_mode               ,
    //====Serdes singal====
    Q0_CLK0_GTREFCLK_PAD_N_IN   ,
    Q0_CLK0_GTREFCLK_PAD_P_IN   ,
    Q2_CLK0_GTREFCLK_PAD_N_IN   ,
    Q2_CLK0_GTREFCLK_PAD_P_IN   , 
    RXN_IN                      ,
    RXP_IN                      ,
    TXN_OUT                     ,
    TXP_OUT                         
    );
//------------------------------------------External Signal Definitions------------------------------------------
//====input====
input           I_sys_rst_n                 ;
input           I_400mhz_clk_p              ;
input           I_400mhz_clk_n              ;
input           I_100mhz_clk_p              ;
input           I_100mhz_clk_n              ;
input           I_125mhz_clk                ;
input           Q0_CLK0_GTREFCLK_PAD_N_IN   ;
input           Q0_CLK0_GTREFCLK_PAD_P_IN   ;
input           Q2_CLK0_GTREFCLK_PAD_N_IN   ;
input           Q2_CLK0_GTREFCLK_PAD_P_IN   ;
input  [7:0]    RXN_IN                      ;  
input  [7:0]    RXP_IN                      ;  

//====output====
output [7:0]    TXN_OUT                     ;  
output [7:0]    TXP_OUT                     ;  
output          O_m_ctrl_ena                ;
output[1:0]     O_m_ctrl_mode               ;
output          O_s_ctrl_ena                ;
output[1:0]     O_s_ctrl_mode               ;

//----------------------------------------------Reg Definitions---------------------------------------------------
//====parameter====
wire            W_m_ctrl_ena                ;
wire[1:0]       W_m_ctrl_mode               ;

assign O_m_ctrl_ena   =W_m_ctrl_ena;
assign O_m_ctrl_mode  =W_m_ctrl_mode;
assign O_s_ctrl_ena   =W_m_ctrl_ena;
assign O_s_ctrl_mode  =W_m_ctrl_mode;

//====internal register define====
//====LVDS signal====
wire            W_ad_400_clk        ;
wire[13:0]      W_ad1_dat           ;
wire[13:0]      W_ad1_delay_dat     ;
wire[23:0]      W1_ad_i_dat         ;
wire[23:0]      W1_ad_q_dat         ;
wire            W_200mhz_clk        ;



//==== serdes if====
wire            gt0_txusrclk_i      ;
wire[15:0]      gt0_txdata_i        ;
wire[1:0]       gt0_txcharisk_i     ;
wire            gt0_rxusrclk_i      ;
wire[15:0]      gt0_rxdata_i        ;
wire[1:0]       gt0_rxcharisk_i     ;
wire[15:0]      gt1_txdata_i        ;
wire[1:0]       gt1_txcharisk_i     ;
wire            gt1_rxusrclk_i      ;
wire[15:0]      gt1_rxdata_i        ;
wire[1:0]       gt1_rxcharisk_i     ;
wire[15:0]      gt2_txdata_i        ;
wire[1:0]       gt2_txcharisk_i     ;
wire            gt2_rxusrclk_i      ;
wire[15:0]      gt2_rxdata_i        ;
wire[1:0]       gt2_rxcharisk_i     ;
wire[15:0]      gt3_txdata_i        ;
wire[1:0]       gt3_txcharisk_i     ;
wire            gt3_rxusrclk_i      ;
wire[15:0]      gt3_rxdata_i        ;
wire[1:0]       gt3_rxcharisk_i     ;
wire            gt4_txusrclk_i      ;
wire[15:0]      gt4_txdata_i        ;
wire[1:0]       gt4_txcharisk_i     ;
wire            gt4_rxusrclk_i      ;
wire[15:0]      gt4_rxdata_i        ;
wire[1:0]       gt4_rxcharisk_i     ;
wire[15:0]      gt5_txdata_i        ;
wire[1:0]       gt5_txcharisk_i     ;
wire            gt5_rxusrclk_i      ;
wire[15:0]      gt5_rxdata_i        ;
wire[1:0]       gt5_rxcharisk_i     ;
wire[15:0]      gt6_txdata_i        ;
wire[1:0]       gt6_txcharisk_i     ;
wire            gt6_rxusrclk_i      ;
wire[15:0]      gt6_rxdata_i        ;
wire[1:0]       gt6_rxcharisk_i     ;
wire[15:0]      gt7_txdata_i        ;
wire[1:0]       gt7_txcharisk_i     ;
wire            gt7_rxusrclk_i      ;
wire[15:0]      gt7_rxdata_i        ;
wire[1:0]       gt7_rxcharisk_i     ;
wire[15:0]      W_rx_user_data0     ;
wire            W_rx_user_en0       ;
wire[15:0]      W_tx_user_data0     ;
wire            W_tx_user_en0       ;
wire[15:0]      W_rx_user_data1     ;
wire            W_rx_user_en1       ;
wire[15:0]      W_tx_user_data1     ;
wire            W_tx_user_en1       ;
wire[15:0]      W_rx_user_data2     ;
wire            W_rx_user_en2       ;
wire[15:0]      W_tx_user_data2     ;
wire            W_tx_user_en2       ;
wire[15:0]      W_rx_user_data3     ;
wire            W_rx_user_en3       ;
wire[15:0]      W_tx_user_data3     ;
wire            W_tx_user_en3       ; 
wire[15:0]      W_rx_user_data4     ;
wire            W_rx_user_en4       ;
wire[15:0]      W_tx_user_data4     ;
wire            W_tx_user_en4       ;
wire[15:0]      W_rx_user_data5     ;
wire            W_rx_user_en5       ;
wire[15:0]      W_tx_user_data5     ;
wire            W_tx_user_en5       ;
wire[15:0]      W_rx_user_data6     ;
wire            W_rx_user_en6       ;
wire[15:0]      W_tx_user_data6     ;
wire            W_tx_user_en6       ;
wire[15:0]      W_rx_user_data7     ;
wire            W_rx_user_en7       ;
wire[15:0]      W_tx_user_data7     ;
wire            W_tx_user_en7       ; 
wire            W_100mhz_clk        ;
wire            DRP_CLK_IN          ;

//---------------------------------------------Main Body of Code---------------------------------------------------
dcm_400mhz	dcm_400mhz_u(// Clock in ports
    .CLK_IN1_P  (I_400mhz_clk_p ),
    .CLK_IN1_N  (I_400mhz_clk_n ),
  // Clock out ports
    .CLK_OUT1   (W_ad_400_clk   ),
    .CLK_OUT2   (W_200mhz_clk   ),
    .CLK_OUT3   (DRP_CLK_IN     ),
  // Status and control signals
    .RESET      (~I_sys_rst_n   ),
    .LOCKED     ()
    );
IBUFGDS #(
    .DIFF_TERM       ("TRUE"        ),      // Differential Termination (Virtex-4/5, Spartan-3E/3A)
    .IOSTANDARD      ("DEFAULT"     )       // Specifies the I/O standard for this buffer
    ) 
    IBUFGDS_u(
    .O               (),//(W_100mhz_clk  ),      // Clock buffer output
    .I               (I_100mhz_clk_p),      // Diff_p clock buffer input
    .IB              (I_100mhz_clk_n)       // Diff_n clock buffer input
    );
        
dcm_100mhz	dcm_100mhz_u(// Clock in ports
    .CLK_IN1_P  (I_100mhz_clk_p ),
    .CLK_IN1_N  (I_100mhz_clk_n ),
  // Clock out ports
    .CLK_OUT1   (W_100mhz_clk   ),
  // Status and control signals
    .RESET      (~I_sys_rst_n   ),
    .LOCKED     ()
    );
        

//===================================accu_data===================================
accu_data   accu_data_u(
    //====system reset====
    .I_reset_n           (I_sys_rst_n        ),
                                             
    //====system clock====                   
    .I_sys_clk           (W_200mhz_clk       ),   //200MHz working clock
    .I_ctrl_ena          (W1_ctrl_ena        ),
    .I_ctrl_signal       (W1_ctrl_signal     ),
    .I_angle_info        (W_angle_info       ),
    .I_mach_angle_info   (W_mach_angel_info  ),
    
    //====FFT ctrl signal====
    //====input====
    .I_ifft1_dv          (W_ifft1_dv         ), 
    .I_ifft1_xk_re       (W_ifft1_xk_re[27:0]), 
    .I_ifft1_xk_im       (W_ifft1_xk_im[27:0]), 
    .I_ifft2_dv          (W_ifft2_dv         ), 
    .I_ifft2_xk_re       (W_ifft2_xk_re[27:0]), 
    .I_ifft2_xk_im       (W_ifft2_xk_im[27:0]), 
    .I_ifft3_dv          (W_ifft3_dv         ), 
    .I_ifft3_xk_re       (W_ifft3_xk_re[27:0]), 
    .I_ifft3_xk_im       (W_ifft3_xk_im[27:0]), 
    .I_ifft4_dv          (W_ifft4_dv         ), 
    .I_ifft4_xk_re       (W_ifft4_xk_re[27:0]), 
    .I_ifft4_xk_im       (W_ifft4_xk_im[27:0]), 
    .I_ifft5_dv          (W_ifft5_dv         ), 
    .I_ifft5_xk_re       (W_ifft5_xk_re[27:0]), 
    .I_ifft5_xk_im       (W_ifft5_xk_im[27:0]),
    .I_ifft1_edone       (W_ifft1_edone      ),
    .I_ifft2_edone       (W_ifft2_edone      ),
    .I_ifft3_edone       (W_ifft3_edone      ),
    .I_ifft4_edone       (W_ifft4_edone      ),
    .I_ifft5_edone       (W_ifft5_edone      ),

    //====ctrl output====
    .O_sqrt_ena          (W_sqrt_ena         ),
    .O_sqrt_data         (W_sqrt_data        ),
    .O_result_ena        (W_result_ena       ),
    .O_result_i_dat      (W_result_i_dat     ),
    .O_result_q_dat      (W_result_q_dat     ),
    .O_ctrl_en           (W_accu_ctrl_en     ),      
    .O_ctrl_signal       (W_mode_info        ),
    .O_angle_info        (W_angle_accu_info  ),
    .O_m_ctrl_mode       (W_m_ctrl_mode),
    .O_m_ctrl_ena        (W_m_ctrl_ena),
    .O_mach_angle_info   (W_mach_angle_accu  )
    );
//===================================accu_data===================================


serdes_coe_exdes  u_serdes_coe_exdes(
    .Q0_CLK0_GTREFCLK_PAD_N_IN  (Q0_CLK0_GTREFCLK_PAD_N_IN  ), 
    .Q0_CLK0_GTREFCLK_PAD_P_IN  (Q0_CLK0_GTREFCLK_PAD_P_IN  ),
    .Q2_CLK0_GTREFCLK_PAD_N_IN  (Q2_CLK0_GTREFCLK_PAD_N_IN  ), 
    .Q2_CLK0_GTREFCLK_PAD_P_IN  (Q2_CLK0_GTREFCLK_PAD_P_IN  ), 
    .RXN_IN                     (RXN_IN                     ), 
    .RXP_IN                     (RXP_IN                     ), 
    .TXN_OUT                    (TXN_OUT                    ), 
    .TXP_OUT                    (TXP_OUT                    ), 
    .I_sys_rst_n                (I_sys_rst_n                ),
    .gt0_txusrclk_i             (gt0_txusrclk_i             ), 
    .gt0_txdata_i               (gt0_txdata_i               ), 
    .gt0_txcharisk_i            (gt0_txcharisk_i            ), 
    .gt0_rxusrclk_i             (gt0_rxusrclk_i             ), 
    .gt0_rxdata_i               (gt0_rxdata_i               ), 
    .gt0_rxcharisk_i            (gt0_rxcharisk_i            ), 
    .gt1_txusrclk_i             (gt1_txusrclk_i             ),
    .gt1_txdata_i               (gt1_txdata_i               ),
    .gt1_txcharisk_i            (gt1_txcharisk_i            ),
    .gt1_rxusrclk_i             (gt1_rxusrclk_i             ),
    .gt1_rxdata_i               (gt1_rxdata_i               ),
    .gt1_rxcharisk_i            (gt1_rxcharisk_i            ),
    .gt2_txusrclk_i             (gt2_txusrclk_i             ),
    .gt2_txdata_i               (gt2_txdata_i               ),
    .gt2_txcharisk_i            (gt2_txcharisk_i            ),
    .gt2_rxusrclk_i             (gt2_rxusrclk_i             ),
    .gt2_rxdata_i               (gt2_rxdata_i               ),
    .gt2_rxcharisk_i            (gt2_rxcharisk_i            ),
    .gt3_txusrclk_i             (gt3_txusrclk_i             ),
    .gt3_txdata_i               (gt3_txdata_i               ),
    .gt3_txcharisk_i            (gt3_txcharisk_i            ),
    .gt3_rxusrclk_i             (gt3_rxusrclk_i             ),
    .gt3_rxdata_i               (gt3_rxdata_i               ),
    .gt3_rxcharisk_i            (gt3_rxcharisk_i            ),
    .gt4_txusrclk_i             (gt4_txusrclk_i             ),
    .gt4_txdata_i               (gt4_txdata_i               ),
    .gt4_txcharisk_i            (gt4_txcharisk_i            ),
    .gt4_rxusrclk_i             (gt4_rxusrclk_i             ),
    .gt4_rxdata_i               (gt4_rxdata_i               ),
    .gt4_rxcharisk_i            (gt4_rxcharisk_i            ),
    .gt5_txusrclk_i             (gt5_txusrclk_i             ),
    .gt5_txdata_i               (gt5_txdata_i               ),
    .gt5_txcharisk_i            (gt5_txcharisk_i            ),
    .gt5_rxusrclk_i             (gt5_rxusrclk_i             ),
    .gt5_rxdata_i               (gt5_rxdata_i               ),
    .gt5_rxcharisk_i            (gt5_rxcharisk_i            ),
    .gt6_txusrclk_i             (gt6_txusrclk_i             ),
    .gt6_txdata_i               (gt6_txdata_i               ),
    .gt6_txcharisk_i            (gt6_txcharisk_i            ),
    .gt6_rxusrclk_i             (gt6_rxusrclk_i             ),
    .gt6_rxdata_i               (gt6_rxdata_i               ),
    .gt6_rxcharisk_i            (gt6_rxcharisk_i            ),
    .gt7_txusrclk_i             (gt7_txusrclk_i             ),
    .gt7_txdata_i               (gt7_txdata_i               ),
    .gt7_txcharisk_i            (gt7_txcharisk_i            ),
    .gt7_rxusrclk_i             (gt7_rxusrclk_i             ),
    .gt7_rxdata_i               (gt7_rxdata_i               ),
    .gt7_rxcharisk_i            (gt7_rxcharisk_i            ), 
    .DRP_CLK_IN                 (DRP_CLK_IN                 )   
    );

//-----tx iq result data and target data to master 420 and slave 420 ------//
serdes_tran_ctrl u1_serdes_tran_ctrl (
    .I_rst_n            (I_sys_rst_n           ), 
    .I_sys_clk          (W_200mhz_clk          ), 
    .I_M420_result_ena  (W_result_ena          ), 
    .I_M420_i_result_dat(W_result_i_dat        ), 
    .I_M420_q_result_dat(W_result_q_dat        ), 
    .I_angle_info       (W_angle_cfar_info     ), 
    .I_mach_angle_info  (W_mach_angle_cfar     ),
    .I_mode_info        (W_mode_info           ),
    .I_target_ena       (W_m_target_ena        ), 
    .I_target_energy    (W_m_target_energy     ), 
    .I_target_range     (W_m_target_range      ), 
    .I_tx_master_clk    (gt0_txusrclk_i        ), 
    .O_tx1_is_k         (W_tx_user_en0         ),   
    .O_tx1_serdes_dat   (W_tx_user_data0       ),     
    .O_tx2_is_k         (W_tx_user_en1         ), 
    .O_tx2_serdes_dat   (W_tx_user_data1       ), 
    .O_tx3_is_k         (W_tx_user_en2         ), 
    .O_tx3_serdes_dat   (W_tx_user_data2       ), 
    .O_tx4_is_k         (W_tx_user_en3         ), 
    .O_tx4_serdes_dat   (W_tx_user_data3       ) 
    );

serdes_tran_ctrl u2_serdes_tran_ctrl (
    .I_rst_n            (I_sys_rst_n           ), 
    .I_sys_clk          (W_200mhz_clk          ), 
    .I_M420_result_ena  (W_result_ena          ), 
    .I_M420_i_result_dat(W_result_i_dat        ), 
    .I_M420_q_result_dat(W_result_q_dat        ), 
    .I_angle_info       (W_angle_cfar_info     ), 
    .I_mach_angle_info  (W_mach_angle_cfar     ),
    .I_mode_info        (W_mode_info           ),
    .I_target_ena       (W_m_target_ena        ), 
    .I_target_energy    (W_m_target_energy     ), 
    .I_target_range     (W_m_target_range      ), 
    .I_tx_master_clk    (gt4_txusrclk_i        ), 
    .O_tx1_is_k         (W_tx_user_en4         ),   
    .O_tx1_serdes_dat   (W_tx_user_data4       ),     
    .O_tx2_is_k         (W_tx_user_en5         ), 
    .O_tx2_serdes_dat   (W_tx_user_data5       ), 
    .O_tx3_is_k         (W_tx_user_en6         ), 
    .O_tx3_serdes_dat   (W_tx_user_data6       ), 
    .O_tx4_is_k         (W_tx_user_en7         ), 
    .O_tx4_serdes_dat   (W_tx_user_data7       ) 
    );
//-----tx iq result data and target data to master 420 and slave 420 ------//

//----------------------------serdes if----------------------//
serdes_k7_if   u0_serdes_k7_if (
    .I_rst_n        (I_sys_rst_n    ),     
    //----------serdes rx data and k-----------//    
    .I_serdes_rx_clk(gt0_rxusrclk_i ), 
    .I_data_is_k    (gt0_rxcharisk_i), 
    .I_serdes_data  (gt0_rxdata_i   ), 
    //----serdes rx user data and en-----------//
    .O_config_data  (               ),
    .O_config_ena   (               ),    
    .O_user_data    (W_rx_user_data0),
    .O_data_ena     (W_rx_user_en0  ),   
    //----------serdes tx data and k-----------//  
    .I_serdes_tx_clk(gt0_txusrclk_i ),    
    .O_serdes_data  (gt0_txdata_i   ),   
    .O_data_is_k    (gt0_txcharisk_i),         
    //----serdes tx user data and en-----------//
    .I_config_data   (),
    .I_config_en     (),     
    .I_tx_user_data (W_tx_user_data0 ),
    .I_tx_user_en   (W_tx_user_en0   )              
    );

serdes_k7_if   u1_serdes_k7_if (
    .I_rst_n        (I_sys_rst_n    ),    
    //----------serdes rx data and k-----------//    
    .I_serdes_rx_clk(gt1_rxusrclk_i ), 
    .I_data_is_k    (gt1_rxcharisk_i), 
    .I_serdes_data  (gt1_rxdata_i   ), 
    //----serdes rx user data and en-----------// 
    .O_config_data  (               ),
    .O_config_ena   (               ),    
    .O_user_data    (W_rx_user_data1),
    .O_data_ena     (W_rx_user_en1  ),   
    //----------serdes tx data and k-----------//  
    .I_serdes_tx_clk(gt0_txusrclk_i ),    
    .O_serdes_data  (gt1_txdata_i   ),   
    .O_data_is_k    (gt1_txcharisk_i),        
    //----serdes tx user data and en-----------// 
    .I_config_data   (),
    .I_config_en     (),    
    .I_tx_user_data (W_tx_user_data1 ),
    .I_tx_user_en   (W_tx_user_en1   )              
    );

serdes_k7_if   u2_serdes_k7_if (
    .I_rst_n        (I_sys_rst_n    ),    
    //----------serdes rx data and k-----------//    
    .I_serdes_rx_clk(gt2_rxusrclk_i ), 
    .I_data_is_k    (gt2_rxcharisk_i), 
    .I_serdes_data  (gt2_rxdata_i   ), 
    //----serdes rx user data and en-----------//
    .O_config_data  (               ),
    .O_config_ena   (               ),    
    .O_user_data    (W_rx_user_data2),
    .O_data_ena     (W_rx_user_en2  ), 
    //----------serdes tx data and k-----------//  
    .I_serdes_tx_clk(gt0_txusrclk_i ),    
    .O_serdes_data  (gt2_txdata_i   ),   
    .O_data_is_k    (gt2_txcharisk_i),        
    //----serdes tx user data and en-----------//
    .I_config_data   (),
    .I_config_en     (),     
    .I_tx_user_data (W_tx_user_data2 ),
    .I_tx_user_en   (W_tx_user_en2   )              
    );

serdes_k7_if   u3_serdes_k7_if (
    .I_rst_n        (I_sys_rst_n    ),     
    //----------serdes rx data and k-----------//    
    .I_serdes_rx_clk(gt3_rxusrclk_i ), 
    .I_data_is_k    (gt3_rxcharisk_i), 
    .I_serdes_data  (gt3_rxdata_i   ), 
    //----serdes rx user data and en-----------//
    .O_config_data  (               ),
    .O_config_ena   (               ),    
    .O_user_data    (W_rx_user_data3),
    .O_data_ena     (W_rx_user_en3  ),   
    //----------serdes tx data and k-----------//  
    .I_serdes_tx_clk(gt0_txusrclk_i ),    
    .O_serdes_data  (gt3_txdata_i   ),   
    .O_data_is_k    (gt3_txcharisk_i),         
    //----serdes tx user data and en-----------//
    .I_config_data   (),
    .I_config_en     (),     
    .I_tx_user_data (W_tx_user_data3 ),
    .I_tx_user_en   (W_tx_user_en3   )              
    );    

//----------------------------serdes if----------------------//
serdes_k7_if   u4_serdes_k7_if (
    .I_rst_n        (I_sys_rst_n    ),     
    //----------serdes rx data and k-----------//    
    .I_serdes_rx_clk(gt4_rxusrclk_i ), 
    .I_data_is_k    (gt4_rxcharisk_i), 
    .I_serdes_data  (gt4_rxdata_i   ), 
    //----serdes rx user data and en-----------//
    .O_config_data  (W_config_data  ),
    .O_config_ena   (W_config_ena   ),    
    .O_user_data    (W_rx_user_data4),
    .O_data_ena     (W_rx_user_en4  ),   
    //----------serdes tx data and k-----------//  
    .I_serdes_tx_clk(gt4_txusrclk_i ),    
    .O_serdes_data  (gt4_txdata_i   ),   
    .O_data_is_k    (gt4_txcharisk_i),         
    //----serdes tx user data and en-----------// 
    .I_config_data   (),
    .I_config_en     (),    
    .I_tx_user_data (W_tx_user_data4 ),
    .I_tx_user_en   (W_tx_user_en4   )              
    );

serdes_k7_if   u5_serdes_k7_if (
    .I_rst_n        (I_sys_rst_n    ),    
    //----------serdes rx data and k-----------//    
    .I_serdes_rx_clk(gt5_rxusrclk_i ), 
    .I_data_is_k    (gt5_rxcharisk_i), 
    .I_serdes_data  (gt5_rxdata_i   ), 
    //----serdes rx user data and en-----------// 
    .O_config_data  (               ),
    .O_config_ena   (               ),    
    .O_user_data    (W_rx_user_data5),
    .O_data_ena     (W_rx_user_en5  ),   
    //----------serdes tx data and k-----------//  
    .I_serdes_tx_clk(gt4_txusrclk_i ),    
    .O_serdes_data  (gt5_txdata_i   ),   
    .O_data_is_k    (gt5_txcharisk_i),        
    //----serdes tx user data and en-----------// 
    .I_config_data   (),
    .I_config_en     (),    
    .I_tx_user_data (W_tx_user_data5 ),
    .I_tx_user_en   (W_tx_user_en5   )              
    );

serdes_k7_if   u6_serdes_k7_if (
    .I_rst_n        (I_sys_rst_n    ),    
    //----------serdes rx data and k-----------//    
    .I_serdes_rx_clk(gt6_rxusrclk_i ), 
    .I_data_is_k    (gt6_rxcharisk_i), 
    .I_serdes_data  (gt6_rxdata_i   ), 
    //----serdes rx user data and en-----------//
    .O_config_data  (               ),
    .O_config_ena   (               ),    
    .O_user_data    (W_rx_user_data6),
    .O_data_ena     (W_rx_user_en6  ), 
    //----------serdes tx data and k-----------//  
    .I_serdes_tx_clk(gt4_txusrclk_i ),    
    .O_serdes_data  (gt6_txdata_i   ),   
    .O_data_is_k    (gt6_txcharisk_i),        
    //----serdes tx user data and en-----------//
    .I_config_data   (),
    .I_config_en     (),    
    .I_tx_user_data (W_tx_user_data6 ),
    .I_tx_user_en   (W_tx_user_en6   )              
    );

serdes_k7_if   u7_serdes_k7_if (
    .I_rst_n        (I_sys_rst_n    ),     
    //----------serdes rx data and k-----------//    
    .I_serdes_rx_clk(gt7_rxusrclk_i ), 
    .I_data_is_k    (gt7_rxcharisk_i), 
    .I_serdes_data  (gt7_rxdata_i   ), 
    //----serdes rx user data and en-----------//
    .O_config_data  (               ),
    .O_config_ena   (               ),    
    .O_user_data    (W_rx_user_data7),
    .O_data_ena     (W_rx_user_en7  ),   
    //----------serdes tx data and k-----------//  
    .I_serdes_tx_clk(gt4_txusrclk_i ),    
    .O_serdes_data  (gt7_txdata_i   ),   
    .O_data_is_k    (gt7_txcharisk_i),         
    //----serdes tx user data and en-----------//  
    .I_config_data   (),
    .I_config_en     (),   
    .I_tx_user_data (W_tx_user_data7 ),
    .I_tx_user_en   (W_tx_user_en7   )              
    );    
//===================================serdes_if===================================
endmodule
//====END====