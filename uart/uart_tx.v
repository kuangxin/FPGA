//----------------------------------------------------NUST-----------------------------------------------  
// ==============================NUST=================================
// Project Name :   uart_tx   
// File name    :   uart_tx.v
// Library      :   WORK
// Created On   :   2013/8/17 11:27
// Comments     :   
// ----------------------------------------------------------------------
// >>>>>>>>>>>>>>>>>>>>>>>>> COPYRIGHT NOTICE <<<<<<<<<<<<<<<<<<<<<<<<<<<
// ----------------------------------------------------------------------
// Copyright 2009 (c) NUST
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
//  Ver :       | Author:   ZHJW  | Mod. Date :       |    
//  Update Detail:                  | 
// ----------------------------------------------------------------------
// OverView
// ========
//
// ----------------------------------------------------------------------
// ======================================================================
`timescale 1ns/100ps
module  uart_tx(
    //====system signal====
    //====input====
    I_rst_n         ,
    I_div_clk       ,
    I_tx_dat        ,
    I_tx_ena        ,
    
    //====output====
    O_tx_dat       
    );

//------------------------------------------External Signal Definitions------------------------------------------
//====input====
input           I_rst_n         ;
input           I_div_clk       ;
input           I_tx_ena        ;
input[7:0]      I_tx_dat        ;

//====output====
output          O_tx_dat        ;

//----------------------------------------------Reg Definitions---------------------------------------------------

//====output register define====
reg             O_tx_dat        ;

//====internal register define====
reg[3:0]        R_cnt_num       ;
reg             R1_tx_ena       ;
reg             R2_tx_ena       ;
reg             R3_tx_ena       ;

//---------------------------------------------Main Body of Code---------------------------------------------------
initial
begin
    R_cnt_num   =0;
    O_tx_dat    =0;    
end

always @ (posedge I_div_clk or negedge I_rst_n)
begin
    if(~I_rst_n)
    begin
        R1_tx_ena   <=  1'b0;
        R2_tx_ena   <=  1'b0;
        R3_tx_ena   <=  1'b0;
    end
    else
    begin
        R1_tx_ena   <=  I_tx_ena;
        R2_tx_ena   <=  R1_tx_ena;
        R3_tx_ena   <=  R2_tx_ena;
    end
end

always @ (posedge I_div_clk or negedge I_rst_n)
begin
    if(~I_rst_n)
    begin
        R_cnt_num   <=  4'hf;
    end
    else
    begin
        if((R3_tx_ena && (~R2_tx_ena)))
        begin
            R_cnt_num   <=  4'h00;
        end
        else if(~(&R_cnt_num ))
        begin
            R_cnt_num   <=  R_cnt_num + 4'h01;
        end
    end
end

always @ (posedge I_div_clk or negedge I_rst_n)
begin
    if(~I_rst_n)
    begin
        O_tx_dat <=  1'b1;
    end
    else
    begin
        case(R_cnt_num)
        4'h0:   O_tx_dat <=  1'b0;
        4'h1:   O_tx_dat <=  I_tx_dat[0];
        4'h2:   O_tx_dat <=  I_tx_dat[1];
        4'h3:   O_tx_dat <=  I_tx_dat[2];
        4'h4:   O_tx_dat <=  I_tx_dat[3];
        4'h5:   O_tx_dat <=  I_tx_dat[4];
        4'h6:   O_tx_dat <=  I_tx_dat[5];
        4'h7:   O_tx_dat <=  I_tx_dat[6];
        4'h8:   O_tx_dat <=  I_tx_dat[7];
        4'h9:   O_tx_dat <=  1'b1;
        default:O_tx_dat <=  1'b1;
        endcase
    end
end
endmodule
//====END====