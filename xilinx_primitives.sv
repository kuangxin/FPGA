

//******************************************************************************
//                               ISE UCF
//******************************************************************************












//******************************************************************************
//                               Vivado XDC
//******************************************************************************
(* dont_touch="true" *)
(* MARK_DEBUG="true" *)
(* keep="true" *)
(* keep_hierarchy="yes" *)
(* max_fanout=4 *)
(* ASYNC_REG="true" *)

set_property PACKAGE_PIN G21 [get_ports led]
set_property IOSTANDARD LVCMOS33 [get_ports led]

#primary clock for input pin I_SCLK
create_clock -period 10.000 [get_ports I_SCLK[0]]

#create clock for net W_uart_clk[0]
create_clock -period 60.000 [get_nets W_uart_clk_0]

#普通IO输入I_SCLK作为时钟
set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets I_SCLK_IBUF]


set_false_path -from [get_port I_rst_n] -to [all_registers]
set_clock_groups -asynchronous -group [get_clocks -include_generated_clocks gt_txclk] -group {I_SCLK_0 I_SCLK_1 I_SCLK_2 I_SCLK_3 I_SCLK_4}




#
set_property BITSTREAM.CONFIG.SPI_BUSWIDTH 4 [current_design]

#generate MCS file
write_cfgmem -force -format MCS -interface spix4 -size 512 -loadbit "up 0x0 \
    E:/FPGA/A7_changzhou_reset_n/changzhou.runs/impl_1/top.bit" \
    E:/FPGA/A7_changzhou_reset_n/changzhou.runs/impl_1