`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Project Name :   
// Module  Name :   xadc_if.v
// Created On   :   2016/12/01 23:22 Thu
// Target Devices:
// Comments     :   
// ----------------------------------------------------------------------
// Revision History :
// ----------------------------------------------------------------------
//  Ver :           | Author:   kuangxin    | Mod. Date :    |    
//  Update Detail:                  | 
// ----------------------------------------------------------------------
// OverView
// ========
//
//////////////////////////////////////////////////////////////////////////////////
module xadc_if(
    input I_sys_clk, // Clock input for DRP
    input I_rst_n,
    
    output reg [15:0] temp_ave,temp_max,temp_min,
    output reg [15:0] vccint_ave,vccint_max,vccint_min,
    output reg [15:0] vcc_aux_ave,vcc_aux_max,vcc_aux_min,
    output reg [15:0] vcc_bram_ave,vcc_bram_max,vcc_bram_min
    );     

    wire busy;
    wire [5:0] channel;
    wire drdy;
    wire eoc;
    wire eos;
    wire i2c_sclk_in;
    wire i2c_sclk_ts;
    wire i2c_sda_in;
    wire i2c_sda_ts;
    
    
    reg [6:0] daddr;
    reg [15:0] di_drp;
    wire [15:0] do_drp;

    reg [1:0]  den_reg;
    reg [1:0]  dwe_reg;
    
    reg [7:0]   state = init_read;
    parameter       init_read       = 8'h00,
                    read_waitdrdy   = 8'h01,
                    write_waitdrdy  = 8'h03,
                    read_reg00      = 8'h04,
                    reg00_waitdrdy  = 8'h05,
                    read_reg01      = 8'h06,
                    reg01_waitdrdy  = 8'h07,
                    read_reg02      = 8'h08,
                    reg02_waitdrdy  = 8'h09,
                    read_reg06      = 8'h0a,
                    reg06_waitdrdy  = 8'h0b,
                    read_reg20      = 8'h0c,
                    reg20_waitdrdy  = 8'h0d,
                    read_reg21      = 8'h0e,
                    reg21_waitdrdy  = 8'h0f,
                    read_reg22      = 8'h10,
                    reg22_waitdrdy  = 8'h11,
                    read_reg23      = 8'h12,
                    reg23_waitdrdy  = 8'h13,
                    read_reg24      = 8'h14,
                    reg24_waitdrdy  = 8'h15,
                    read_reg25      = 8'h16,
                    reg25_waitdrdy  = 8'h17,
                    read_reg26      = 8'h18,
                    reg26_waitdrdy  = 8'h19,
                    read_reg27      = 8'h20,
                    reg27_waitdrdy  = 8'h21;
    
   always @(posedge I_sys_clk)
      if (~I_rst_n) begin
         state   <= init_read;
         den_reg <= 2'h0;
         dwe_reg <= 2'h0;
         di_drp  <= 16'h0000;
      end
      else
         case (state)
         init_read : begin
            daddr <= 7'h40;
            den_reg <= 2'h2; // performing read
            if (busy == 0 ) state <= read_waitdrdy;
            end
         read_waitdrdy : 
            if (eos ==1)  	begin
               di_drp <= do_drp  & 16'h03_FF; //Clearing AVG bits for Configreg0
               daddr <= 7'h40;
               den_reg <= 2'h2;
               dwe_reg <= 2'h2; // performing write
               state <= write_waitdrdy;
            end
            else begin
               den_reg <= { 1'b0, den_reg[1] } ;
               dwe_reg <= { 1'b0, dwe_reg[1] } ;
               state <= state;                
            end
         write_waitdrdy : 
            if (drdy ==1) begin
               state <= read_reg00;
               end
            else begin
               den_reg <= { 1'b0, den_reg[1] } ;
               dwe_reg <= { 1'b0, dwe_reg[1] } ;      
               state <= state;          
            end
         read_reg00 : begin
            daddr   <= 7'h00;
            den_reg <= 2'h2; // performing read
            if (eos == 1) state   <=reg00_waitdrdy;
            end
         reg00_waitdrdy : 
            if (drdy ==1)  	begin
               temp_ave <= do_drp; 
               state <=read_reg01;
               end
            else begin
               den_reg <= { 1'b0, den_reg[1] } ;
               dwe_reg <= { 1'b0, dwe_reg[1] } ;      
               state <= state;          
            end
         read_reg01 : begin
            daddr   <= 7'h01;
            den_reg <= 2'h2; // performing read
            state   <=reg01_waitdrdy;
            end
         reg01_waitdrdy : 
           if (drdy ==1)  	begin
               vccint_ave = do_drp; 
               state <=read_reg02;
               end
            else begin
               den_reg <= { 1'b0, den_reg[1] } ;
               dwe_reg <= { 1'b0, dwe_reg[1] } ;      
               state <= state;          
            end
         read_reg02 : begin
            daddr   <= 7'h02;
            den_reg <= 2'h2; // performing read
            state   <=reg02_waitdrdy;
            end
         reg02_waitdrdy : 
            if (drdy ==1)  	begin
               vcc_aux_ave <= do_drp; 
               state <=read_reg06;
               end
            else begin
               den_reg <= { 1'b0, den_reg[1] } ;
               dwe_reg <= { 1'b0, dwe_reg[1] } ;      
               state <= state;          
            end
         read_reg06 : begin
            daddr   <= 7'h06;
            den_reg <= 2'h2; // performing read
            state   <=reg06_waitdrdy;
            end
         reg06_waitdrdy : 
            if (drdy ==1)  	begin
               vcc_bram_ave <= do_drp; 
               state <= read_reg20;
            end
            else begin
               den_reg <= { 1'b0, den_reg[1] } ;
               dwe_reg <= { 1'b0, dwe_reg[1] } ;      
               state <= state;          
            end
         read_reg20 : begin
               daddr   <= 7'h20;
               den_reg <= 2'h2; // performing read
               state   <= reg20_waitdrdy;
            end
         reg20_waitdrdy : 
            if (drdy ==1)  	begin
               temp_max <= do_drp; 
               state <= read_reg21;
            end
            else begin
               den_reg <= { 1'b0, den_reg[1] } ;
               dwe_reg <= { 1'b0, dwe_reg[1] } ;      
               state <= state;          
            end
         read_reg21 : begin
            daddr   <= 7'h21;
            den_reg <= 2'h2; // performing read
            state   <= reg21_waitdrdy;
            end
         reg21_waitdrdy : 
            if (drdy ==1)  	begin
               vccint_max <= do_drp; 
               state <= read_reg22;
               end
            else begin
               den_reg <= { 1'b0, den_reg[1] } ;
               dwe_reg <= { 1'b0, dwe_reg[1] } ;      
               state <= state;          
            end
         read_reg22 : begin
            daddr   <= 7'h22;
            den_reg <= 2'h2; // performing read
            state   <= reg22_waitdrdy;
            end
         reg22_waitdrdy : 
            if (drdy ==1)  	begin
               vcc_aux_max <= do_drp; 
               state <= read_reg23;
               end
            else begin
               den_reg <= { 1'b0, den_reg[1] } ;
               dwe_reg <= { 1'b0, dwe_reg[1] } ;      
               state <= state;          
            end
         read_reg23 : begin
            daddr   <= 7'h23;
            den_reg <= 2'h2; // performing read
            state   <= reg23_waitdrdy;
            end
         reg23_waitdrdy :
            if (drdy ==1)  	begin
               vcc_bram_max <= do_drp; 
               state <=read_reg24;
               daddr   <= 7'h00;
            end
            else begin
               den_reg <= { 1'b0, den_reg[1] } ;
               dwe_reg <= { 1'b0, dwe_reg[1] } ;      
               state <= state;          
            end


         read_reg24 : begin
            daddr   <= 7'h24;
            den_reg <= 2'h2; // performing read
            state   <= reg24_waitdrdy;
            end
         reg24_waitdrdy :
            if (drdy ==1)   begin
               temp_min <= do_drp; 
               state <=read_reg25;
               daddr   <= 7'h00;
            end
            else begin
               den_reg <= { 1'b0, den_reg[1] } ;
               dwe_reg <= { 1'b0, dwe_reg[1] } ;      
               state <= state;          
            end


         read_reg25 : begin
            daddr   <= 7'h25;
            den_reg <= 2'h2; // performing read
            state   <= reg25_waitdrdy;
            end
         reg25_waitdrdy :
            if (drdy ==1)   begin
               vccint_min <= do_drp; 
               state <=read_reg26;
               daddr   <= 7'h00;
            end
            else begin
               den_reg <= { 1'b0, den_reg[1] } ;
               dwe_reg <= { 1'b0, dwe_reg[1] } ;      
               state <= state;          
            end

         read_reg26 : begin
            daddr   <= 7'h26;
            den_reg <= 2'h2; // performing read
            state   <= reg26_waitdrdy;
            end
         reg26_waitdrdy :
            if (drdy ==1)   begin
               vcc_aux_min <= do_drp; 
               state <=read_reg27;
               daddr   <= 7'h00;
            end
            else begin
               den_reg <= { 1'b0, den_reg[1] } ;
               dwe_reg <= { 1'b0, dwe_reg[1] } ;      
               state <= state;          
            end

         read_reg27 : begin
            daddr   <= 7'h27;
            den_reg <= 2'h2; // performing read
            state   <= reg27_waitdrdy;
            end
         reg27_waitdrdy :
            if (drdy ==1)   begin
               vcc_bram_min <= do_drp; 
               state <=read_reg00;
               daddr   <= 7'h00;
            end
            else begin
               den_reg <= { 1'b0, den_reg[1] } ;
               dwe_reg <= { 1'b0, dwe_reg[1] } ;      
               state <= state;          
            end


         default : begin
            daddr <= 7'h40;
            den_reg <= 2'h2; // performing read
            state <= init_read;
            end
         endcase

XADC #(// Initializing the XADC Control Registers
    .INIT_40(16'h9000),// averaging of 16 selected for external channels
    .INIT_41(16'h2ef0),// Continuous Seq Mode, Disable unused ALMs, Enable calibration
    .INIT_42(16'h0400),// Set DCLK divides
    .INIT_48(16'h4701),// CHSEL1 - enable Temp VCCINT, VCCAUX, VCCBRAM, and calibration
    .INIT_49(16'h000f),// CHSEL2 - enable aux analog channels 0 - 3
    .INIT_4A(16'h0000),// SEQAVG1 disabled
    .INIT_4B(16'h0000),// SEQAVG2 disabled
    .INIT_4C(16'h0000),// SEQINMODE0 
    .INIT_4D(16'h0000),// SEQINMODE1
    .INIT_4E(16'h0000),// SEQACQ0
    .INIT_4F(16'h0000),// SEQACQ1
    .INIT_50(16'hb5ed),// Temp upper alarm trigger 85°C
    .INIT_51(16'h5999),// Vccint upper alarm limit 1.05V
    .INIT_52(16'hA147),// Vccaux upper alarm limit 1.89V
    .INIT_53(16'hdddd),// OT upper alarm limit 125°C - see Thermal Management
    .INIT_54(16'ha93a),// Temp lower alarm reset 60°C
    .INIT_55(16'h5111),// Vccint lower alarm limit 0.95V
    .INIT_56(16'h91Eb),// Vccaux lower alarm limit 1.71V
    .INIT_57(16'hae4e),// OT lower alarm reset 70°C - see Thermal Management
    .INIT_58(16'h5999),// VCCBRAM upper alarm limit 1.05V
    .SIM_MONITOR_FILE("design.txt")// Analog Stimulus file for simulation
)
XADC_INST (// Connect up instance IO. See UG480 for port descriptions
    .CONVST (1'b0),// not used
    .CONVSTCLK  (1'b0), // not used
    .DADDR  (daddr),
    .DCLK   (I_sys_clk),
    .DEN    (den_reg[0]),
    .DI     (di_drp),
    .DWE    (dwe_reg[0]),
    .RESET  (~I_rst_n),
    .VAUXN  (),
    .VAUXP  (),
    .ALM    (),
    .BUSY   (busy),
    .CHANNEL(),
    .DO     (do_drp),
    .DRDY   (drdy),
    .EOC    (eoc),
    .EOS    (eos),
    .JTAGBUSY   (),// not used
    .JTAGLOCKED (),// not used
    .JTAGMODIFIED   (),// not used
    .OT     (),
    .MUXADDR    (),// not used
    .VP     (VP),
    .VN     (VN)
);

endmodule