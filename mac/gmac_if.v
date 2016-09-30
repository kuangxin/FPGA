//----------------------------------------------------NUST-----------------------------------------------------
// ==============================420=================================
// Project Name	:	DBF
// File name    : 	gmac_if.v
// Library      : 	WORK
// Created On   :	2010-9-15 11:48
// Comments     : 	
// ----------------------------------------------------------------------
// >>>>>>>>>>>>>>>>>>>>>>>>> COPYRIGHT NOTICE <<<<<<<<<<<<<<<<<<<<<<<<<<<
// ----------------------------------------------------------------------
// Copyright 2010 (c) NUST
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
//  Ver :   		| Author:	Liht    | Mod. Date :	 |    
//  Update Detail:  				| 
// ----------------------------------------------------------------------
// OverView
// ========
//
// ----------------------------------------------------------------------
// ======================================================================
`timescale 1ns/100ps
module  gmac_if # (
    parameter MASTER_OR_SLAVE   =   1'b0
    )
    (
    //====system reset====
    I_reset_n               ,
    
    //====system clock====
    I_sys_clk               ,
    
    //====GMAC signal====
    //====Receiver Interface====
    I_rx_mac_aclk           ,
    I_rx_reset              ,
    I_rx_axis_mac_tdata     ,
    I_rx_axis_mac_tvalid    ,
    I_rx_axis_mac_tlast     ,
    I_rx_axis_mac_tuser     ,

    //====Transmitter Interface====
    I_tx_mac_aclk           ,
    I_tx_reset              ,
    O_tx_axis_mac_tdata     ,
    I_tx_axis_mac_tvalid    ,
    O_tx_axis_mac_tlast     ,
    O_tx_axis_mac_tuser     ,
    O_tx_axis_mac_tready    ,
    
    //====ctrl signal====
    //====input====
    I_answer_rx_ena         ,
    I_answer_rx_dat         ,
    
    //====output====
    O_config_ena            ,
    O_config_dat            ,
    O_cof_data              ,
    O_cfar_cof              ,
    
    //====SLAVE data====
    //====input====
    //====from board one====
    I_p1_data_ena           ,
    I_p1_rx_data            ,
    
    //====from board one====
    I_p2_data_ena           ,
    I_p2_rx_data            ,
    
    //====from FPGA1====
    I_target_end            ,
    I_target_ena            ,
    I_target_energy         ,
    I_target_range          ,
    
    //====cfar input====
    I_cfar_ena              ,
    I_cfar_range            ,
    I_cfar_energy           ,
    I_cfar_speed
    );

//------------------------------------------External Signal Definitions------------------------------------------
//====input====
input           I_reset_n               ;
input           I_sys_clk               ;
input           I_rx_mac_aclk           ;
input           I_rx_reset              ;
input[7:0]      I_rx_axis_mac_tdata     ;
input           I_tx_axis_mac_tvalid    ; 
input           I_target_end            ; 
input           I_target_ena            ; 
input[23:0]     I_target_energy         ; 
input[12:0]     I_target_range          ; 
input           I_cfar_ena              ; 
input[13:0]     I_cfar_range            ; 
input[15:0]     I_cfar_energy           ; 
input[5:0]      I_cfar_speed            ; 
input           I_answer_rx_ena         ;
input           I_answer_rx_dat         ;
input           I_p1_data_ena           ;
input[15:0]     I_p1_rx_data            ;
input           I_p2_data_ena           ;
input[15:0]     I_p2_rx_data            ;
input           I_rx_axis_mac_tvalid    ;
input           I_rx_axis_mac_tlast     ;
input           I_rx_axis_mac_tuser     ;
input           I_tx_mac_aclk           ;
input           I_tx_reset              ;  

//====output====
output[7:0]     O_tx_axis_mac_tdata     ;
output          O_tx_axis_mac_tlast     ;
output          O_tx_axis_mac_tuser     ;
output          O_tx_axis_mac_tready    ;
output          O_config_ena            ;
output[15:0]    O_config_dat            ;
output[15:0]    O_cof_data              ;
output[15:0]    O_cfar_cof              ;

//-----------------------------------------Internal Reg Definitions----------------------------------------------
//====output register define====
wire[7:0]       O_tx_axis_mac_tdata     ;
reg             O_tx_axis_mac_tlast     ;
wire            O_tx_axis_mac_tuser     ;
reg             O_tx_axis_mac_tready    ;
(*KEEP= "TRUE"*)
reg             O_config_ena            ;
(*KEEP= "TRUE"*)
reg[15:0]        O_config_dat            ;
reg[15:0]       O_cof_data              ;
reg[15:0]       O_cfar_cof              ;

//====parameter====
parameter   TCO_DELAY               =   1;
parameter   MAC_DA_DEFINE           =   48'hffff_ffff_ffff;                 //broad cast destation address
parameter   MAC_SA_DEFINE           =   48'h5a5a_0008_0606;                 //transmit source address
parameter   MAC_DASA_CDATA_DEFINE   =   96'hffff_ffff_ffff_5a5a_0002_0606;  //MAC receive channel data packet
parameter   MAC_TX_LENGTH           =   11'd1320;
parameter   PACKET_LENGTH           =   MAC_TX_LENGTH + 11'd13;
parameter   PACKET_TYPE             =   16'h0536;                           //Packet Type : Packet length

//====internal register define====
reg[7:0]    R2_mac_data             ;
reg[7:0]    R1_mac_data             ;
reg[7:0]    R_mac_data              ;
reg         R_data_wr_ena           ;
reg         R1_data_wr_ena          ;
reg         R_data_fifo_rd          ;
reg         R1_data_fifo_rd         ;
wire[15:0]   W_Channel_data          ;
reg[95:0]   R_mac_da_sa_data        ;
(*KEEP = "TRUE"*)
reg         R_mac_cdata_ena         ;
(*KEEP = "TRUE"*)
reg[15:0]   R_mac_rx_valid          ;
(*KEEP = "TRUE"*)
reg[7:0]    R_serdes_data_num       ;
reg         R1_mac_cdata_ena        ;
reg         R_prog_full             ;
reg         R1_prog_full            ;
reg         R_wr_ena                ;
reg         R_rd_fifo               ;
wire[7:0]   W_fifo_dout             ;
wire        W1_fifo_empty           ;
wire        W1_prog_full            ;
wire        W1_prog_empty           ;
reg         R_wr_end                ;
reg         R1_wr_end               ;
wire[7:0]   W_mac_da_firstbyte      ;  
wire[7:0]   W_mac_da_secondbyte     ;  
wire[7:0]   W_mac_da_thirdbyte      ;  
wire[7:0]   W_mac_da_forthbyte      ;  
wire[7:0]   W_mac_da_fifthbyte      ;  
wire[7:0]   W_mac_da_sixthbyte      ;  
wire[7:0]   W_mac_sa_firstbyte      ;  
wire[7:0]   W_mac_sa_secondbyte     ;  
wire[7:0]   W_mac_sa_thirdbyte      ;  
wire[7:0]   W_mac_sa_forthbyte      ;  
wire[7:0]   W_mac_sa_fifthbyte      ;  
wire[7:0]   W_mac_sa_sixthbyte      ;  
wire[7:0]   W_mac_length_firstbyte  ;
wire[7:0]   W_mac_length_secondbyte ;
wire[47:0]  W_mac_da_define         ;
wire[47:0]  W_mac_sa_define         ;
wire[15:0]  W_mac_length_define     ;
reg         R_gmac_work_ena         ;

//====answer data====
reg         R_answer_rx_ena         ;
reg         R1_answer_rx_ena        ;
reg         R_answer_rx_dat         ;
reg[63:0]   R_answer_dat            ;
reg[63:0]   R_reg_dat               ;
reg[15:0]   R_machine_dat           ;
reg[15:0]   R_array_data            ;
reg         R_selfchecking_ok       ;
reg         R_array_ack             ;
reg         R_clck_ld               ;
reg         R_model_selfcheking     ;
reg         R_ctrl_data_ok          ;

//====machine data====
reg[15:0]   R_machine_angle         ;
reg[15:0]   R_time_cnt              ;
reg         R_add_ena               ;

//====CFAR data====
reg             R_cfar_ena          ;
reg[13:0]       R_cfar_range        ;
reg[15:0]       R_cfar_energy       ;
reg[5:0]        R_cfar_speed        ;
reg             R_rd_fifo2_ena      ;
wire[31:0]      W_fifo2_out_dat     ;
wire[31:0]      W_fifo3_out_dat     ;
wire            W_fifo2_empty       ;

//====FPGA 1 data====
reg             R_target_ena        ;
reg[31:0]       R_target_data       ;
reg             R_rd_fifo1_ena      ;
wire[31:0]      W_fifo1_out_dat     ;
wire            W_fifo1_empty       ;

//====array angle====
reg[15:0]       R_array_angle       ;
reg[7:0]        R_data_fifoin       ;
reg             R_fifo2_wr_ena      ;
reg[10:0]       R_cnt_packet_num    ;
wire[7:0]       W_fifo2_dout        ;
wire            W2_prog_full        ;
wire            W2_fifo_empty       ;
reg[7:0]        R_target_num        ;
reg[7:0]        R1_target_num       ;
reg[7:0]        R_fifo1_data        ;
reg             R_fifo1_wr_ena      ;
reg[3:0]        R_cnt_rd_num        ;
reg             R_fifo_choose       ;

//---------------------------------------------Main Body of Code---------------------------------------------------
//----------------------------------------------------GMAC receive data----------------------------------------------------
always @ (posedge I_rx_mac_aclk or negedge I_reset_n)
begin
    if(~I_reset_n)
    begin
        R_mac_da_sa_data    <=  96'h0;
    end
    else
    begin
        if(I_rx_axis_mac_tvalid)
        begin
            R_mac_da_sa_data    <=  {R_mac_da_sa_data[87:0],I_rx_axis_mac_tdata};
        end
    end
end

always @ (posedge I_rx_mac_aclk or negedge I_reset_n)
begin
    if(~I_reset_n)
    begin
        R_mac_cdata_ena <=  1'b0;
    end
    else
    begin
        if(R_mac_da_sa_data == MAC_DASA_CDATA_DEFINE)
        begin
            R_mac_cdata_ena <=  1'b1;
        end
        else if((~I_rx_axis_mac_tvalid)&&(~I_rx_axis_mac_tlast))
        begin
            R_mac_cdata_ena <=  1'b0;
        end
    end
end

always @ (posedge I_rx_mac_aclk or negedge I_reset_n)
begin
    if(~I_reset_n)
    begin
        R1_mac_cdata_ena <=  1'b0;
    end
    else
    begin
        R1_mac_cdata_ena <=  R_mac_cdata_ena;
    end
end

always @ (posedge I_rx_mac_aclk or negedge I_reset_n)
begin
    if(~I_reset_n)
    begin
        R_data_wr_ena   <=  1'h0;
        R1_data_wr_ena  <=  1'h0;
    end
    else
    begin
        R_data_wr_ena   <=  I_rx_axis_mac_tvalid && R1_mac_cdata_ena;
        R1_data_wr_ena  <=  R_data_wr_ena;
    end
end

always @ (posedge I_rx_mac_aclk or negedge I_reset_n)
begin
    if(~I_reset_n)
    begin
        R1_mac_data <=  8'h00;
        R_mac_data  <=  8'h00;
    end
    else
    begin
        R1_mac_data <=  I_rx_axis_mac_tdata;
        R_mac_data  <=  R1_mac_data;
    end
end

channel_data_fifo   channel_data_fifo_u(
    .rst         (~I_reset_n   ),
    .wr_clk      (I_rx_mac_aclk  ),
    .rd_clk      (I_sys_clk      ),
    .din         (R1_mac_data    ),
    .wr_en       (R_data_wr_ena ),
    .rd_en       (R_data_fifo_rd ),
    .dout        (W_Channel_data ),
    .full        (),             
    .empty       ()
    );

always @ (posedge I_sys_clk or negedge I_reset_n)
begin
    if(~I_reset_n)
    begin
        R_prog_full     <=  1'b0;
        R1_prog_full    <=  1'b0;
    end
    else
    begin
        R_prog_full     <=  R1_data_wr_ena;    //output depends on the tlast signal
        R1_prog_full    <=  R_prog_full;
    end
end

always @ (posedge I_sys_clk or negedge I_reset_n)
begin
    if(~I_reset_n)
    begin
        R_data_fifo_rd      <=  1'b0;
        R_serdes_data_num   <=  8'd89;
    end
    else
    begin
        if((~R_prog_full) && (R1_prog_full))
        begin
            R_data_fifo_rd      <=  1'b1;
            R_serdes_data_num   <=  8'd0;
        end
        else
        begin
            if(R_serdes_data_num == 8'd89)
            begin
                R_data_fifo_rd      <=  1'b0;
                R_serdes_data_num   <=  8'd89;
            end
            else
            begin
                R_data_fifo_rd      <=  1'b1;
                R_serdes_data_num   <=  R_serdes_data_num + 8'd1;
            end
        end
    end
end

always @ (posedge I_sys_clk or negedge I_reset_n)
begin
    if(~I_reset_n)
    begin
        R1_data_fifo_rd     <=  1'b0;
    end
    else
    begin
        R1_data_fifo_rd     <=  R_data_fifo_rd;
    end
end

//------------------------------------------output------------------------------------------------
//------------------------------------------readme------------------------------------------------
//                     _____________________________________________________
//  O_config_ena   ___/                                                     \_________________
//                     _   _   _   _   _   _   _                        _   _   
//  O_config_dat   ___/ \_/ \_/ \_/ \_/ \_/ \_/   .......                \_/ \_____________
//                             
//                     0   1   2   3                                       79
//
//
//              0: 5A  head
//              1: angle 1   -30    bit7:4  count   bit3:0 work mode 
//              2: angle 2   -27.1  bit7:4  count   bit3:0 work mode
//                                    .
//                                    .
//                                    .
//              29:angle 29   60     bit7:4  count   bit3:0 work mode
//              30:rx_gain_ctrl1     bit7:6    01    bit5:0 gain ctrl
//              31:rx_gain_ctrl2     bit7:6    10    bit5:0 gain ctrl
//              32: selfcheking      bit7  O_tx_selfcheking  bit 6:5  O_fm_ctrl
//              33: command
//              34: O_work_ena
//              35~47: Preserved
//              48: 69 head
//              49~55: commmand
//              56~63: Preserved
//              64: 96 head
//              65~71: commmand
//              72~79: Preserved
//
//------------------------------------------readme-------------------------------------------------
always @ (posedge I_sys_clk or negedge I_reset_n)
begin
    if(~I_reset_n)
    begin
        O_config_dat    <=  16'h00;
        O_config_ena    <=  1'b0;
    end
    else
    begin
        if(R1_data_fifo_rd)
        begin
            O_config_dat    <=  W_Channel_data;
            O_config_ena    <=  1'b1;
        end
        else
        begin
            O_config_dat    <=  16'h00;
            O_config_ena    <=  1'b0;
        end
    end
end

always @ (posedge I_sys_clk or negedge I_reset_n)
begin
    if(~I_reset_n)
    begin
        O_cof_data  <=  16'h00;
    end
    else
    begin
        case(R_serdes_data_num)
        7'd81:  O_cof_data[15:8]    <=  W_Channel_data[7:0];
        7'd82:  O_cof_data[7:0]     <=  W_Channel_data[7:0];
        default:;
        endcase
    end
end

always @ (posedge I_sys_clk or negedge I_reset_n)
begin
    if(~I_reset_n)
    begin
        O_cfar_cof  <=  16'h00;
    end
    else
    begin
        case(R_serdes_data_num)
        7'd83:  O_cfar_cof[15:8]    <=  W_Channel_data[7:0];
        7'd84:  O_cfar_cof[7:0]     <=  W_Channel_data[7:0];
        default:;
        endcase
    end
end
//------------------------------------------output------------------------------------------------
//----------------------------------------------------GMAC receive data----------------------------------------------------


//----------------------------------------------------RX232 data----------------------------------------------------
always @ (posedge I_sys_clk or negedge I_reset_n)
begin
    if(~I_reset_n)
    begin
        R_answer_rx_ena     <=  1'b0;
        R1_answer_rx_ena    <=  1'b0;
        R_answer_rx_dat     <=  1'b0;
    end
    else
    begin
        R_answer_rx_ena     <=  I_answer_rx_ena;
        R1_answer_rx_ena    <=  R_answer_rx_ena;
        R_answer_rx_dat     <=  I_answer_rx_dat;
    end                 
end

always @ (posedge I_sys_clk or negedge I_reset_n)
begin
    if(~I_reset_n)
    begin
        R_answer_dat    <=  64'h0;
    end
    else
    begin
        if(R_answer_rx_ena)
        begin
            R_answer_dat    <=  {R_answer_dat[63:1],R_answer_rx_dat};
        end
        else
        begin
            R_answer_dat    <=  64'h0;
        end
    end                 
end

always @ (posedge I_sys_clk or negedge I_reset_n)
begin
    if(~I_reset_n)
    begin
        R_reg_dat   <=  64'h0;
    end
    else
    begin
        if((~R_answer_rx_ena) && (R1_answer_rx_ena))
        begin
            R_reg_dat   <=  R_answer_dat;
        end
    end                 
end

always @ (posedge I_sys_clk or negedge I_reset_n)
begin
    if(~I_reset_n)
    begin
        R_machine_dat       <=  16'h0;
        R_array_data        <=  16'h0;
        R_selfchecking_ok   <=  1'b0;
        R_array_ack         <=  1'b0;
        R_clck_ld           <=  1'b0;
        R_model_selfcheking <=  1'b0;
        R_ctrl_data_ok      <=  1'b0;
    end
    else
    begin
        if(R_reg_dat[63:56] == 8'h5a)
        begin
            R_machine_dat       <=  R_reg_dat[55:40];
            R_array_data        <=  R_reg_dat[39:24];
            R_selfchecking_ok   <=  R_reg_dat[23];
            R_array_ack         <=  R_reg_dat[22];
            R_clck_ld           <=  R_reg_dat[21];
            R_model_selfcheking <=  R_reg_dat[20];
            R_ctrl_data_ok      <=  1'b1;
        end
        else
        begin
            R_machine_dat       <=  16'h0;
            R_array_data        <=  16'h0;
            R_selfchecking_ok   <=  1'b0;
            R_array_ack         <=  1'b0;
            R_clck_ld           <=  1'b0;
            R_model_selfcheking <=  1'b0;
            R_ctrl_data_ok      <=  1'b0;
        end
    end                 
end
//----------------------------------------------------RX232 data----------------------------------------------------


//----------------------------------------------------Rounding data----------------------------------------------------
always @ (posedge I_sys_clk or negedge I_reset_n)
begin
    if(~I_reset_n)
    begin
        R_time_cnt  <=  16'd0;
        R_add_ena   <=  1'b0;
    end
    else
    begin
        if(R_ctrl_data_ok)
        begin
            R_time_cnt  <=  16'd0;
            R_add_ena   <=  1'b0;
        end
        else if(R_time_cnt == 16'd49999)
        begin
            R_time_cnt  <=  16'd0;
            R_add_ena   <=  1'b1;
        end
        else
        begin
            R_time_cnt  <=  R_time_cnt + 16'd1;
            R_add_ena   <=  1'b0;
        end
    end
end

always @ (posedge I_sys_clk or negedge I_reset_n)
begin
    if(~I_reset_n)
    begin
        R_machine_angle <=  16'h0;
    end
    else
    begin
        if(R_ctrl_data_ok)
        begin
            R_machine_angle <=  R_machine_dat;
        end
        else if(R_add_ena)
        begin
            R_machine_angle <=  R_machine_angle + 16'd3;
        end
    end
end
//----------------------------------------------------Rounding data----------------------------------------------------


//----------------------------------------------------target data----------------------------------------------------
//====FPGA 1 data====
always @ (posedge I_sys_clk or negedge I_reset_n)
begin
    if(~I_reset_n)
    begin
        R_target_ena    <=  1'b0;
        R_target_data   <=  32'h0;
    end
    else
    begin
        R_target_ena    <=  I_target_ena;
        R_target_data   <=  {I_target_energy[23:8],3'b000,I_target_range};
    end
end

fifo_16x256 fifo_16x256_u1(
    .clk        (I_sys_clk      ),
    .rst        (~I_reset_n     ),
    .din        (R_target_data  ),
    .wr_en      (R_target_ena   ),
    .rd_en      (R_rd_fifo1_ena ),
    .dout       (W_fifo1_out_dat),
    .full       (),
    .empty      (),
    .prog_empty (W_fifo1_empty  )
    );
//====FPGA 1 data====


//====CFAR data====
always @ (posedge I_sys_clk or negedge I_reset_n)
begin
    if(~I_reset_n)
    begin
        R_cfar_ena      <=  1'b0;
        R_cfar_range    <=  14'b0;
        R_cfar_energy   <=  16'b0;
        R_cfar_speed    <=  6'b0;
    end
    else
    begin
        R_cfar_ena      <=  I_cfar_ena   ;
        R_cfar_range    <=  I_cfar_range ;
        R_cfar_energy   <=  I_cfar_energy;
        R_cfar_speed    <=  I_cfar_speed ;
    end
end

fifo_16x256 fifo_16x256_u2(
    .clk        (I_sys_clk                         ),
    .rst        (~I_reset_n                        ),
    .din        ({2'b00,R_cfar_range,R_cfar_energy}),
    .wr_en      (R_cfar_ena                        ),
    .rd_en      (R_rd_fifo2_ena                    ),
    .dout       (W_fifo2_out_dat                   ),
    .full       (),
    .empty      (),
    .prog_empty (W_fifo2_empty                     )
    );

fifo_16x256 fifo_16x256_u3(
    .clk        (I_sys_clk           ),
    .rst        (~I_reset_n          ),
    .din        ({26'h0,R_cfar_speed}),
    .wr_en      (R_cfar_ena          ),
    .rd_en      (R_rd_fifo2_ena      ),
    .dout       (W_fifo3_out_dat     ),
    .full       (),
    .empty      (),
    .prog_empty ()
    );
//====CFAR data====


//====write to fifo1====
always @ (posedge I_sys_clk or negedge I_reset_n)
begin
    if(~I_reset_n)
    begin
        R_rd_fifo1_ena  <=  1'b0;
        R_rd_fifo2_ena  <=  1'b0;
    end
    else
    begin
        R_rd_fifo1_ena  <=  (R_cnt_rd_num == 4'h9) && (~W_fifo1_empty);
        R_rd_fifo2_ena  <=  (R_cnt_rd_num == 4'h9) && (~W_fifo2_empty);
    end
end

always @ (posedge I_sys_clk or negedge I_reset_n)
begin
    if(~I_reset_n)
    begin
        R_cnt_rd_num    <=  4'hf;
    end
    else
    begin
        if(~(W_fifo1_empty && W_fifo2_empty))
        begin
            if(R_cnt_rd_num == 4'h9)
            begin
                R_cnt_rd_num    <=  4'h0;
            end
            else
            begin
                R_cnt_rd_num    <=  R_cnt_rd_num + 4'h1;
            end
        end
        else
        begin
            R_cnt_rd_num    <=  4'hf;
        end
    end
end

always @ (posedge I_sys_clk or negedge I_reset_n)
begin
    if(~I_reset_n)
    begin
        R_fifo1_wr_ena  <=  1'b0;
    end
    else
    begin
        R_fifo1_wr_ena  <=  (R_cnt_rd_num <= 4'h9);
    end
end

always @ (posedge I_sys_clk or negedge I_reset_n)
begin
    if(~I_reset_n)
    begin
        R1_target_num   <=  8'h00;
    end
    else
    begin
        if(~(|R_cnt_rd_num))
        begin
            R1_target_num   <=  R1_target_num + 8'h01;
        end
        else if(&R_cnt_rd_num)
        begin
            R1_target_num   <=  8'h00;
        end
    end
end

always @ (posedge I_sys_clk or negedge I_reset_n)
begin
    if(~I_reset_n)
    begin
        R_target_num    <=  8'h00;
    end
    else
    begin
        if(R_cnt_rd_num == 8'h01)
        begin
            R_target_num    <=  R1_target_num;
        end
    end
end

always @ (posedge I_sys_clk or negedge I_reset_n)
begin
    if(~I_reset_n)
    begin
        R_fifo_choose   <=  1'b0;
    end
    else
    begin
        R_fifo_choose   <=  W_fifo1_empty && (~W_fifo2_empty);
    end
end

always @ (posedge I_sys_clk or negedge I_reset_n)
begin
    if(~I_reset_n)
    begin
        R_fifo1_data    <=  8'h00;
    end
    else
    begin
        casez({R_fifo_choose,R_cnt_rd_num})
        5'b10000:   R_fifo1_data    <=  W_fifo2_out_dat[31:24];
        5'b10001:   R_fifo1_data    <=  W_fifo2_out_dat[23:16];
        5'b10010:   R_fifo1_data    <=  W_fifo3_out_dat[15:8];
        5'b10011:   R_fifo1_data    <=  W_fifo3_out_dat[7:0];
        5'b10100:   R_fifo1_data    <=  W_fifo2_out_dat[15:8];
        5'b10101:   R_fifo1_data    <=  W_fifo2_out_dat[7:0]; 
        5'b10110:   R_fifo1_data    <=  8'h00;
        5'b10111:   R_fifo1_data    <=  8'h00;
        5'b11000:   R_fifo1_data    <=  8'h00;
        5'b11001:   R_fifo1_data    <=  8'h00;
        5'b00000:   R_fifo1_data    <=  W_fifo1_out_dat[15:8];
        5'b00001:   R_fifo1_data    <=  W_fifo1_out_dat[7:0];
        5'b00010:   R_fifo1_data    <=  8'h00;
        5'b00011:   R_fifo1_data    <=  8'h00;
        5'b00100:   R_fifo1_data    <=  W_fifo1_out_dat[31:24];
        5'b00101:   R_fifo1_data    <=  W_fifo1_out_dat[23:16]; 
        5'b00110:   R_fifo1_data    <=  8'h00;
        5'b00111:   R_fifo1_data    <=  8'h00;
        5'b01000:   R_fifo1_data    <=  8'h00;
        5'b01001:   R_fifo1_data    <=  8'h00;
        default:    R_fifo1_data    <=  8'h00;
        endcase
    end
end
//====write to fifo1====
//----------------------------------------------------target data----------------------------------------------------


//-------------------------------------------------------GMAC transimit data-------------------------------------------------------
//---------------------fifo 1---------------------
gmac_tx_fifo    gmac_tx_fifo_u1(     //8*2048
    .rst        (~I_reset_n   ),
    .wr_clk     (I_sys_clk      ),
    .rd_clk     (I_tx_mac_aclk   ),
    .din        (R_fifo1_data   ),
    .wr_en      (R_fifo1_wr_ena ),
    .rd_en      (R_rd_fifo      ),
    .dout       (W_fifo_dout    ),
    .full       (),             
    .empty      (W1_prog_empty  ),
    .prog_full  (W1_prog_full   )
    );

always @ (posedge I_tx_mac_aclk or negedge I_reset_n)
begin
    if(~I_reset_n)
    begin
        R_wr_end    <=  1'b0;
        R1_wr_end   <=  1'b0;
    end
    else
    begin
        R_wr_end    <=  W1_prog_full;
        R1_wr_end   <=  R_wr_end;
    end
end
//---------------------fifo 1---------------------

//--------------------------MAC interface--------------------------
assign  W_mac_da_define         =   MAC_DA_DEFINE;
assign  W_mac_da_firstbyte      =   W_mac_da_define[47:40];
assign  W_mac_da_secondbyte     =   W_mac_da_define[39:32];
assign  W_mac_da_thirdbyte      =   W_mac_da_define[31:24];
assign  W_mac_da_forthbyte      =   W_mac_da_define[23:16];
assign  W_mac_da_fifthbyte      =   W_mac_da_define[15:8];
assign  W_mac_da_sixthbyte      =   W_mac_da_define[7:0];
                                
assign  W_mac_sa_define         =   MAC_SA_DEFINE;
assign  W_mac_sa_firstbyte      =   W_mac_sa_define[47:40];
assign  W_mac_sa_secondbyte     =   W_mac_sa_define[39:32];
assign  W_mac_sa_thirdbyte      =   W_mac_sa_define[31:24];
assign  W_mac_sa_forthbyte      =   W_mac_sa_define[23:16];
assign  W_mac_sa_fifthbyte      =   W_mac_sa_define[15:8]; 
assign  W_mac_sa_sixthbyte      =   W_mac_sa_define[7:0];  

assign  W_mac_length_define     =   PACKET_TYPE;
assign  W_mac_length_firstbyte  =   W_mac_length_define[7:0];
assign  W_mac_length_secondbyte =   W_mac_length_define[15:8];

always @ (posedge I_tx_mac_aclk or negedge I_reset_n)
begin
    if(~I_reset_n)
    begin
        R_gmac_work_ena <=  1'b0;
    end
    else
    begin
        if(R_wr_end && (~R1_wr_end))    //posedge to startup GMAC
        begin
            R_gmac_work_ena <=  1'b1;
        end
        else
        begin
            R_gmac_work_ena <=  1'b0;
        end
    end
end

always @ (posedge I_tx_mac_aclk or negedge I_reset_n)
begin
    if(~I_reset_n)
    begin
        R_cnt_packet_num    <=  11'h0;
    end
    else
    begin
        if(R_gmac_work_ena)
        begin
            R_cnt_packet_num    <=   11'h1;
        end
        else if(|R_cnt_packet_num)
        begin
            R_cnt_packet_num    <=  R_cnt_packet_num + 11'h1;
        end
    end
end

always @ (posedge I_tx_mac_aclk or negedge I_reset_n)
begin
    if(~I_reset_n)
    begin
        R_fifo2_wr_ena  <=  1'h0;
    end
    else
    begin
        if(R_gmac_work_ena)
        begin
            R_fifo2_wr_ena  <=   1'h1;
        end
        else if(R_cnt_packet_num == PACKET_LENGTH)
        begin
            R_fifo2_wr_ena  <=   1'h0;
        end
    end
end

always @ (posedge I_tx_mac_aclk or negedge I_reset_n)
begin
    if(~I_reset_n)
    begin
        R_data_fifoin   <=  8'h0;
    end
    else
    begin
        case(R_cnt_packet_num)
        11'd1:  R_data_fifoin   <=  W_mac_da_firstbyte;
        11'd2:  R_data_fifoin   <=  W_mac_da_secondbyte;
        11'd3:  R_data_fifoin   <=  W_mac_da_thirdbyte;
        11'd4:  R_data_fifoin   <=  W_mac_da_forthbyte;
        11'd5:  R_data_fifoin   <=  W_mac_da_fifthbyte;
        11'd6:  R_data_fifoin   <=  W_mac_da_sixthbyte;
        11'd7:  R_data_fifoin   <=  W_mac_sa_firstbyte; 
        11'd8:  R_data_fifoin   <=  W_mac_sa_secondbyte;
        11'd9:  R_data_fifoin   <=  W_mac_sa_thirdbyte; 
        11'd10: R_data_fifoin   <=  W_mac_sa_forthbyte; 
        11'd11: R_data_fifoin   <=  W_mac_sa_fifthbyte; 
        11'd12: R_data_fifoin   <=  W_mac_sa_sixthbyte; 
        11'd13: R_data_fifoin   <=  W_mac_length_firstbyte; 
        11'd14: R_data_fifoin   <=  W_mac_length_secondbyte;
        11'd15: R_data_fifoin   <=  R_machine_angle[15:8];
        11'd16: R_data_fifoin   <=  R_machine_angle[7:0];
        11'd17: R_data_fifoin   <=  R_array_angle[15:8];
        11'd18: R_data_fifoin   <=  R_array_angle[7:0];
        11'd19: R_data_fifoin   <=  R_target_num;
        11'd20: R_data_fifoin   <=  R_array_data[15:8];
        11'd21: R_data_fifoin   <=  R_array_data[7:0];
        11'd22: R_data_fifoin   <=  {4'h0,R_model_selfcheking,R_clck_ld,R_array_ack,R_selfchecking_ok};
        11'd23: R_data_fifoin   <=  8'h00;
        11'd24: R_data_fifoin   <=  8'h00;
        11'd25: R_data_fifoin   <=  8'h00;
        11'd26: R_data_fifoin   <=  8'h00;
        11'd27: R_data_fifoin   <=  8'h00;
        11'd28: R_data_fifoin   <=  8'h00;
        11'd29: R_data_fifoin   <=  8'h00;
        11'd30: R_data_fifoin   <=  8'h00;
        11'd31: R_data_fifoin   <=  8'h00;
        11'd32: R_data_fifoin   <=  8'h00;
        11'd33: R_data_fifoin   <=  8'h00;
        11'd34: R_data_fifoin   <=  8'h00;
        11'd35: R_data_fifoin   <=  8'h00;
        11'd36: R_data_fifoin   <=  8'h00;
        11'd37: R_data_fifoin   <=  8'h00;
        11'd38: R_data_fifoin   <=  8'h00;
        11'd39: R_data_fifoin   <=  8'h00;
        11'd40: R_data_fifoin   <=  8'h00;
        11'd41: R_data_fifoin   <=  8'h00;
        11'd42: R_data_fifoin   <=  8'h00;
        11'd43: R_data_fifoin   <=  8'h00;
        11'd44: R_data_fifoin   <=  8'h00;
        11'd45: R_data_fifoin   <=  W_fifo_dout;
        default:R_data_fifoin   <=  W_fifo_dout;
        endcase
    end
end

always @ (posedge I_tx_mac_aclk or negedge I_reset_n)
begin
    if(~I_reset_n)
    begin
        R_rd_fifo   <=  1'h0;
    end
    else
    begin
        if(R_cnt_packet_num == 11'd44)
        begin
            R_rd_fifo   <=   1'h1;
        end
        else if(W1_prog_empty)
        begin
            R_rd_fifo   <=   1'h0;
        end
    end
end

//---------------------fifo 2---------------------
gmac_tx_fifo    gmac_tx_fifo_u2(     //8*2048
    .rst        (~I_reset_n        ),
    .wr_clk     (I_tx_mac_aclk        ),
    .rd_clk     (I_tx_mac_aclk        ),
    .din        (R_data_fifoin       ),
    .wr_en      (R_fifo2_wr_ena      ),
    .rd_en      (I_tx_axis_mac_tvalid),
    .dout       (W_fifo2_dout        ),
    .full       (),             
    .empty      (W2_fifo_empty       ),
    .prog_full  (W2_prog_full        )
    );

//---------------------fifo 2---------------------


//-----------------------------output------------------------------
assign  O_tx_axis_mac_tuser =   1'b0;
assign  O_tx_axis_mac_tdata =   W_fifo2_dout;

always @ (posedge I_tx_mac_aclk or negedge I_reset_n)
begin
    if(~I_reset_n)
    begin
        O_tx_axis_mac_tready    <=  1'h0;
    end
    else
    begin
        O_tx_axis_mac_tready    <=  ~W2_fifo_empty;
    end
end

always @ (posedge I_tx_mac_aclk or negedge I_reset_n)
begin
    if(~I_reset_n)
    begin
        O_tx_axis_mac_tlast <=  1'h0;
    end
    else
    begin
        O_tx_axis_mac_tlast <=  (~W2_fifo_empty) && O_tx_axis_mac_tlast;
    end
end
//-----------------------------output------------------------------
//-------------------------------------------------------GMAC transimit data-------------------------------------------------------
endmodule
//====END====