//----------------------------------------------------NUST-----------------------------------------------------
// ==============================NUST=================================
// Project Name :   LOOKUPTABLE    
// File name    :   serdes_if.v
// Library      :   CORE_FPGA
// Created On   :   2012-2-15 15:27
// Comments     :   
// ----------------------------------------------------------------------
// >>>>>>>>>>>>>>>>>>>>>>>>> COPYRIGHT NOTICE <<<<<<<<<<<<<<<<<<<<<<<<<<<
// ----------------------------------------------------------------------
// Copyright 2012 (c) NUST
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
//  Ver :       | Author:   Liht    | Mod. Date :       |    
//  Update Detail:                  | 
// ----------------------------------------------------------------------
// OverView
// ========
//
// ----------------------------------------------------------------------
// ======================================================================
`timescale 1ns/100ps
module  serdes_if(
    //====system signal====
    //====input====
    I_sys_rst_n         ,
    I_serdes_clk        ,
            
    //====serdes ====
    //====input====
    I_serdes_clk1       ,
    I_serdes_rx1_data   ,
    I_serdes_rx1_is_k   ,
    I_serdes_clk2       ,
    I_serdes_rx2_data   ,
    I_serdes_rx2_is_k   ,
    I_serdes_clk3       ,
    I_serdes_rx3_data   ,
    I_serdes_rx3_is_k   ,
    I_serdes_clk4       ,
    I_serdes_rx4_data   ,
    I_serdes_rx4_is_k   ,
    
    //====output====
    O_serdes_tx_data    ,
    O_serdes_tx_is_k    ,
                
    //====to user interface====
    //====input====
    I_user_result       ,
    I_user_result_ena   ,
    
    //====output====
    O_user_rx1_data     ,
    O_user_wr_ena1      ,
    O_user_rx2_data     ,
    O_user_wr_ena2      ,
    O_user_rx3_data     ,
    O_user_wr_ena3      ,
    O_user_rx4_data     ,
    O_user_wr_ena4
    );

//------------------------------------------External Signal Definitions------------------------------------------
//====input====
input           I_sys_rst_n         ;
input           I_serdes_clk        ;
input           I_serdes_clk1       ;
input[7:0]      I_serdes_rx1_data   ;
input           I_serdes_rx1_is_k   ;
input           I_serdes_clk2       ;
input[7:0]      I_serdes_rx2_data   ;
input           I_serdes_rx2_is_k   ;
input           I_serdes_clk3       ;
input[7:0]      I_serdes_rx3_data   ;
input           I_serdes_rx3_is_k   ;
input           I_serdes_clk4       ;
input[7:0]      I_serdes_rx4_data   ;
input           I_serdes_rx4_is_k   ;
input[7:0]      I_user_result       ;
input           I_user_result_ena   ;

//====output====
output[7:0]     O_serdes_tx_data    ;
output          O_serdes_tx_is_k    ;
output[7:0]     O_user_rx1_data     ;
output[7:0]     O_user_rx2_data     ;
output[7:0]     O_user_rx3_data     ;
output[7:0]     O_user_rx4_data     ;
output          O_user_wr_ena1      ;
output          O_user_wr_ena2      ;
output          O_user_wr_ena3      ;
output          O_user_wr_ena4      ;

//----------------------------------------------Reg Definitions---------------------------------------------------
//====parameter====

//====output register define====
reg[7:0]        O_serdes_tx_data    ;
reg             O_serdes_tx_is_k    ;

//====internal register define====
reg[7:0]        R_user_result       ;
reg             R_user_result_ena   ;
reg[7:0]        R1_user_result      ;
reg             R1_user_result_ena  ;
reg[7:0]        R_serdes_tx_data    ;
reg             R_serdes_tx_is_k    ;
reg             R1_serdes_tx_is_k   ;
reg[7:0]        R1_serdes_tx_data   ;
reg             R_idle_c5_ena       ;
reg             R_cycle_ena         ;
wire            W_serdes_rx1_is_k   ;
reg             R_serdes_rx1_is_k   ;
reg             R1_serdes_rx1_is_k  ;
reg             O_user_wr_ena1      ;
reg[7:0]        R_serdes_data1      ;
reg[7:0]        O_user_rx1_data     ;
wire            W_serdes_rx2_is_k   ;
reg             R_serdes_rx2_is_k   ;
reg             R1_serdes_rx2_is_k  ;
reg             O_user_wr_ena2      ;
reg[7:0]        R_serdes_data2      ;
reg[7:0]        O_user_rx2_data     ;
wire            W_serdes_rx3_is_k   ;
reg             R_serdes_rx3_is_k   ;
reg             R1_serdes_rx3_is_k  ;
reg             O_user_wr_ena3      ;
reg[7:0]        R_serdes_data3      ;
reg[7:0]        O_user_rx3_data     ;
wire            W_serdes_rx4_is_k   ;
reg             R_serdes_rx4_is_k   ;
reg             R1_serdes_rx4_is_k  ;
reg             O_user_wr_ena4      ;
reg[7:0]        R_serdes_data4      ;
reg[7:0]        O_user_rx4_data     ;
(* KEEP = "TRUE" *)	
reg[6:0]			 cnt			;

//---------------------------------------------Main Body of Code---------------------------------------------------
//-------------------------------------------------------TX-------------------------------------------------------
//---------------------normal work---------------------
always @ (posedge I_serdes_clk or negedge I_sys_rst_n)
begin
    if(!I_sys_rst_n)
    begin
        R_user_result       <=  8'h00;
        R_user_result_ena   <=  1'b0;
    end
    else
    begin
        R_user_result       <=  I_user_result;
        R_user_result_ena   <=  I_user_result_ena;
    end
end

always @ (posedge I_serdes_clk or negedge I_sys_rst_n)
begin
    if(!I_sys_rst_n)
    begin
        R1_user_result      <=  8'h00;
        R1_user_result_ena  <=  1'b0;
    end
    else
    begin
        R1_user_result      <=  R_user_result;
        R1_user_result_ena  <=  R_user_result_ena;
    end
end

always @ (posedge I_serdes_clk or negedge I_sys_rst_n)
begin
    if(!I_sys_rst_n)
    begin
        R_serdes_tx_data    <=  8'h00;
        R_serdes_tx_is_k    <=  1'b0;
		  cnt				<=	7'd0	;
    end
    else
    begin
        if(R1_user_result_ena)
        begin
            R_serdes_tx_data    <=  R1_user_result;
            R_serdes_tx_is_k    <=  1'b0;
				cnt						<=	cnt +	1'b1	;
        end
        else
        begin
            R_serdes_tx_data    <=  8'hbc;
            R_serdes_tx_is_k    <=  1'b1;
				cnt	<=	1'b0	;
        end
    end
end

always @ (posedge I_serdes_clk or negedge I_sys_rst_n)
begin
    if(!I_sys_rst_n)
    begin
        R1_serdes_tx_is_k   <=  1'b0;
        R1_serdes_tx_data   <=  8'h00;
    end
    else
    begin
        R1_serdes_tx_is_k   <=  R_serdes_tx_is_k;
        R1_serdes_tx_data   <=  R_serdes_tx_data;
    end
end

always @ (posedge I_serdes_clk or negedge I_sys_rst_n)
begin
    if(!I_sys_rst_n)
    begin
        R_idle_c5_ena   <=  1'b0;
	 end
    else
    begin
        if(R_serdes_tx_is_k)
        begin
            if(R_cycle_ena)
            begin
                R_idle_c5_ena   <=  1'b0;
            end
            else
            begin
                R_idle_c5_ena   <=  ~R_idle_c5_ena;
            end
        end
        else
        begin
            R_idle_c5_ena   <=  1'b0;
        end
    end
end

always @ (posedge I_serdes_clk or negedge I_sys_rst_n)
begin
    if(!I_sys_rst_n)
    begin
        O_serdes_tx_data    <=  8'h00;
        O_serdes_tx_is_k    <=  1'b0;
        R_cycle_ena         <=  1'b0;
    end
    else
    begin
        casez({R_idle_c5_ena,R1_serdes_tx_is_k,R_serdes_tx_is_k,R_cycle_ena})
        4'b01??:
        begin
            O_serdes_tx_data    <=  8'hc5;
            O_serdes_tx_is_k    <=  1'b0;
            R_cycle_ena         <=  1'b0;
        end
        4'b111?:
        begin
            O_serdes_tx_data    <=  8'hbc;
            O_serdes_tx_is_k    <=  1'b1;
            R_cycle_ena         <=  1'b0;
        end
        4'b00?0:
        begin                                       
            O_serdes_tx_data    <=  R1_serdes_tx_data;
            O_serdes_tx_is_k    <=  1'b0;
            R_cycle_ena         <=  1'b0;
        end
        4'b1100:
        begin                                       
            O_serdes_tx_data    <=  R_serdes_tx_data;
            O_serdes_tx_is_k    <=  1'b0;
            R_cycle_ena         <=  1'b1;
        end
        4'b0001:
        begin                                       
            O_serdes_tx_data    <=  R_serdes_tx_data;
            O_serdes_tx_is_k    <=  1'b0;
            R_cycle_ena         <=  1'b1;
        end
        4'b0011:
        begin
            O_serdes_tx_data    <=  8'hbc;
            O_serdes_tx_is_k    <=  1'b1;
            R_cycle_ena         <=  1'b0;
        end
        endcase
    end
end
//-------------------------------------------------------TX-------------------------------------------------------


//-------------------------------------------------------RX-------------------------------------------------------
//-----------------------------------serdes1-----------------------------------

assign  W_serdes_rx1_is_k    =   (I_serdes_rx1_is_k && (I_serdes_rx1_data == 8'hbc));

always @ (posedge I_serdes_clk1 or negedge I_sys_rst_n)
begin
    if(!I_sys_rst_n)
    begin
        R_serdes_rx1_is_k    <=  1'b0;
    end
    else
    begin
        R_serdes_rx1_is_k    <=  W_serdes_rx1_is_k;
    end
end

always @ (posedge I_serdes_clk1 or negedge I_sys_rst_n)
begin
    if(!I_sys_rst_n)
    begin
        R1_serdes_rx1_is_k   <=  1'b0;
    end
    else
    begin
        R1_serdes_rx1_is_k   <=  R_serdes_rx1_is_k;
    end
end

always @ (posedge I_serdes_clk1 or negedge I_sys_rst_n)
begin
    if(!I_sys_rst_n)
    begin
        O_user_wr_ena1   <=  1'b0;
    end
    else
    begin
        O_user_wr_ena1   <=  ~(R_serdes_rx1_is_k || R1_serdes_rx1_is_k);
    end
end

always @ (posedge I_serdes_clk1 or negedge I_sys_rst_n)
begin
    if(!I_sys_rst_n)
    begin
        R_serdes_data1   <=  8'h00;
    end
    else
    begin
        R_serdes_data1   <=  I_serdes_rx1_data;
	 end
end

always @ (posedge I_serdes_clk1 or negedge I_sys_rst_n)
begin
    if(!I_sys_rst_n)
    begin
        O_user_rx1_data   <=  8'h00;
    end
    else
    begin
       O_user_rx1_data    <=  R_serdes_data1;
	 end
end
//-----------------------------------serdes1-----------------------------------


//-----------------------------------serdes2-----------------------------------

assign  W_serdes_rx2_is_k    =   (I_serdes_rx2_is_k && (I_serdes_rx2_data == 8'hbc));

always @ (posedge I_serdes_clk2 or negedge I_sys_rst_n)
begin
    if(!I_sys_rst_n)
    begin
        R_serdes_rx2_is_k    <=  1'b0;
    end
    else
    begin
        R_serdes_rx2_is_k    <=  W_serdes_rx2_is_k;
    end
end

always @ (posedge I_serdes_clk2 or negedge I_sys_rst_n)
begin
    if(!I_sys_rst_n)
    begin
        R1_serdes_rx2_is_k   <=  1'b0;
    end
    else
    begin
        R1_serdes_rx2_is_k   <=  R_serdes_rx2_is_k;
    end
end

always @ (posedge I_serdes_clk2 or negedge I_sys_rst_n)
begin
    if(!I_sys_rst_n)
    begin
        O_user_wr_ena2   <=  1'b0;
    end
    else
    begin
        O_user_wr_ena2   <=  ~(R_serdes_rx2_is_k || R1_serdes_rx2_is_k);
    end
end

always @ (posedge I_serdes_clk2 or negedge I_sys_rst_n)
begin
    if(!I_sys_rst_n)
    begin
        R_serdes_data2   <=  8'h00;
    end
    else
    begin
        R_serdes_data2   <=  I_serdes_rx2_data;
    end
end

always @ (posedge I_serdes_clk2 or negedge I_sys_rst_n)
begin
    if(!I_sys_rst_n)
    begin
        O_user_rx2_data   <=  8'h00;
    end
    else
    begin
        O_user_rx2_data   <=  R_serdes_data2;
	 end
end
//-----------------------------------serdes2-----------------------------------


//-----------------------------------serdes3-----------------------------------

assign  W_serdes_rx3_is_k    =   (I_serdes_rx3_is_k && (I_serdes_rx3_data == 8'hbc));

always @ (posedge I_serdes_clk3 or negedge I_sys_rst_n)
begin
    if(!I_sys_rst_n)
    begin
        R_serdes_rx3_is_k    <=  1'b0;
    end
    else
    begin
        R_serdes_rx3_is_k    <=  W_serdes_rx3_is_k;
    end
end

always @ (posedge I_serdes_clk3 or negedge I_sys_rst_n)
begin
    if(!I_sys_rst_n)
    begin
        R1_serdes_rx3_is_k   <=  1'b0;
    end
    else
    begin
        R1_serdes_rx3_is_k   <=  R_serdes_rx3_is_k;
    end
end

always @ (posedge I_serdes_clk3 or negedge I_sys_rst_n)
begin
    if(!I_sys_rst_n)
    begin
        O_user_wr_ena3   <=  1'b0;
    end
    else
    begin
        O_user_wr_ena3   <=  ~(R_serdes_rx3_is_k || R1_serdes_rx3_is_k);
    end
end
always @ (posedge I_serdes_clk3 or negedge I_sys_rst_n)
begin
    if(!I_sys_rst_n)
    begin
        R_serdes_data3   <=  8'h00;
    end
    else
    begin
        R_serdes_data3   <=  I_serdes_rx3_data;
    end
end

always @ (posedge I_serdes_clk3 or negedge I_sys_rst_n)
begin
    if(!I_sys_rst_n)
    begin
        O_user_rx3_data   <=  8'h00;
    end
    else
    begin
        O_user_rx3_data   <=  R_serdes_data3;
    end
end
//-----------------------------------serdes3-----------------------------------


//-----------------------------------serdes4-----------------------------------
assign  W_serdes_rx4_is_k    =   (I_serdes_rx4_is_k && (I_serdes_rx4_data == 8'hbc));

always @ (posedge I_serdes_clk4 or negedge I_sys_rst_n)
begin
    if(!I_sys_rst_n)
    begin
        R_serdes_rx4_is_k    <=  1'b0;
    end
    else
    begin
        R_serdes_rx4_is_k    <=  W_serdes_rx4_is_k;
    end
end

always @ (posedge I_serdes_clk4 or negedge I_sys_rst_n)
begin
    if(!I_sys_rst_n)
    begin
        R1_serdes_rx4_is_k   <=  1'b0;
    end
    else
    begin
        R1_serdes_rx4_is_k   <=  R_serdes_rx4_is_k;
    end
end

always @ (posedge I_serdes_clk4 or negedge I_sys_rst_n)
begin
    if(!I_sys_rst_n)
    begin
        O_user_wr_ena4   <=  1'b0;
    end
    else
    begin
        O_user_wr_ena4   <=  ~(R_serdes_rx4_is_k || R1_serdes_rx4_is_k);
    end
end

always @ (posedge I_serdes_clk4 or negedge I_sys_rst_n)
begin
    if(!I_sys_rst_n)
    begin
        R_serdes_data4   <=  8'h00;
    end
    else
    begin
        R_serdes_data4   <=  I_serdes_rx4_data;
    end
end

always @ (posedge I_serdes_clk4 or negedge I_sys_rst_n)
begin
    if(!I_sys_rst_n)
    begin
        O_user_rx4_data   <=  8'h00;
    end
    else
    begin
        O_user_rx4_data   <=  R_serdes_data4;
    end
end
//-----------------------------------serdes4-----------------------------------
//-------------------------------------------------------RX-------------------------------------------------------
endmodule
//====END====
