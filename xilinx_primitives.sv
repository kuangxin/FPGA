
//******************************************************************************
//                               ISE UCF
//******************************************************************************
NET "W_200mhz_clk" TNM_NET = W_200mhz_clk;
TIMESPEC TS_W_200mhz_clk = PERIOD "W_200mhz_clk" 5ns HIGH 50%;


Net I_125mhz_clk     LOC = E20  | IOSTANDARD = LVCMOS33;









//******************************************************************************
//                               Vivado rtl Attribute
//******************************************************************************
(* dont_touch="true" *)
(* MARK_DEBUG="true" *)
(* keep="true" *)
(* keep_hierarchy="yes" *)
(* max_fanout=4 *)
(* ASYNC_REG="true" *)
(* EQUIVALENT_REGISTER_REMOVAL="NO" *)

//******************************************************************************
//                               Vivado XDC
//******************************************************************************
## Timing Assertions Section
# Primary clocks
create_clock -name I_SCLK_0 -period 10.000 [get_ports I_SCLK[0]]
#general io for clock input
set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets I_SCLK_IBUF]
#create clock for net W_uart_clk[0]
create_clock -period 60.000 [get_nets W_uart_clk_0]
#create clock for gtx
create_clock -name gt_txclk [get_pins -hier -filter {name=~*gt0_serdes_i*gtpe2_i*TXOUTCLK}]
# Virtual clocks
# Generated clocks
# Clock Groups
set_clock_groups -asynchronous -group [get_clocks -include_generated_clocks gt_txclk] -group {I_SCLK_0 I_SCLK_1 I_SCLK_2 I_SCLK_3 I_SCLK_4}
# Input and output delay constraints
set_input_delay 10 -clock [get_clocks I_SCLK_0] [get_ports I_FS[0]]
set_output_delay 0 -clock [get_clocks I_SCLK_4] [get_ports led]

## Timing Exceptions Section
# False Paths
set_false_path -from [get_port I_rst_n] -to [all_registers]
# Max Delay / Min Delay
# Multicycle Paths
# Case Analysis
# Disable Timing


## Physical Constraints Section
set_property PACKAGE_PIN G21 [get_ports led]
set_property IOSTANDARD LVCMOS33 [get_ports led]


## genarate bitstream
set_property BITSTREAM.CONFIG.SPI_BUSWIDTH 4 [current_design]



//******************************************************************************
//                               Vivado tcl
//******************************************************************************

##generate MCS file in vivado tcl
write_cfgmem -force -format MCS -interface spix4 -size 512 -loadbit "up 0x0 \
    E:/FPGA/A7_changzhou_reset_n/changzhou.runs/impl_1/top.bit" \
    E:/FPGA/A7_changzhou_reset_n/changzhou.runs/impl_1/top.mcs