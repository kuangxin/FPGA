`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    11:21:27 04/18/2016 
// Design Name: 
// Module Name:    serdes_range 
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
module serdes_range(
    I_serdes_rx_clk     ,
    I_sys_rst_n         ,
    I_serdes_rx_data    ,
    I_serdes_rx_en      ,
    I_sys_clk           ,
    O_range_data        ,
    O_range_en     
    );

input               I_serdes_rx_clk  ; 
input               I_sys_rst_n      ; 
input[15:0]         I_serdes_rx_data ; 
input               I_serdes_rx_en   ; 
input               I_sys_clk        ; 
output[12:0]        O_range_data     ; 
output              O_range_en       ; 

reg[63:0]           R_sync_data      ;
reg[15:0]           R_user_data      ;
reg                 R_wr_ena         ;
reg[12:0]           O_range_data     ;
reg                 O_range_en       ;
wire                W_rd_empty       ;
reg                 R_prog_full      ;
reg                 R1_prog_full     ;
wire[12:0]          W_fifo_out       ;
reg                 R_fifo_rd_en     ;
reg                 R1_fifo_rd_en    ;
                 
parameter       P_RX_SYNC    =   64'hf1ba_84ff_5a5a_6699;

always @ (posedge I_serdes_rx_clk or negedge I_sys_rst_n)
begin
    if(~I_sys_rst_n)
    begin
        R_sync_data <=  64'h0000_0000;
    end
    else
    begin
        R_sync_data <=  {R_sync_data[47:0],I_serdes_rx_data};
    end
end

always @ (posedge I_serdes_rx_clk or negedge I_sys_rst_n)
begin
    if(~I_sys_rst_n)
    begin
        R_user_data <=  16'd0;
    end
    else
    begin
        R_user_data <=  I_serdes_rx_data;
    end
end

always @ (posedge I_serdes_rx_clk or negedge I_sys_rst_n)
begin
    if(~I_sys_rst_n)
    begin
        R_wr_ena <= 1'b0;
    end
    else
    begin
        if(R_sync_data ==  P_RX_SYNC)
        begin
            R_wr_ena <= 1'b1;
        end
        else if(~I_serdes_rx_en)
        begin
            R_wr_ena <= 1'b0;
        end
    end
end

config_fifo u_config_fifo (
  .rst          (~I_sys_rst_n   ), // input rst
  .wr_clk       (I_serdes_rx_clk), // input wr_clk
  .rd_clk       (I_sys_clk      ), // input rd_clk
  .din          (R_user_data[12:0]), // input [12 : 0] din
  .wr_en        (R_wr_ena       ), // input wr_en
  .rd_en        (R_fifo_rd_en   ), // input rd_en
  .dout         (W_fifo_out     ), // output [12 : 0] dout
  .full         (), // output full
  .empty        (W_rd_empty     ) // output empty
);

always@(posedge I_sys_clk or negedge I_sys_rst_n)
begin
    if(~I_sys_rst_n)
    begin
        R_prog_full  <= 1'b0;   
        R1_prog_full <= 1'b0;
    end
    else
    begin     
        R_prog_full  <= R_wr_ena; 
        R1_prog_full <= R_prog_full; 
    end
end

always@(posedge I_sys_clk or negedge I_sys_rst_n)
begin
    if(~I_sys_rst_n)
    begin
        R_fifo_rd_en  <= 1'b0;   
    end
    else
    begin     
        if((~R_prog_full)&&(R1_prog_full))
        begin
            R_fifo_rd_en  <= 1'b1;  
        end
        else if(W_rd_empty)
        begin
            R_fifo_rd_en  <= 1'b0; 
        end
    end
end

always@(posedge I_sys_clk or negedge I_sys_rst_n)
begin
    if(~I_sys_rst_n)
    begin
        R1_fifo_rd_en  <= 1'b0;   
    end
    else
    begin     
        R1_fifo_rd_en  <= R_fifo_rd_en;   
    end
end

always@(posedge I_sys_clk or negedge I_sys_rst_n)
begin
    if(~I_sys_rst_n)
    begin
        O_range_data   <= 13'b0; 
        O_range_en     <= 1'b0;
    end
    else
    begin     
        O_range_data   <= W_fifo_out;
        O_range_en     <= R1_fifo_rd_en;
    end
end
endmodule
