`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    2014/7/17 8:25
// Design Name: 
// Module Name:    serdes_k7_slave 
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
module serdes_k7_if(
    //----system reset----
    I_rst_n         ,
    
    //----serdes if----
    //----rx----
    I_serdes_rx_clk ,
    I_data_is_k     ,
    I_serdes_data   ,
    
    //----tx----
    I_serdes_tx_clk      ,
    O_serdes_data   ,
    O_data_is_k     ,
    
    //----user if----
    //====input====
    I_tx_user_data  ,
    I_tx_user_en    ,
    I_config_data   ,
    I_config_en     ,
    //====output====
    O_config_data   ,
    O_config_ena    ,
    O_user_data     ,
    O_data_ena      
    );

//============input===========
input       I_serdes_rx_clk ;
input       I_rst_n         ;
input[1:0]  I_data_is_k     ;
input[15:0] I_serdes_data   ;
input       I_serdes_tx_clk      ;
input[15:0] I_tx_user_data  ; 
input       I_tx_user_en    ; 
input[15:0] I_config_data   ;
input       I_config_en     ;

//============output==========
output[15:0]O_config_data   ;
output      O_config_ena    ;
output[15:0]O_user_data     ;
output      O_data_ena      ;
output[1:0] O_data_is_k     ;
output[15:0]O_serdes_data   ;

//============inter signal===========
(* KEEP = "TRUE" *)
reg [15:0] O_config_data;
(* KEEP = "TRUE" *)
reg O_config_ena;
(* KEEP = "TRUE" *)
reg [15:0] O_user_data;
(* KEEP = "TRUE" *)
reg       O_data_ena ;
reg [1:0] O_data_is_k;
(* KEEP = "TRUE" *)
reg [15:0] O_serdes_data ;
reg [15:0] R_serdes_data ;
reg [15:0] R1_serdes_data;
reg [ 1:0] R_data_is_k   ;
reg [ 1:0] R_data_sel    ;
reg [15:0] R_user_data   ;
reg        R_data_ena    ;
reg [63:0] R_rx_sync_data;
reg        R_rx_link     ;
reg        R_tx_link     ;
reg [ 2:0] R_tx_fsm_cnt  ;
reg        R_sync_config ;
reg [19:0] R_powerup_cnt ;
reg        R_powerup_ok  ;
reg        R1_powerup_ok ;
reg [63:0] R_tx_sync_data;
reg        R_config_en   ;
reg        R1_config_en  ;
reg [15:0] R_config_data   ;
wire W_powerup_ok ;
wire W_rx_link    ;
wire W_tx_link    ;
wire W_config_en  ;

parameter P_RX_SYNC     = 64'hf1ba_84ff_aacd_f355;
parameter P_TX_SYNC     = 64'hf1ba_84ff_aacd_2420;


//-----------------------------------------------------------------main code-----------------------------------------------------------------------------
//-------------------------------------serdes rx ------------------------------------
always @ (posedge I_serdes_rx_clk or negedge I_rst_n)
begin
    if(~I_rst_n)
    begin
        R_serdes_data   <=  16'h0000;
    end
    else
    begin
        R_serdes_data   <=  I_serdes_data;
    end
end

always @ (posedge I_serdes_rx_clk or negedge I_rst_n)
begin
    if(~I_rst_n)
    begin
        R_data_is_k  <=  0;
    end
    else
    begin
        R_data_is_k  <=  I_data_is_k;
    end
end

always @ (posedge I_serdes_rx_clk or negedge I_rst_n)
begin
    if(~I_rst_n)
    begin
        R_data_sel  <=  1'b0;
    end
    else
    begin
        if((R_data_is_k[0]) && (R_serdes_data[7:0] == 8'hbc))//comma BC appears in low byte, right mode
        begin
            R_data_sel  <=  2'b01;
        end
        else if((R_data_is_k[1]) && (R_serdes_data[15:8]== 8'hbc))//comma BC appears in high byte, need to be shift
        begin
            R_data_sel  <=  2'b10;
        end
    end
end

always @ (posedge I_serdes_rx_clk or negedge I_rst_n)
begin
    if(~I_rst_n)
    begin
        R1_serdes_data   <=  16'h0000;
    end
    else
    begin
        R1_serdes_data   <=  R_serdes_data;
    end
end

always @ (posedge I_serdes_rx_clk or negedge I_rst_n)
begin
    if(~I_rst_n)
    begin
        R_user_data <=  16'h0000;
        R_data_ena  <=  1'b0;
    end
    else
    begin
        if(R_data_sel == 2'b10)//comma BC appears in high byte, need to be shift
        begin
            R_user_data <=  {R_serdes_data[7:0],R1_serdes_data[15:8]};
            R_data_ena  <=  ~R_data_sel[1];
        end
        else
        begin
            R_user_data <=  R1_serdes_data;
            R_data_ena  <=  ~R_data_sel[0];
        end
    end
end

always @ (posedge I_serdes_rx_clk or negedge I_rst_n)
begin
    if(~I_rst_n)
    begin
        R_rx_sync_data <=  64'h0000_0000;
    end
    else
    begin
        R_rx_sync_data <=  {R_rx_sync_data[47:0],R_user_data};
    end
end

assign W_rx_link = (R_rx_sync_data ==  P_RX_SYNC);
always @ (posedge I_serdes_rx_clk or negedge I_rst_n)
begin
    if(~I_rst_n)
    begin
        R_rx_link <= 1'b0;
    end
    else
    begin
        if(W_rx_link)
        begin
            R_rx_link <= 1'b1;
        end
    end
end

assign W_tx_link = (R_rx_sync_data ==  P_TX_SYNC);
always @ (posedge I_serdes_rx_clk or negedge I_rst_n)
begin
    if(~I_rst_n)
    begin
        R_tx_link <= 1'b0;
    end
    else
    begin
        if(W_tx_link)
        begin
            R_tx_link <= 1'b1;
        end
    end
end

always @ (posedge I_serdes_rx_clk or negedge I_rst_n)
begin
    if(~I_rst_n)
    begin
        R_sync_config <= 1'b0;
    end
    else
    begin
        R_sync_config <= W_tx_link;
    end
end

always @ (posedge I_serdes_rx_clk or negedge I_rst_n)
begin
    if(~I_rst_n)
    begin
        O_config_data <= 16'h0;
    end
    else
    begin
        if(R_sync_config)
        begin
            O_config_data <= R_rx_sync_data[15:0];
        end
    end
end

always @ (posedge I_serdes_rx_clk or negedge I_rst_n)
begin
    if(~I_rst_n)
    begin
        O_config_ena  <= 1'b0;
    end
    else
    begin
        O_config_ena  <= R_sync_config;
    end
end

always @ (posedge I_serdes_rx_clk or negedge I_rst_n)
begin
    if(~I_rst_n)
    begin
        O_user_data <= 16'b0;
        O_data_ena  <= 1'b0;
    end
    else
    begin
        O_user_data <= R_user_data;
        O_data_ena  <= R_data_ena&&R_rx_link;
    end
end
//-------------------------------------serdes rx ------------------------------------

//-------------------------------------serdes tx-------------------------------------
assign W_powerup_ok = R_powerup_ok & (~R1_powerup_ok);
always @ (posedge I_serdes_tx_clk or negedge I_rst_n)
begin
    if(~I_rst_n)
    begin
        R_powerup_cnt   <=  20'd0;  
        R_powerup_ok    <=  1'b0;     
    end
    else
    begin        
        if(R_tx_link)
        begin
            R_powerup_cnt   <=  R_powerup_cnt;
            R_powerup_ok    <=  1'b1; 
        end
        else
        begin
            R_powerup_cnt   <=  R_powerup_cnt+1'b1;
            R_powerup_ok    <=  1'b0;
        end
    end
end

always @ (posedge I_serdes_tx_clk or negedge I_rst_n)
begin
    if(~I_rst_n)
    begin
        R1_powerup_ok    <=  1'b0;      
    end
    else
    begin
        R1_powerup_ok    <= R_powerup_ok;
    end
end



always @ (posedge I_serdes_tx_clk or negedge I_rst_n)
begin
    if(~I_rst_n)
    begin
        R_config_en   <=  1'b0;
        R1_config_en  <=  1'b0;
    end
    else
    begin        
        R_config_en   <=  I_config_en;
        R1_config_en  <=  R_config_en;
    end
end

always @ (posedge I_serdes_tx_clk or negedge I_rst_n)
begin
    if(~I_rst_n)
    begin
        R_config_data  <=  16'h0300;
    end
    else
    begin        
         if(R1_config_en)
         begin
            R_config_data  <=  I_config_data;
         end
    end
end
assign W_config_en = R_config_en &(~R1_config_en);

always @ (posedge I_serdes_tx_clk or negedge I_rst_n)
begin
    if(~I_rst_n)
    begin
        R_tx_fsm_cnt   <= 0;  
    end
    else
    begin
        if (W_powerup_ok | W_rx_link | W_config_en) 
        begin
            R_tx_fsm_cnt   <= 0;  
        end
        else if(&R_tx_fsm_cnt)
        begin
            R_tx_fsm_cnt <= R_tx_fsm_cnt;
        end
        else
        begin
            R_tx_fsm_cnt <= R_tx_fsm_cnt + 1'b1;
        end
    end
end

always @ (posedge I_serdes_tx_clk or negedge I_rst_n)
begin
    if(~I_rst_n)
    begin
        R_tx_sync_data <= 64'd0;        
    end
    else
    begin
        if (W_powerup_ok) 
        begin
            R_tx_sync_data <= P_RX_SYNC;  
        end
        else if(W_rx_link | R1_config_en)
        begin
            R_tx_sync_data <= P_TX_SYNC;
        end
    end
end

always @ (posedge I_serdes_tx_clk or negedge I_rst_n)
begin
    if(~I_rst_n)
    begin
        O_serdes_data   <=  16'hc5bc;
        O_data_is_k     <=  2'b01;
    end
    else
    begin
        case(R_tx_fsm_cnt)
        3'd0:
        begin
            O_serdes_data   <=  16'hc5bc;
            O_data_is_k     <=  2'b01;
        end
        3'd1:
        begin
            O_serdes_data   <=  R_tx_sync_data[63:48];
            O_data_is_k     <=  2'b00;
        end
        3'd2:
        begin
            O_serdes_data   <=  R_tx_sync_data[47:32];
            O_data_is_k     <=  2'b00;
        end
        3'd3:
        begin
            O_serdes_data   <=  R_tx_sync_data[31:16];
            O_data_is_k     <=  2'b00;
        end
        3'd4:
        begin
            O_serdes_data   <=  R_tx_sync_data[15:0];
            O_data_is_k     <=  2'b00;
        end
        3'd5:
        begin
            O_serdes_data   <=  R_config_data;
            O_data_is_k     <=  2'b00;
        end
        3'd6:
        begin
            O_serdes_data   <=  16'hc5bc;
            O_data_is_k     <=  2'b01;
        end
        3'd7:
        begin
            if(I_tx_user_en)
            begin                       
                O_serdes_data <=  {I_tx_user_data[7:0],I_tx_user_data[15:8]};
                O_data_is_k   <=  2'b00;      
            end
            else
            begin            
                O_serdes_data   <=  16'hc5bc;
                O_data_is_k     <=  2'b01;          
            end
        end
        endcase
    end
end
endmodule
//====END====