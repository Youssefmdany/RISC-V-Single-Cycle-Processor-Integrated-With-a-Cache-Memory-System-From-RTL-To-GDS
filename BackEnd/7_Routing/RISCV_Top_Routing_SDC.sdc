################################################################################
#
# Design name:  Routing
#
# Created by icc2 write_sdc on Thu Feb 20 02:58:29 2025
#
################################################################################

set sdc_version 2.1
set_units -time ns -resistance MOhm -capacitance fF -voltage V -current uA

################################################################################
#
# Units
# time_unit               : 1e-09
# resistance_unit         : 1000000
# capacitive_load_unit    : 1e-15
# voltage_unit            : 1
# current_unit            : 1e-06
# power_unit              : 1e-12
################################################################################


# Mode: default
# Corner: default
# Scenario: default

# /home/ICer/ASIC/RISCV/output/RISCV_Top.sdc, line 9
create_clock -name clk -period 20 -waveform {0 10} [get_ports {clk}]
set_propagated_clock [get_clocks {clk}]
# /home/ICer/ASIC/RISCV/output/RISCV_Top.sdc, line 11
set_false_path -hold -from [get_ports {reset}]
# Set latency for io paths.
# -origin user
set_clock_latency -rise -min 0.0923972 [get_clocks {clk}]
# -origin user
set_clock_latency -rise -max 0.104976 [get_clocks {clk}]
# -origin user
set_clock_latency -fall -min 0.106023 [get_clocks {clk}]
# -origin user
set_clock_latency -fall -max 0.121926 [get_clocks {clk}]
# Set propagated on clock sources to avoid removing latency for IO paths.
set_propagated_clock  [get_ports {clk}]
set_clock_uncertainty 0.05 [get_clocks {clk}]
set_driving_cell -lib_cell NBUFFX4_HVT [get_ports {clk}]
# /home/ICer/ASIC/RISCV/output/RISCV_Top.sdc, line 12
set_input_delay -clock [get_clocks {clk}] -max 1.5 [get_ports {reset}]
