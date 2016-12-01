`timescale 1ns / 1ps
module serdes_k7_if_tb;


    
reg I_serdes_rx_clk;
reg I_rst_n;
reg I_serdes_tx_clk;
reg I_tx_user_en;
reg I_config_en;

wire O_config_ena;
wire O_data_ena;
wire [15:0] O_config_data;
wire [15:0] O_user_data;
wire [1:0] O_data_is_k;
wire [15:0] O_serdes_data;

initial
begin
I_serdes_rx_clk =0;
I_rst_n =0;
I_serdes_tx_clk =0;
I_tx_user_en =0;
I_config_en =0;
#100 I_rst_n =1;
end

always@*
begin
    #5 I_serdes_rx_clk <= ~I_serdes_rx_clk;
end

always@*
begin
    #5 I_serdes_tx_clk <= ~I_serdes_tx_clk;
end

serdes_k7_if i_serdes_k7_if (
    .I_serdes_rx_clk(I_serdes_rx_clk),
    .I_rst_n        (I_rst_n        ),
    .I_serdes_tx_clk(I_serdes_tx_clk),
    .I_tx_user_en   (I_tx_user_en   ),
    .I_config_en    (I_config_en    ),
    .O_config_ena   (O_config_ena   ),
    .O_data_ena     (O_data_ena     ),
    .O_config_data  (O_config_data  ),
    .O_user_data    (O_user_data    ),
    .O_data_is_k    (O_data_is_k    ),
    .O_serdes_data  (O_serdes_data  )
);

endmodule
//====END====