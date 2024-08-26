# PT script

pt_shell


#assign search path  
set_app_var search_path "/home/ICer/Library_cells"

#assign target & Link  library 
set_app_var target_library "saed32hvt_ff0p95v125c.db    saed32hvt_ff1p16vn40c.db"

set_app_var link_library "* $target_library"

# Netlist Reading from ICC2
read_verilog /home/ICer/ASIC/RISCV/pnr/Routing/RISCV_Top_Routing_Netlist.v
link_design

# Reading parasitics & constrains
#read_parasitics  /home/ICer/ASIC/RISCV/pnr/Routing/RISCV_Top_Routing_Spef.spef.maxTLU_125.spef
read_parasitics  /home/ICer/ASIC/RISCV/pnr/Routing/RISCV_Top_Routing_Spef.spef.minTLU_125.spef
read_sdc /home/ICer/ASIC/RISCV/pnr/Routing/RISCV_Top_Routing_SDC.sdc
update_timing

# Checks 

report_timing
report_analysis_coverage
report_global_timing
report_clocks

report_constraint -all_violators -significant_digits 4 > /home/ICer/ASIC/RISCV/pnr/PrimeTime/RISCV_Top.min_constr.rpt
report_timing -delay_type min -nworst 40 -significant_digits 4 > /home/ICer/ASIC/RISCV/pnr/PrimeTime/RISCV_Top.min_timing.rpt

write_sdf /home/ICer/ASIC/RISCV/pnr/PrimeTime/RISCV_Top.min.sdf
