//----------------------------------------------------NUST-----------------------------------------------  
// ==============================NUST=================================
// Project Name :   uart_rx   
// File name    :   uart_rx.v
// Library      :   WORK
// Created On   :   2014/8/13 8:58
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
module  uart_rx(
    //====system signal====
    //====input====
    I_rst_n         ,
    I_div_clk       ,
    I_rx_dat        ,
    
    //====output====
    O_tail          ,
    O_rx_ena        ,
    O_rx_dat       
    );

//------------------------------------------External Signal Definitions------------------------------------------
//====input====
input           I_div_clk       ;
input           I_rx_dat        ;
input           I_rst_n         ;

//====output====
output          O_tail          ;       
output          O_rx_ena        ;
output[7:0]     O_rx_dat        ;

//----------------------------------------------Reg Definitions---------------------------------------------------

//====output register define====
reg             O_tail          ;
reg             O_rx_ena        ;
reg[7:0]        O_rx_dat        ;

//====internal register define====
reg             R1_rx_dat       ;
reg             R2_rx_dat       ;
reg             R3_rx_dat       ;
reg[7:0]        R_cnt_num       ;
reg             R_cnt_ena       ;
reg[7:0]        R_count_tail    ;
//---------------------------------------------Main Body of Code---------------------------------------------------
initial
begin
    R1_rx_dat   =0;
    R2_rx_dat   =0;
    R3_rx_dat   =0;
    R_cnt_num   =0;
    R_cnt_ena   =0;
    O_rx_ena    =0;    
    O_rx_dat    =0;    
    O_tail      =0;
end

always @ (posedge I_div_clk or negedge I_rst_n)
begin
    if(~I_rst_n)
    begin
        R1_rx_dat   <=  1'b1;
        R2_rx_dat   <=  1'b1;
        R3_rx_dat   <=  1'b1;
    end
    else
    begin
        R1_rx_dat   <=  I_rx_dat;
        R2_rx_dat   <=  R1_rx_dat;
        R3_rx_dat   <=  R2_rx_dat;
    end
end

always @ (posedge I_div_clk or negedge I_rst_n)
begin
    if(~I_rst_n)
    begin
        R_cnt_num   <=  8'h00;
    end
    else
    begin
        if((R3_rx_dat && (~R2_rx_dat)) && R_cnt_ena)
        begin
            R_cnt_num   <=  8'h00;
        end
        else if(~(&R_cnt_num ))
        begin
            R_cnt_num   <=  R_cnt_num + 8'h01;
        end
    end
end


always @ (posedge I_div_clk or negedge I_rst_n)
begin
    if(~I_rst_n)
    begin
        R_cnt_ena   <=  1'b0;
    end
    else 
    begin
        if (R_cnt_num == 8'd160) 
        begin
            R_cnt_ena   <=  1'b1;
        end
        else if(R_cnt_num ==8'd0)
        begin
            R_cnt_ena   <=  1'b0;
        end
    end
end

always @ (posedge I_div_clk or negedge I_rst_n)
begin
    if(~I_rst_n)
    begin
        O_rx_dat   <=  8'h00;
    end
    else
    begin
        case(R_cnt_num)
        8'd24:  O_rx_dat[0] <=  R1_rx_dat;//16+8
        8'd40:  O_rx_dat[1] <=  R1_rx_dat;//...+16
        8'd56:  O_rx_dat[2] <=  R1_rx_dat;
        8'd72:  O_rx_dat[3] <=  R1_rx_dat;
        8'd88:  O_rx_dat[4] <=  R1_rx_dat;
        8'd104: O_rx_dat[5] <=  R1_rx_dat;
        8'd120: O_rx_dat[6] <=  R1_rx_dat;
        8'd136: O_rx_dat[7] <=  R1_rx_dat;
        default:;
        endcase
    end
end

always @ (posedge I_div_clk or negedge I_rst_n)
begin
    if(~I_rst_n)
    begin
        O_rx_ena   <=  1'h0;
    end
    else
    begin
        O_rx_ena    <=  (R_cnt_num == 8'd140);
    end
end
//over count 128, and don't receive new data, we think receive finished
always @(posedge I_div_clk or negedge I_rst_n) 
begin
    if (~I_rst_n) 
    begin
        R_count_tail <= 8'd0;
    end
    else
    begin
        if (R_cnt_ena) 
        begin
            R_count_tail <= R_count_tail + 1'b1;
        end
        else
        begin
            R_count_tail <= 8'd0;
        end
    end
end
always @ (posedge I_div_clk or negedge I_rst_n)
begin
    if(~I_rst_n)
    begin
        O_tail <=  1'd0;
    end
    else
    begin
        O_tail <=  (R_count_tail == 8'd128);
    end
end

endmodule
//====END====