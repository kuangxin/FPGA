`timescale 1ns / 1ps
`define DLY #1

//***********************************Entity Declaration*******************************
(* DowngradeIPIdentifiedWarnings="yes" *)
module serdes_GT_FRAME_GEN #
(
    // parameter to set the number of words in the BRAM
    parameter   WORDS_IN_BRAM =   512
)
(
   // User Interface
output reg  [15:0]  TX_DATA_OUT,
output reg  [1:0]   TXCTRL_OUT,

      // System Interface
input  wire         USER_CLK,
input  wire         SYSTEM_RESET 
); 


//********************************* Wire Declarations********************************* 

wire    [15:0]  tx_data_bram_i;
wire    [1:0]   tx_ctrl_i;

//***************************Internal Register Declarations*************************** 

reg     [8:0]   read_counter_i;
    reg     [23:0] rom [0:511];
reg     [23:0]  tx_data_ram_r;
(* ASYNC_REG = "TRUE" *) (* keep = "true" *)    reg     system_reset_r; 
(* ASYNC_REG = "TRUE" *) (* keep = "true" *)    reg     system_reset_r2; 


//*********************************Main Body of Code**********************************
    
    //___________ synchronizing the async reset for ease of timing simulation ________
    always@(posedge USER_CLK)
        begin
       system_reset_r <= `DLY SYSTEM_RESET;
       system_reset_r2 <= `DLY system_reset_r;
        end

    //____________________________ Counter to read from BRAM __________________________    

    always @(posedge USER_CLK)
        if(system_reset_r2 || (read_counter_i == "111111111"))  
        begin
             read_counter_i   <=  `DLY    9'd0;
        end
        else read_counter_i   <=  `DLY    read_counter_i + 9'd1;

    // Assign TX_DATA_OUT to BRAM output
    always @(posedge USER_CLK)
        if(system_reset_r2) TX_DATA_OUT <= `DLY 16'h0000; 
        else             TX_DATA_OUT <= `DLY tx_data_bram_i;   

    // Assign TXCTRL_OUT to BRAM output
    always @(posedge USER_CLK)
        if(system_reset_r2) TXCTRL_OUT <= `DLY 2'h0; 
        else             TXCTRL_OUT <= `DLY tx_ctrl_i;  


    //________________________________ BRAM Inference Logic _____________________________    

    assign tx_data_bram_i      = tx_data_ram_r[23:8];
    assign tx_ctrl_i           = tx_data_ram_r[1:0];
  
    initial
    begin
           $readmemh("gt_rom_init_tx.dat",rom,0,511);
    end

    always @(posedge USER_CLK)
           tx_data_ram_r <= `DLY rom[read_counter_i];

endmodule 
