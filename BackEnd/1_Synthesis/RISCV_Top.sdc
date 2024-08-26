###################################################################

# Created by write_sdc on Thu Feb 20 02:49:52 2025

###################################################################
set sdc_version 2.1

set_units -time ns -resistance MOhm -capacitance fF -voltage V -current uA
create_clock [get_ports clk]  -period 20  -waveform {0 10}
set_clock_uncertainty 0.05  [get_clocks clk]
set_false_path -hold   -from [get_ports reset]
set_input_delay -clock clk  -max 1.5  [get_ports reset]
