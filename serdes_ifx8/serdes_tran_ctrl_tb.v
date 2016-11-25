`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:16:32 04/15/2016 
// Design Name: 
// Module Name:    serdes_tran_ctrl 
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
module serdes_tran_ctrl_tb;



reg             I_rst_n           ;
reg             I_sys_clk         ;
reg             I_M420_result_ena  ;
reg[23:0]       I_M420_i_result_dat;
reg[23:0]       I_M420_q_result_dat;
reg             I_s_target_ena     ;
reg[23:0]       I_s_target_energy  ;
reg             I_target_ena      ;
reg[23:0]       I_target_energy   ;
reg[12:0]       I_target_range    ; 
//===========serdes tx data==============//
reg             I_tx_master_clk   ; 
wire            O_tx1_is_k        ;
wire[15:0]      O_tx1_serdes_dat  ;
wire            O_tx2_is_k        ;
wire[15:0]      O_tx2_serdes_dat  ;
wire            O_tx3_is_k        ;
wire[15:0]      O_tx3_serdes_dat  ;
wire            O_tx4_is_k        ;
wire[15:0]      O_tx4_serdes_dat  ;

parameter P_cycle1=2.5;
parameter P_cycle2=3.2;
initial
begin
    I_rst_n<=1'b0;
    I_sys_clk<=1'b1;
    I_tx_master_clk<=1'b1;
    I_M420_result_ena<=1'b0;
    I_M420_i_result_dat<=24'd0;
    I_M420_q_result_dat<=24'd0;
    I_s_target_ena<=1'b0;
    I_s_target_energy<=24'd0;
    I_target_ena<=1'b0;
    I_target_energy<=24'd0;
    I_target_range<=13'd0;
    #10 I_rst_n<=1'b1;
end

always
begin
    #P_cycle1  I_sys_clk =~I_sys_clk;
end

always
begin
    #P_cycle2  I_tx_master_clk =~I_tx_master_clk;
end

reg [14:0]count1;
always @(posedge I_sys_clk or negedge I_rst_n) 
begin
    if(~I_rst_n)
    begin
        count1<=15'd0;
    end
    else
    begin
        count1<=count1+1'b1;
    end
end

always @(posedge I_sys_clk or negedge I_rst_n) 
begin
    if(~I_rst_n)
    begin
        I_M420_result_ena<=1'b0;
        I_M420_i_result_dat<=24'd0;
        I_M420_q_result_dat<=24'd0;
    end
    else if(count1<=15'd16383)
    begin
        I_M420_result_ena<=1'b1;
        I_M420_i_result_dat<={9'd0,count1};
        I_M420_q_result_dat<={9'd0,count1};
    end
    else
    begin
        I_M420_result_ena<=1'b0;
        I_M420_i_result_dat<=24'd0;
        I_M420_q_result_dat<=24'd0;
    end
end

always @(posedge I_sys_clk or negedge I_rst_n) 
begin
    if(~I_rst_n)
    begin
        I_target_ena<=1'b0;
        I_target_energy<=24'd0;
        I_target_range<=13'd0;
    end
    else if(count1>=15'd16384 && count1<=15'd17407)
    begin
        I_target_ena<=1'b1;
        I_target_energy<={9'd0,count1};
        I_target_range<=count1[12:0];
    end
    else
    begin
        I_target_ena<=1'b0;
        I_target_energy<=24'd0;
        I_target_range<=13'd0;
    end
end

always @(posedge I_sys_clk or negedge I_rst_n) 
begin
    if(~I_rst_n)
    begin
        I_s_target_ena<=1'b0;
        I_s_target_energy<=24'd0;
    end
    else if(count1>=15'd17408 && count1<=15'd18431)
    begin
        I_s_target_ena<=1'b1;
        I_s_target_energy<={9'd0,count1};
    end
    else
    begin
        I_s_target_ena<=1'b0;
        I_s_target_energy<=24'd0;
    end
end










serdes_tran_ctrl serdes_tran_ctrl_u(//==============system input================//
    .I_rst_n             (I_rst_n),
    .I_sys_clk           (I_sys_clk),
//===========accu_data if===============//
    .I_M420_result_ena   (I_M420_result_ena),
    .I_M420_i_result_dat (I_M420_i_result_dat),
    .I_M420_q_result_dat (I_M420_q_result_dat),     
//===========cfar_target if==============//
    .I_s_target_ena      (I_s_target_ena),
    .I_s_target_energy   (I_s_target_energy),
    .I_target_ena        (I_target_ena),
    .I_target_energy     (I_target_energy),
    .I_target_range      (I_target_range),
//===========serdes tx data==============//    
    .I_tx_master_clk     (I_tx_master_clk),
    .O_tx1_is_k          (O_tx1_is_k),
    .O_tx1_serdes_dat    (O_tx1_serdes_dat),
    .O_tx2_is_k          (O_tx2_is_k),
    .O_tx2_serdes_dat    (O_tx2_serdes_dat),
    .O_tx3_is_k          (O_tx3_is_k),
    .O_tx3_serdes_dat    (O_tx3_serdes_dat),
    .O_tx4_is_k          (O_tx4_is_k),
    .O_tx4_serdes_dat    (O_tx4_serdes_dat)
       
    );

endmodule
