`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    2014/7/17 8:25
// Design Name: 
// Module Name:    serdes_k7_if 
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
    I_rst_n	        ,
    I_num_ena       ,
    
    //----serdes if----
    //----rx----
    I_serdes_rx_clk	,
    I_data_is_k	    ,
    I_serdes_data	,
    
    //----tx----
    I_user_clk      ,
    O_serdes_data   ,
    O_data_is_k     ,
    
    //----user if----
    //====input====
    I_tx_data       ,
    I_tx_ena        ,
    
    //====output====
    O_user_data	    ,
    O_data_ena      
    );

//============input===========
input	    I_serdes_rx_clk	;
input	    I_rst_n			;
input       I_num_ena       ;
input[1:0]	I_data_is_k	    ;
input[15:0]	I_serdes_data	;
input       I_user_clk      ;
input[15:0] I_tx_data       ;
input       I_tx_ena        ;

//============output==========
output[15:0]O_user_data	    ;
output      O_data_ena      ;
output[1:0] O_data_is_k     ;
output[15:0]O_serdes_data   ;

//============inter signal===========
reg[15:0]   O_user_data	    ;
reg         O_data_ena      ;
reg[1:0]    O_data_is_k     ;
reg[15:0]   O_serdes_data   ;
wire        W_data_is_k1    ;
wire        W_data_is_k2    ;
reg         R_data_is_k1    ;
reg         R1_data_is_k2   ;
reg         R_data_is_k2    ;
reg[15:0]   R_serdes_data   ;
reg         R_data_edge_on  ;
reg[9:0]    R_poweron_cnt   ;
reg         R_poweron_ok    ;
reg[2:0]    R_tx_cnt        ;
reg[7:0]    R_low_data      ;
reg         R_num_ena       ;
reg         R1_num_ena      ;
reg         R2_num_ena      ;
reg         R3_num_ena      ;
reg         R4_num_ena      ;
reg         R5_num_ena      ;

parameter       P_SYNC_DATA     =   48'hf1ba_84ff_aa69;



/////testy!
//-----------------------------------------------------------------main code-----------------------------------------------------------------------------
//-------------------------------------------RX----------------------------------------------
assign W_data_is_k1 = (I_data_is_k[0] == 1'b1) && (I_serdes_data[7:0] == 8'hbc)  ;

assign W_data_is_k2 = (I_data_is_k[1] == 1'b1) && (I_serdes_data[15:8]== 8'hbc)  ;

always @ (posedge I_serdes_rx_clk or negedge I_rst_n)
begin
    if(~I_rst_n)
    begin
        R_data_is_k1    <=  1'b0;
    end
    else
    begin
        R_data_is_k1    <=  W_data_is_k1;
    end
end

always @ (posedge I_serdes_rx_clk or negedge I_rst_n)
begin
    if(~I_rst_n)
    begin
        R_data_is_k2    <=  1'b0;
    end
    else
    begin
        R_data_is_k2    <=  W_data_is_k2;
    end
end

always @ (posedge I_serdes_rx_clk or negedge I_rst_n)
begin
    if(~I_rst_n)
    begin
        R1_data_is_k2   <=  1'b0;
    end
    else
    begin
        R1_data_is_k2   <=  R_data_is_k2;
    end
end

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
        R_low_data  <=  8'h00;
    end
    else
    begin
        R_low_data  <=  R_serdes_data[15:8];
    end
end

always @ (posedge I_serdes_rx_clk or negedge I_rst_n)
begin
    if(~I_rst_n)
    begin
        R_data_edge_on  <=  1'b0;
    end
    else
    begin
        if(R_data_is_k2)
        begin
            R_data_edge_on  <=  1'b0;
        end
        else if(R_data_is_k1)
        begin
            R_data_edge_on  <=  1'b1;
        end
    end
end

always @ (posedge I_serdes_rx_clk or negedge I_rst_n)
begin
    if(~I_rst_n)
    begin
        O_user_data <=  16'h0000;
        O_data_ena  <=  1'b0;
    end
    else
    begin
        if(~R_data_edge_on)
        begin
            O_user_data <=  {R_low_data,R_serdes_data[7:0]};
            O_data_ena  <=  ~R1_data_is_k2;
        end
        else
        begin
            O_user_data <=  {R_serdes_data[7:0],R_serdes_data[15:8]};
            O_data_ena  <=  ~R_data_is_k1;
        end
    end
end

always @ (posedge I_serdes_rx_clk or negedge I_rst_n)
begin
    if(~I_rst_n)
    begin
        R_num_ena   <=  1'b0;
        R1_num_ena  <=  1'b0;
        R2_num_ena  <=  1'b0;
    end
    else
    begin
        R_num_ena   <=  I_num_ena;
        R1_num_ena  <=  R_num_ena;
        R2_num_ena  <=  R1_num_ena || R_num_ena;
    end
end

//-------------------------------------------TX----------------------------------------------
always @ (posedge I_user_clk or negedge I_rst_n)
begin
    if(~I_rst_n)
    begin
        R3_num_ena  <=  1'b0;
        R4_num_ena  <=  1'b0;
        R5_num_ena  <=  1'b0;
    end
    else
    begin
        R3_num_ena  <=  R2_num_ena;
        R4_num_ena  <=  R3_num_ena;
        R5_num_ena  <=  R4_num_ena && (~R3_num_ena);
    end
end

always @ (posedge I_user_clk or negedge I_rst_n)
begin
    if(~I_rst_n)
    begin
        R_poweron_cnt   <=  10'h000;
    end
    else
    begin
        if(~(&R_poweron_cnt))
        begin
            R_poweron_cnt   <=  R_poweron_cnt + 10'h1;
        end
    end
end

always @ (posedge I_user_clk or negedge I_rst_n)
begin
    if(~I_rst_n)
    begin
        R_poweron_ok    <=  1'b0;
    end
    else
    begin
        if(R_poweron_cnt == 10'h3f0)
        begin
            R_poweron_ok    <=  1'b1;
        end
    end
end

always @ (posedge I_user_clk or negedge I_rst_n)
begin
    if(~I_rst_n)
    begin
        R_tx_cnt    <=  3'b0;
    end
    else
    begin
        if(R_poweron_ok && R5_num_ena)
        begin
            R_tx_cnt    <=  3'b1;
        end
        else if(|R_tx_cnt)
        begin
            R_tx_cnt    <=  R_tx_cnt + 3'b1;
        end
    end
end


always @ (posedge I_user_clk or negedge I_rst_n)
begin
    if(~I_rst_n)
    begin
        O_serdes_data   <=  16'h0000;
        O_data_is_k     <=  2'b00;
    end
    else
    begin
        if(I_tx_ena)
        begin
            O_serdes_data   <=  I_tx_data;
            O_data_is_k     <=  2'b00;
        end
        else
        begin
            case(R_tx_cnt)      //if sync
            3'b001:
            begin
                O_serdes_data   <=  16'hbaf1;
                O_data_is_k     <=  2'b00;
            end
            3'b010:
            begin
                O_serdes_data   <=  16'hff84;
                O_data_is_k     <=  2'b00;
            end
            3'b011:
            begin
                O_serdes_data   <=  16'h69aa;
                O_data_is_k     <=  2'b00;
            end
            default:
            begin
                O_serdes_data   <=  16'hc5bc;
                O_data_is_k     <=  2'b01;
            end
			endcase
        end
    end
end
endmodule
//====END====