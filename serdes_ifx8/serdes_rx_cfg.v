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
module serdes_range
    (
        I_serdes_rx_clk     ,
        I_sys_rst_n         ,
        I_serdes_rx_data    ,
        I_serdes_rx_en      ,
        
        I_config_clk        ,
        O_config_data       ,
        O_config_en     
    );

input               I_serdes_rx_clk  ; 
input               I_sys_rst_n      ; 
input[15:0]         I_serdes_rx_data ; 
input               I_serdes_rx_en   ;                  
input               I_config_clk     ;    
output[7:0]         O_config_data    ;      
output              O_config_en      ; 

reg[7:0]            O_config_data    ;
reg                 O_config_en      ;

reg                 R_prog_full      ;
reg                 R1_prog_full     ;
wire[7:0]           W_fifo_out       ;
reg[7:0]            R_fifo_rd_cnt    ;
reg                 R_fifo_rd_en     ;
reg                 R1_fifo_rd_en    ;
                 

config_fifo u_config_fifo (
  .rst          (~I_sys_rst_n   ), // input rst
  .wr_clk       (I_serdes_rx_clk), // input wr_clk
  .rd_clk       (I_config_clk   ), // input rd_clk
  .din          (I_serdes_rx_data), // input [15 : 0] din
  .wr_en        (I_serdes_rx_en ), // input wr_en
  .rd_en        (R_fifo_rd_en   ), // input rd_en
  .dout         (W_fifo_out     ), // output [7 : 0] dout
  .full         (), // output full
  .empty        () // output empty
);

always@(posedge I_config_clk or negedge I_sys_rst_n)
begin
    if(~I_sys_rst_n)
    begin
        R_prog_full  <= 1'b0;   
        R1_prog_full <= 1'b0;
    end
    else
    begin     
        R_prog_full  <= I_serdes_rx_en; 
        R1_prog_full <= R_prog_full; 
    end
end

always@(posedge I_config_clk or negedge I_sys_rst_n)
begin
    if(~I_sys_rst_n)
    begin
        R_fifo_rd_cnt  <= 8'b0;   
    end
    else
    begin     
        if((~R_prog_full)&&(R1_prog_full))
        begin
            R_fifo_rd_cnt  <= 8'b1;  
        end
        else if(|R_fifo_rd_cnt)
        begin
            R_fifo_rd_cnt  <= R_fifo_rd_cnt+ 8'b1;
        end
        else
        begin
            R_fifo_rd_cnt  <= R_fifo_rd_cnt;  
        end
    end
end

always@(posedge I_config_clk or negedge I_sys_rst_n)
begin
    if(~I_sys_rst_n)
    begin
        R_fifo_rd_en  <= 1'b0;   
    end
    else
    begin     
        if((R_fifo_rd_cnt>=8'd1)&&(R_fifo_rd_cnt<=8'd180))
        begin
            R_fifo_rd_en  <= 1'b1;  
        end
        else
        begin
            R_fifo_rd_en  <= 1'b0; 
        end
    end
end

always@(posedge I_config_clk or negedge I_sys_rst_n)
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

always@(posedge I_config_clk or negedge I_sys_rst_n)
begin
    if(~I_sys_rst_n)
    begin
        O_config_data   <= 8'b0; 
        O_config_en     <= 1'b0;
    end
    else
    begin     
        O_config_data   <= W_fifo_out;
        O_config_en     <= R1_fifo_rd_en;
    end
end



endmodule
