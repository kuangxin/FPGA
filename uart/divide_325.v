//----------------------------------------------------NUST-----------------------------------------------  
// ==============================NUST=================================
// Project Name :   sample    
// File name    :   divide_325.v
// Library      :   WORK
// Created On   :   2014/8/12 15:55
// Comments     :   
// ----------------------------------------------------------------------
// >>>>>>>>>>>>>>>>>>>>>>>>> COPYRIGHT NOTICE <<<<<<<<<<<<<<<<<<<<<<<<<<<
// ----------------------------------------------------------------------
// Copyright 2014 (c) NUST
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
module  divide_325( 
    I_rst_n     ,
    clk_50M     ,
    clk_sample  ,
    clk_div 
    );

//====input====
input	clk_50M ;//65m
input   I_rst_n ;

//====output====
output  clk_sample  ;
output	clk_div ;

//-----------External Signal Definitions-------------------

reg     clk_div ;
reg     clk_sample  ;
//-----------internal Signal Definitions-------------------
//-------------------------bps 9600-------------------------
//                                                            
//  50MHz == 20ns                                             
//  bps: 9600 ->                            
//   => 2604                                           
//                                                                
//      3385                                                          
//-------------------------bps 115200-------------------------  

//-------------------------bps 115200-------------------------
//                                                            
//  50MHz == 20ns                                             
//  bps: 115200 -> 8680ns -> 4340ns                           
//  4340ns/20 = 217                                           
//                                                                
//                                                                
//-------------------------bps 115200-------------------------
  
reg[11:0]  count;
reg[7:0]  R_cnt_num;
    
initial
begin
	count   = 12'b0;
	clk_div = 1'b0;
end
//-----------------------Main Body of Code------------------
always@( posedge clk_50M or negedge I_rst_n) 
begin  
    if(~I_rst_n)
    begin
        count   <= 12'b0;
    end
    else
    begin
        if(count == 12'd3385) //217
        begin  
            count   <= 12'b0;
            clk_div <= ~clk_div;
        end 
        else
        begin
            count   <= count + 12'd1;
            clk_div <= clk_div;
        end
    end
end

always@( posedge clk_50M or negedge I_rst_n) 
begin  
    if(~I_rst_n)
    begin
        R_cnt_num   <= 8'd0;
    end
    else
    begin
        if(R_cnt_num == 8'd211)//14
        begin  
            R_cnt_num   <= 8'd0;
            clk_sample <= ~clk_sample;
        end 
        else
        begin
            R_cnt_num   <= R_cnt_num + 8'd1;
            clk_sample <= clk_sample;
        end
    end
end
endmodule
//====END====