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
module serdes_tran_ctrl(//==============system input================//
    I_rst_n             ,
    I_sys_clk           ,
    
    //===========accu_data if===============//
    I_angle_info        ,
    I_mode_info         ,
    I_M420_result_ena   ,
    I_M420_i_result_dat ,
    I_M420_q_result_dat ,     

    //===========cfar_target if==============//
    I_target_ena        ,
    I_target_energy     ,
    I_target_range      ,

    //===========serdes tx data==============//    
    I_tx_master_clk     ,
    O_tx1_is_k          ,
    O_tx1_serdes_dat    ,
    O_tx2_is_k          ,
    O_tx2_serdes_dat    ,
    O_tx3_is_k          ,
    O_tx3_serdes_dat    ,
    O_tx4_is_k          ,
    O_tx4_serdes_dat
    );

//------------------------------------------External Signal Definitions------------------------------------------
input           I_rst_n             ;
input           I_sys_clk           ;
input[4:0]      I_angle_info        ;
input[2:0]      I_mode_info         ;
input           I_M420_result_ena   ;
input[23:0]     I_M420_i_result_dat ;
input[23:0]     I_M420_q_result_dat ;
input           I_target_ena        ;
input[23:0]     I_target_energy     ;
input[12:0]     I_target_range      ; 

//===========serdes tx data==============//
input           I_tx_master_clk     ; 
output          O_tx1_is_k          ;
output[15:0]    O_tx1_serdes_dat    ;
output          O_tx2_is_k          ;
output[15:0]    O_tx2_serdes_dat    ;
output          O_tx3_is_k          ;
output[15:0]    O_tx3_serdes_dat    ;
output          O_tx4_is_k          ;
output[15:0]    O_tx4_serdes_dat    ;

//-----------------------------------------Internal Reg Definitions----------------------------------------------
wire[63:0]      W_M420_tx_rd_data   ;
reg[63:0]       R_M420_tx_rd_data   ;
wire[47:0]      W_M420_signaldata   ;
reg[47:0]       R_M420_signaldata   ;
reg[47:0]       R1_M420_signaldata  ;
reg[63:0]       R_M420_tx_wr_data   ;
reg             R_M420_tx_wr_en     ;
wire            W_M420_rd_empty     ;
wire            W_M420_rd_valid     ; 
reg             R_M420_rd_valid     ;
reg             R_M420_rd_empty     ;
reg             R_M420_tx_rd_en     ;
wire            W_M420_prog_full    ;
reg             R_M420_prog_full    ;
reg             R1_M420_prog_full   ;
reg             R_fifo_rd_start     ;
reg             R_M420_signal_ena   ;
reg             R1_M420_signal_ena  ;
reg[1:0]        R_M420_tx_cnt       ;
reg             R_M420_mode14_en    ;
reg             R_mode14_en         ;
reg             R1_mode14_en        ;
reg             R2_mode14_en        ;
reg             R_energy_ena        ;
reg             R1_energy_ena       ;
reg             R2_energy_ena       ;
reg             R3_energy_ena       ;
reg             R_mode2356_en       ;
reg             R1_mode2356_en      ;
reg             R2_mode2356_en      ;
wire[63:0]      W_tx_rd_data2       ;
wire[63:0]      W_energydata        ;
reg[63:0]       R_tx_wr_data2       ;
reg             R_tx_wr_en2         ;
wire            W_rd_empty2         ;
wire            W_rd_valid2         ;
reg[63:0]       R_tx_rd_data2       ;
reg             R_rd_valid2         ;
reg             R_rd_empty2         ;
reg             R_tx_rd_en2         ;
reg[63:0]       R_serdes_data       ;
reg             R_data_is_k         ;

//---------------------------------------------Main Body of Code---------------------------------------------------

assign W_M420_signaldata = {I_M420_i_result_dat,I_M420_q_result_dat};

//-------------tx i q result data to master 420T-------------//
always @(posedge I_sys_clk or negedge I_rst_n) 
begin
    if (~I_rst_n) 
    begin
        R_M420_tx_cnt       <= 2'd0;
        R_M420_signaldata   <=48'd0;
        R_M420_signal_ena   <= 1'b0;
    end
    else 
    begin
        if(I_M420_result_ena)
        begin
            R_M420_tx_cnt       <= R_M420_tx_cnt+1'b1;
            R_M420_signaldata   <= W_M420_signaldata ;
            R_M420_signal_ena   <= 1'b1;
        end
        else
        begin
            R_M420_tx_cnt       <= 2'd0;
            R_M420_signaldata   <=48'd0;
            R_M420_signal_ena   <= 1'b0;
        end
    end
end

always @(posedge I_sys_clk or negedge I_rst_n) 
begin
    if (~I_rst_n) 
    begin
        R1_M420_signaldata   <=48'd0;
        R1_M420_signal_ena   <= 1'b0;
    end
    else 
    begin
        if(R_M420_signal_ena)
        begin
            R1_M420_signaldata   <= R_M420_signaldata ;
            R1_M420_signal_ena   <= 1'b1;
        end
        else
        begin
            R1_M420_signaldata   <=48'd0;
            R1_M420_signal_ena   <= 1'b0;
        end
    end
end

always @(posedge I_sys_clk or negedge I_rst_n) 
begin
    if (~I_rst_n) 
    begin
        R_M420_tx_wr_data <= 64'd0;
        R_M420_tx_wr_en <= 1'b0;
    end
    else 
    begin
        if(R_M420_signal_ena)
        begin
            case(R_M420_tx_cnt)
            2'd1: 
            begin
                R_M420_tx_wr_data  <= {R1_M420_signaldata,R_M420_signaldata[47:32]};//48+16
                R_M420_tx_wr_en    <= 1'b1;
            end 
            2'd2: 
            begin
                R_M420_tx_wr_data  <= {R1_M420_signaldata[31:0],R_M420_signaldata[47:16]};//32+32
                R_M420_tx_wr_en    <= 1'b1;
            end 
            2'd3: 
            begin
                R_M420_tx_wr_data  <= {R1_M420_signaldata[15:0],R_M420_signaldata};//16+48
                R_M420_tx_wr_en    <= 1'b1;
            end 
            default: 
            begin
                R_M420_tx_wr_data <= 64'd0;//16+24+24
                R_M420_tx_wr_en   <= 1'b0;
            end
            endcase
        end
        else 
        begin
            R_M420_tx_wr_data  <= 64'd0;
            R_M420_tx_wr_en    <= 1'b0 ;
        end
    end
end

//  read me : 16384/156.25M*6.25M=655.36, need fifo 1024
//  read me : 8192/156.25M*6.25M=327.68, need fifo 1024
fifo_64x256 fifo_M420_signal(
    .rst            (~I_rst_n           ),
    .wr_clk         (I_sys_clk          ),//200M,write data rate is 3/4,so real clk is 150M
    .rd_clk         (I_tx_master_clk    ),//156.25M
    .din            (R_M420_tx_wr_data  ),
    .wr_en          (R_M420_tx_wr_en    ),
    .rd_en          (R_M420_tx_rd_en    ),
    .dout           (W_M420_tx_rd_data  ),
    .full           (                   ),
    .empty          (W_M420_rd_empty    ),
    .valid          (W_M420_rd_valid    ), // output valid
    .prog_full      (W_M420_prog_full   ) // output prog_full
    );

always @(posedge I_tx_master_clk or negedge I_rst_n) 
begin
    if (~I_rst_n) 
    begin
        R_M420_prog_full <= 1'b0;
        R1_M420_prog_full <= 1'b0;
    end
    else 
    begin
        R_M420_prog_full <= W_M420_prog_full ;
        R1_M420_prog_full <= R_M420_prog_full;
    end
end

always @(posedge I_tx_master_clk or negedge I_rst_n) 
begin
    if (~I_rst_n) 
    begin
        R_mode14_en     <= 1'b0;
        R1_mode14_en    <= 1'b0;
        R2_mode14_en    <= 1'b0;
    end
    else
    begin
        R_mode14_en     <= (R_M420_prog_full)&&(~R1_M420_prog_full) && (~W_M420_rd_valid);          //posedge of W_M420_prog_full
        R1_mode14_en    <= R_mode14_en;
        R2_mode14_en    <= R1_mode14_en;      
    end
end

always @(posedge I_tx_master_clk or negedge I_rst_n) 
begin
    if (~I_rst_n) 
    begin
        R_fifo_rd_start <= 1'b0;
    end
    else 
    begin
        if(R2_mode14_en)
        begin
            R_fifo_rd_start <= 1'b1;
        end
        else if(R_M420_rd_empty)
        begin
            R_fifo_rd_start <= 1'b0;
        end
    end
end

always @(posedge I_tx_master_clk or negedge I_rst_n) 
begin
    if (~I_rst_n) 
    begin
        R_M420_rd_empty <= 1'b0;
    end
    else 
    begin
        R_M420_rd_empty <= W_M420_rd_empty ;
    end
end

always @(posedge I_tx_master_clk or negedge I_rst_n) 
begin
    if (~I_rst_n) 
    begin
        R_M420_tx_rd_en <= 1'b0;
    end
    else 
    begin
        if((~R_M420_rd_empty)&&(R_fifo_rd_start))
        begin
            R_M420_tx_rd_en <= 1'b1;
        end
        else 
        begin
            R_M420_tx_rd_en <= 1'b0;
        end
    end
end
//-------------tx i q result data to master 420T-------------//


//------------------------------ MUX into tx_fifo ------------------------------//
//******************************************************************************
//                                energy TX part
//  read me :mode 1->8192 fft and mode 4->4096 fft,    energ<1000
//******************************************************************************
//------------------------------ MUX into signal_fifo ------------------------------//
assign W_energydata = {16'h0,I_mode_info,I_angle_info,I_target_energy,3'b0,I_target_range};//27+24+13

//------------------------------ MUX into tx_fifo ------------------------------//
always @(posedge I_sys_clk or negedge I_rst_n) 
begin
    if (~I_rst_n) 
    begin
        R_tx_wr_data2 <= 64'b0;
        R_tx_wr_en2   <= 1'b1 ;
    end
    else 
    begin
        R_tx_wr_data2 <= W_energydata;
        R_tx_wr_en2   <= I_target_ena;
    end
end
//------------------------------ energy fifo------------------------------//
fifo_64x512_energy u_fifo_energy(
    .rst            (~I_rst_n        ),
    .wr_clk         (I_sys_clk       ),//200M,write data rate is 3/4,so real clk is 150M
    .rd_clk         (I_tx_master_clk ),//156.25M
    .din            (R_tx_wr_data2   ),
    .wr_en          (R_tx_wr_en2     ),
    .rd_en          (R_tx_rd_en2     ),
    .dout           (W_tx_rd_data2   ),
    .full           (                ),
    .empty          (W_rd_empty2     ),
    .valid          (W_rd_valid2     ) // output valid
    );
//------------------------------ read from two fifo ------------------------------//

always @(posedge I_tx_master_clk or negedge I_rst_n) 
begin
    if (~I_rst_n) 
    begin
        R_rd_empty2 <= 1'b0;
    end
    else 
    begin
        R_rd_empty2 <= W_rd_empty2 ;
    end
end
    
always @(posedge I_tx_master_clk or negedge I_rst_n) 
begin
    if (~I_rst_n) 
    begin
        R_tx_rd_en2 <= 1'b0;
    end
    else 
    begin
        if(~R_rd_empty2)
        begin
            R_tx_rd_en2 <= 1'b1;
        end
        else 
        begin
            R_tx_rd_en2 <= 1'b0;
        end
    end
end

always @(posedge I_tx_master_clk or negedge I_rst_n) 
begin
    if (~I_rst_n) 
    begin
        R_energy_ena    <= 1'b0;
        R1_energy_ena   <= 1'b0;
        R2_energy_ena   <= 1'b0;
        R3_energy_ena   <= 1'b0;
    end
    else
    begin
        R_energy_ena    <= I_target_ena;
        R1_energy_ena   <= R_energy_ena;
        R2_energy_ena   <= R1_energy_ena || R_energy_ena;
        R3_energy_ena   <= R2_energy_ena;
    end
end

always @(posedge I_tx_master_clk or negedge I_rst_n) 
begin
    if (~I_rst_n) 
    begin
        R_mode2356_en   <= 1'b0;
        R1_mode2356_en  <= 1'b0;
        R2_mode2356_en  <= 1'b0;
    end
    else
    begin
        R_mode2356_en   <= R2_energy_ena && (~R3_energy_ena); 
        R1_mode2356_en  <= R_mode2356_en;
        R2_mode2356_en  <= R1_mode2356_en;       
    end
end
//------------------------------ read from two_fifo ------------------------------//

//------------------------------serdes tx ------------------------------//
always @(posedge I_tx_master_clk or negedge I_rst_n) 
begin
    if (~I_rst_n) 
    begin
        R_M420_tx_rd_data   <= 64'b0;
        R_tx_rd_data2       <= 64'b0;
        R_M420_rd_valid     <= 1'b0;
        R_rd_valid2         <= 1'b0;
    end
    else
    begin
        R_M420_tx_rd_data   <= W_M420_tx_rd_data ;
        R_tx_rd_data2       <= W_tx_rd_data2 ;
        R_M420_rd_valid     <= W_M420_rd_valid   ;
        R_rd_valid2         <= W_rd_valid2   ;     
    end
end

always @ (posedge I_tx_master_clk or negedge I_rst_n)
begin
    if(~I_rst_n)
    begin
        R_serdes_data   <=  64'h0000_0000_0000_0000;
        R_data_is_k     <=  1'b0;
    end
    else
    begin
        case({R_mode14_en,R1_mode14_en,R2_mode14_en,R_mode2356_en,R1_mode2356_en,R2_mode2356_en,R_M420_rd_valid,R_rd_valid2})
        8'b1000_0000:
        begin
            R_serdes_data   <=  64'h3c1c_3c1c_3c1c_3c1c;
            R_data_is_k     <=  1'b0;
        end
        8'b0100_0000:
        begin
            R_serdes_data   <=  64'h3c3c_3c3c_3c3c_3c3c;
            R_data_is_k     <=  1'b0;
        end
        8'b0010_0000:
        begin
            R_serdes_data   <=  64'h5c5c_5c5c_5c5c_5c5c;
            R_data_is_k     <=  1'b0;
        end
        8'b0001_0000:
        begin
            R_serdes_data   <=  64'h3c1c_3c1c_3c1c_3c1c;
            R_data_is_k     <=  1'b0;
        end
        8'b0000_1000:
        begin
            R_serdes_data   <=  64'h3c3c_3c3c_3c3c_3c3c;
            R_data_is_k     <=  1'b0;
        end
        8'b0000_0100:
        begin
            R_serdes_data   <=  64'h7c7c_7c7c_7c7c_7c7c;
            R_data_is_k     <=  1'b0;
        end
        8'b0000_0010:
        begin
            R_serdes_data <=  R_M420_tx_rd_data;
            R_data_is_k   <=  1'b1;              
        end
        8'b0000_0001:
        begin
            R_serdes_data <=  R_tx_rd_data2;
            R_data_is_k   <=  1'b1;  
        end
        default:
        begin            
            R_serdes_data   <=  64'hc5bc_c5bc_c5bc_c5bc;
            R_data_is_k     <=  1'b0;          
        end
        endcase       
    end
end

assign  O_tx1_is_k        =  R_data_is_k; 
assign  O_tx1_serdes_dat  =  {R_serdes_data[15:0]};
assign  O_tx2_is_k        =  R_data_is_k;
assign  O_tx2_serdes_dat  =  {R_serdes_data[31:16]};
assign  O_tx3_is_k        =  R_data_is_k;
assign  O_tx3_serdes_dat  =  {R_serdes_data[47:32]};
assign  O_tx4_is_k        =  R_data_is_k;
assign  O_tx4_serdes_dat  =  {R_serdes_data[63:48]};
endmodule