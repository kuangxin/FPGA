//----------------------------------------------------NUST-----------------------------------------------------
// ==============================420=================================
// Project Name :   
// File name    :   .v
// Library      :   WORK
// Created On   :   2016-09-01 17:35:02 Thu
// Comments     :   
// ----------------------------------------------------------------------
// >>>>>>>>>>>>>>>>>>>>>>>>> COPYRIGHT NOTICE <<<<<<<<<<<<<<<<<<<<<<<<<<<
// ----------------------------------------------------------------------
// Copyright 2016 (c) NUST
//
// NUST owns the sole copyright to this software. Under 
// international copyright laws you (1) may not make a copy of this software
// except for the purposes of maintaining a single archive copy, (2) may not 
// derive works herefrom, (3) may not distribute this work to others. These 
// rights are provided for information clarification, other restrictions of 
// rights may apply as well.
// ----------------------------------------------------------------------
// >>>>>>>>>>>>>>>>>>>>>>>>>>>>> Warrantee <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
// ----------------------------------------------------------------------
// NUST MAKES NO WARRANTY OF ANY KIND WITH REGARD TO THE USE OF
// THIS SOFTWARE, EITHER EXPRESSED OR IMPLIED, INCLUDING, BUT NOT LIMITED TO,
// THE IMPLIED WARRANTIES OF MERCHANTABILITY OR FITNESS FOR A PARTICULAR
// PURPOSE.
// ----------------------------------------------------------------------
//
// Revision History :
// ----------------------------------------------------------------------
//  Ver :           | Author:   kuangxin    | Mod. Date :    |    
//  Update Detail:                  | 
// ----------------------------------------------------------------------
// OverView
// ========
//
// ----------------------------------------------------------------------
// ======================================================================
`timescale 1ns/100ps
module  top(
    //====system reset====
    I_reset_n           ,
    
    //====system clock====
    I_sys_clk           ,
    
    //====input====
    
    //====output====

    //====UART====
    RX                  ,
    TX                  ,
    );

//------------------------------------------External Signal Definitions------------------------------------------
//====input====
input           I_reset_n           ;
input           I_sys_clk           ;
input           RX                  ;

//====output====                    
output          TX                  ;


//====output register define====

//-----------------------------------------Internal Reg Definitions----------------------------------------------

//====parameter====
parameter       TCO_DELAY       =  1;

//====internal wire define====

wire        div_clk         ;
wire        W_div_clk       ;
wire        clk_sample      ;
wire        W_clk_sample    ;
wire[7:0]   W_rx_dat        ;
wire[7:0]   W_tx_dat        ;
wire        W_tx_ena        ;
wire        W_tail          ;
wire        W_rx_ena        ;

//====internal register define====


//---------------------------------------------Main Body of Code---------------------------------------------------
//=====================read me=====================
//
//  
//  
//  
//
//
//=====================read me=====================

divide_325 u1 (
    .I_rst_n    (I_rst_n   ),
    .clk_50M    (W_65m_clk ), 
    .clk_sample (clk_sample),
    .clk_div    (div_clk )
    );

BUFG BUFG_u1 (
      .O(W_clk_sample), // 1-bit output: Clock output
      .I(clk_sample)  // 1-bit input: Clock input
   );

BUFG BUFG_u2 (
      .O(W_div_clk), // 1-bit output: Clock output
      .I(div_clk)  // 1-bit input: Clock input
   );


uart_tx uart_tx_u(
//====system signal====
//====input====
.I_rst_n         (I_rst_n    ),
.I_div_clk       (W_div_clk  ),
.I_tx_dat        (W_tx_dat   ),
.I_tx_ena        (W_tx_ena   ),

//====output====
.O_tx_dat        (TX         )
);

uart_rx uart_rx_u(
//====system signal====
//====input====
.I_rst_n         (I_rst_n     ),
.I_div_clk       (W_clk_sample),
.I_rx_dat        (RX          ),

//====output====
.O_tail          (W_tail      ),
.O_rx_ena        (W_rx_ena    ),
.O_rx_dat        (W_rx_dat    )       
);


//-------------------------------------output-------------------------------------
endmodule
//====END====